//
//  RYNetworkManager.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//  Refences:
//  YTKNetworking
//  XMNetworking

#import "RYNetworkManager.h"
#import "AFNetworking.h"
#import "RYNetworkConst.h"
#import "RYNetworkTool.h"
#import "RYNetworkRequest.h"

static NSString *const kRYIncompleteDownloadFolderName =  @"RYDownloadIncomplete";

static dispatch_queue_t RY_network_manager_creation_queue() {
    static dispatch_queue_t _network_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _network_manager_creation_queue = dispatch_queue_create("com.RY.networking.manager.creation.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return _network_manager_creation_queue;
}


@interface RYNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *sslPinningManager;

@property (nonatomic, strong) NSArray *httpMethodArr;
@property (nonatomic, strong) NSIndexSet *statuCodeIndexSet;

@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *xmlResponseSerializer;
@property (nonatomic, strong) AFPropertyListResponseSerializer *plistResponseSerilizer;
@end

@implementation RYNetworkManager

#pragma mark - Life Cycle

+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _sessionManager.completionQueue = RY_network_manager_creation_queue();
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _statuCodeIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableStatusCodes = _statuCodeIndexSet;
    }
    
    return self;
}

#pragma mark - Public Methods

+ (instancetype)sharedManager {
    static RYNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void)sendRequest:(RYNetworkRequest *)request processBlock:(RYNetworkProgressBlock)progressBlock completionHandler:(RYNetworkResponseBlock)completionHandler {
    NSAssert(request != nil, @"The request can't be nil.");
    AFHTTPSessionManager *sessionManager;
    if (request.sslPinningMode == RYSSLPinningModeCertificate) {
        sessionManager = self.sslPinningManager;
        [self addSSLPinningCert:request.certData];
    } else {
        sessionManager = self.sessionManager;
    }
    switch (request.type) {
        case RYNetworkRequestTypeNormal:
            [self sendNormalRequest:request withSessonManager:sessionManager completionHandler:completionHandler];
            break;
        case RYNetworkRequestTypeUpload:
            [self sendUploadRequest:request withSessonManager:sessionManager progressBlock:progressBlock completionHandler:completionHandler];
            break;
        case RYNetworkRequestTypeDownload:
            [self sendDownloadRequest:request withSessonManager:sessionManager progressBlock:progressBlock completionHandler:completionHandler];
            break;
        default:
            break;
    }
}

- (void)cancelRequest:(RYNetworkRequest *)request {
    AFHTTPSessionManager *sessionManager = request.sslPinningMode == RYSSLPinningModeCertificate ? self.sslPinningManager : self.sessionManager;
    NSArray *taskArr =  sessionManager.tasks;
    for (NSURLSessionTask *task in taskArr) {
        if (task.taskIdentifier == request.requestIdentifier) {
            if (request.type == RYNetworkRequestTypeDownload && request.downloadSavePath) {
                NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)task;
                [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    NSURL *localUrl = [self incompleteDownloadTempPathForDownloadPath:request.downloadSavePath];
                    [resumeData writeToURL:localUrl atomically:YES];
                }];
            } else {
                [task cancel];
            }
            break;
        }
    }
}

- (RYNetworkReachabilityStatus)reachabilityStatus {
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

#pragma mark - Private Methods

- (void)sendNormalRequest:(RYNetworkRequest *)request withSessonManager:(AFHTTPSessionManager *)sessionManager completionHandler:(RYNetworkResponseBlock)completionHandler {
    NSError *requestError;
    
    AFHTTPRequestSerializer *reqeustSerializer = [self requestSerializerWithRequest:request];
    
    NSMutableURLRequest *urlRequest = [reqeustSerializer requestWithMethod:[self httpMethodWithRequest:request] URLString:[self getUrlWithRequest:request] parameters:request.parameters error:&requestError];
    if (requestError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler([RYNetworkResponse new], [RYNetworkError bulidNetworkError:requestError]);
            }
        });
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *sessionTask = [sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf resolveRequestResult:request response:response responseObject:responseObject error:error completionHandler:completionHandler];
    }];
    [request setValue:sessionTask forKey:@"currentTask"];
    [request setValue:@(sessionTask.taskIdentifier) forKey:@"requestIdentifier"];
    [sessionTask resume];
}

- (void)sendUploadRequest:(RYNetworkRequest *)request withSessonManager:(AFHTTPSessionManager *)sessionManager progressBlock:(RYNetworkProgressBlock)progressBlock completionHandler:(RYNetworkResponseBlock)completionHandler {
    __block NSError *serializeationError = nil;
    __block NSError *fileError = nil;
    
    RYNetworkError *networkError = nil;
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestSerializer *reqeustSerializer = [self requestSerializerWithRequest:request];

    NSMutableURLRequest *urlRequest = [reqeustSerializer multipartFormRequestWithMethod:@"POST" URLString:[self getUrlWithRequest:request] parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [weakSelf formData:formData withRequest:request fileError:&fileError];
    } error:&serializeationError];
    
    if (fileError) {
        networkError = [RYNetworkError bulidNetworkError:fileError];
    } else if (serializeationError) {
        networkError = [RYNetworkError bulidNetworkError:serializeationError];
    }
    
    if (networkError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock([NSProgress new]);
            }
            if (completionHandler) {
                completionHandler([RYNetworkResponse new], networkError);
            }
        });
        return;
    }
    
    NSURLSessionUploadTask *uploadTask = nil;
    uploadTask = [sessionManager uploadTaskWithStreamedRequest:urlRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf resolveRequestResult:request response:response responseObject:responseObject error:error completionHandler:completionHandler];
    }];
    [request setValue:@(uploadTask.taskIdentifier) forKey:@"requestIdentifier"];
    [request setValue:uploadTask forKey:@"currentTask"];
    [uploadTask resume];
}

- (void)sendDownloadRequest:(RYNetworkRequest *)request withSessonManager:(AFHTTPSessionManager *)sessionManager progressBlock:(RYNetworkProgressBlock)progressBlock completionHandler:(RYNetworkResponseBlock)completionHandler {
    AFHTTPRequestSerializer *reqeustSerializer = [self requestSerializerWithRequest:request];

    __block NSError *serializeationError = nil;
    NSMutableURLRequest *urlRequest = [reqeustSerializer requestWithMethod:@"GET" URLString:[self getUrlWithRequest:request] parameters:request.parameters error:&serializeationError];
    
    if (serializeationError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock([NSProgress new]);
            }
            if (completionHandler) {
                completionHandler([RYNetworkResponse new], [RYNetworkError bulidNetworkError:serializeationError]);
            }
        });
        return;
    }
    
    // From YTKNetwork
    
    NSString *downloadFileSavePath;
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:request.downloadSavePath isDirectory:&isDir]) {
        isDir = NO;
    }
    
    if (isDir) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadFileSavePath = [NSString pathWithComponents:@[request.downloadSavePath, fileName]];
        request.downloadSavePath = downloadFileSavePath;
    } else {
        downloadFileSavePath = request.downloadSavePath;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadFileSavePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadFileSavePath error:nil];
    }
    
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:request.downloadSavePath].path];
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:request.downloadSavePath]];
    BOOL resumeDataIsValid = [RYNetworkTool validateResumeData:data];
    
    BOOL resumeSucceeded = NO;
    NSURLSessionDownloadTask *downloadTask = nil;
    if (resumeDataFileExists && resumeDataIsValid) {
        @try {
            downloadTask = [sessionManager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(downloadProgress);
                    }
                });
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadFileSavePath isDirectory:NO];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self resolveRequestResult:request response:response responseObject:filePath error:error completionHandler:completionHandler];
            }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            RYNetworkLog(@"Resume download failed, reason = %@", exception.reason);
            resumeSucceeded = NO;
        }
    }
    
    if (!resumeSucceeded) {
        downloadTask = [sessionManager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) {
                    progressBlock(downloadProgress);
                }
            });
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadFileSavePath isDirectory:NO];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [self resolveRequestResult:request response:response responseObject:filePath error:error completionHandler:completionHandler];
        }];
    }
    
    [request setValue:@(downloadTask.taskIdentifier) forKey:@"requestIdentifier"];
    [request setValue:downloadTask forKey:@"currentTask"];
    [downloadTask resume];
    
}

#pragma mark - Resolve Request Result

- (void)resolveRequestResult:(RYNetworkRequest *)request response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error completionHandler:(RYNetworkResponseBlock)completionHandler {
    NSError * __autoreleasing validationError = nil;
    RYNetworkResponse *RYResponse = [RYNetworkResponse responseWithURLResponse:response resonseOjbect:responseObject responseType:request.responeseSerializerType responseSerializer:[self responseSerializerWithRequest:request] validationError:&validationError];

    RYNetworkError *RYError = nil;
    if (error) {
        RYError = [RYNetworkError bulidNetworkError:error];
    } else if (validationError) {
        RYError = [RYNetworkError bulidNetworkError:validationError];
    }
    
    RYNetworkLog(@"RYNetworing URLResponse:\n%@", response);

    if (RYError) {
        NSData *incompleteDownloadData = RYError.userInfo[NSURLSessionDownloadTaskResumeData];
        if (incompleteDownloadData) {
            [incompleteDownloadData writeToURL:[self incompleteDownloadTempPathForDownloadPath:request.downloadSavePath] atomically:YES];
        }
        RYNetworkLog(@"RYNetworing Error:%@\n%@", RYError.titleForError, RYError);
    } else {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            @try{
                RYNetworkLog(@"RYNetworking Json Result:\n%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            } @catch (NSException *exception) {
            }
        }
    }
    
    if (completionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(RYResponse, RYError);
        });
    }
}


#pragma mark - Helper

- (void)addSSLPinningCert:(NSData *)cert {
    NSAssert(cert != nil, @"The cert data can't be nil.");

    NSMutableSet *certSet;
    if (self.sslPinningManager.securityPolicy.pinnedCertificates.count > 0) {
        certSet = [NSMutableSet setWithSet:self.sslPinningManager.securityPolicy.pinnedCertificates];
    } else {
        certSet = [NSMutableSet set];
    }
    [certSet addObject:cert];
    [self.sslPinningManager.securityPolicy setPinnedCertificates:certSet];
}

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:kRYIncompleteDownloadFolderName];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        RYNetworkLog(@"Failed to create cache directory at %@", cacheFolder);
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    NSString *md5URLString = [RYNetworkTool md5StringFromString:downloadPath];
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
    
}

- (void)formData:(id<AFMultipartFormData>)formData withRequest:(RYNetworkRequest *)request fileError:(NSError * _Nullable __autoreleasing *)fileError {
    for (NSInteger i = 0; i < request.uploadFormDatas.count; i++)  {
        RYUploadFormData *RYFormData = [request.uploadFormDatas objectAtIndex:i];
        if (RYFormData.fileData) {
            if (RYFormData.fileName && RYFormData.mimeType) {
                [formData appendPartWithFileData:RYFormData.fileData name:RYFormData.name fileName:RYFormData.fileName mimeType:RYFormData.mimeType];
            } else {
                [formData appendPartWithFormData:RYFormData.fileData name:RYFormData.name];
            }
        } else if (RYFormData.fileURL){
            if (RYFormData.fileName && RYFormData.mimeType) {
                [formData appendPartWithFileURL:RYFormData.fileURL name:RYFormData.name fileName:RYFormData.fileName mimeType:RYFormData.mimeType error:fileError];
            } else {
                [formData appendPartWithFileURL:RYFormData.fileURL name:RYFormData.name error:fileError];
            }
            if (fileError) {
                break;
            }
        }
    }
}

- (NSString *)getUrlWithRequest:(RYNetworkRequest *)request {
    NSAssert(request != nil, @"The request can't be nil.");
    NSString *urlStr = request.urlStr;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    if (url && url.host && url.scheme) {
        return urlStr;
    }
    
    NSAssert(request.baseUrl.length > 0, @"The base Url can't be null.");
   
    if (request.apiPath.length) {
        NSURL *baseURL = [NSURL URLWithString:request.baseUrl];
        if (baseURL.path.length > 0 && ![baseURL.absoluteString hasPrefix:@"/"]) {
            baseURL = [baseURL URLByAppendingPathComponent:@""];
        }
        
        urlStr = [NSURL URLWithString:request.apiPath relativeToURL:baseURL].absoluteString;
    } else {
        urlStr = request.baseUrl;
    }
    
    NSAssert(urlStr.length > 0, @"The request's urlStr can't be null.");
    return urlStr;
}

- (NSString *)httpMethodWithRequest:(RYNetworkRequest *)request {
    NSString *method = @"GET";
    
    if (request.method < self.httpMethodArr.count) {
        method = [self.httpMethodArr objectAtIndex:request.method];
    }
    
    return method;
}

- (AFHTTPRequestSerializer *)requestSerializerWithRequest:(RYNetworkRequest *)request {
    AFHTTPRequestSerializer *requestSerializer  = [AFHTTPRequestSerializer serializer];
    switch (request.requestSerializerType) {
        case RYNetworkRequestSerializerTypeHTTP:
            requestSerializer =  [AFHTTPRequestSerializer serializer];
            break;
        case RYNetworkRequestSerializerTypeJSON:
            requestSerializer =  [AFJSONRequestSerializer serializer];
            break;
        case RYNetworkRequestSerializerTypePlist:
            requestSerializer =  [AFPropertyListRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    for (NSString *key in request.headers.allKeys) {
        [requestSerializer setValue:request.headers[key] forHTTPHeaderField:key];
    }
    requestSerializer.timeoutInterval = request.timeoutInterval;
    requestSerializer.allowsCellularAccess = request.allowsCellularAccess;
    
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializerWithRequest:(RYNetworkRequest *)request {
    switch (request.responeseSerializerType) {
        case RYNetworkResponseSerializerTypeHTTP:
            break;
        case RYNetworkResponseSerializerTypeJSON:
            return self.jsonResponseSerializer;
        case RYNetworkResponseSerializerTypePlist:
            return self.plistResponseSerilizer;
        case RYNetworkResponseSerializerTypeXMLParser:
            return self.xmlResponseSerializer;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - Accessors

- (NSArray *)httpMethodArr {
    if (!_httpMethodArr) {
        _httpMethodArr = @[@"GET", @"POST", @"HEAD", @"PUT", @"DELETE", @"PATCH"];
    }
    
    return _httpMethodArr;
}

- (AFHTTPSessionManager *)sslPinningManager {
    if (!_sslPinningManager) {
        _sslPinningManager = [AFHTTPSessionManager manager];
        _sslPinningManager.operationQueue.maxConcurrentOperationCount = 5;
        _sslPinningManager.completionQueue = RY_network_manager_creation_queue();
        _sslPinningManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sslPinningManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

        _sslPinningManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sslPinningManager.responseSerializer.acceptableStatusCodes = _statuCodeIndexSet;
    }
    
    return _sslPinningManager;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    }
    
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlResponseSerializer {
    if (!_xmlResponseSerializer) {
        _xmlResponseSerializer = [AFXMLParserResponseSerializer serializer];
        _xmlResponseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    }
    
    return _xmlResponseSerializer;
}

- (AFPropertyListResponseSerializer *)plistResponseSerilizer {
    if (!_plistResponseSerilizer) {
        _plistResponseSerilizer = [AFPropertyListResponseSerializer serializer];
        _plistResponseSerilizer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    }
    
    return _plistResponseSerilizer;
}

@end
