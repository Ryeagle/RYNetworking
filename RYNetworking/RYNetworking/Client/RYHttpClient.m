//
//  RYHttpClient.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYHttpClient.h"
#import "RYNetworkConfig.h"

@implementation RYHttpClient


#pragma mark - Public Methods

+ (RYNetworkRequest *)defaultConfigRequest {
    RYNetworkRequest *request = [[RYNetworkRequest alloc] init];
    [self configDefaultRequest:request];
    
    return request;
}

+ (void)configDefaultRequest:(RYNetworkRequest *)request {
    RYNetworkConfig *config = [RYNetworkConfig sharedInstance];
    request.baseUrl = config.baseUrl;
    request.timeoutInterval = config.timeoutInternalForRequest;
    request.allowsCellularAccess = config.allowsCellularAccess;
    request.requestSerializerType = config.requestSerializerType;
    request.responeseSerializerType = config.responeseSerializerType;
    request.headers = config.headers;
    request.parameters = config.parameters;
    request.sslPinningMode = config.sslPinningMode;
    request.certData = config.certData;
}

+ (void)cancelRequest:(RYNetworkRequest *)request {
    [[RYNetworkManager sharedManager] cancelRequest:request];
}

+ (void)cancelBathRequest:(RYBatchRequest *)batchRequest {
    for (RYNetworkRequest *request in batchRequest.requestArr) {
        [self cancelRequest:request];
    }
    
    [[RYBatchRequestManager sharedInstance] removeBatchRequest:batchRequest];
}

+ (void)cancelChainRequest:(RYChainRequest *)chainRequest {
    if (chainRequest.currentRequest) {
        [self cancelRequest:chainRequest.currentRequest];
    }
    [[RYChainRequestManager sharedInstance] removeChainRequest:chainRequest];
}

#pragma mark - Public Methods Custom Config

+ (RYNetworkRequest *)sendRequest:(RYHttpClientRequestBlock)requestBlock
                completionHandler:(RYNetworkResponseBlock)completionHandler {
    
    RYNetworkRequest *request = [[RYNetworkRequest alloc] init];
    if (requestBlock) {
        requestBlock(request);
    }
    
    [[RYNetworkManager sharedManager] sendRequest:request processBlock:nil completionHandler:completionHandler];
    
    return request;
}

+ (RYNetworkRequest *)sendRequest:(RYHttpClientRequestBlock)requestBlock
                        onProcess:(RYNetworkProgressBlock)progressBlock
                completionHandler:(RYNetworkResponseBlock)completionHandler {
    RYNetworkRequest *request = [[RYNetworkRequest alloc] init];
    if (requestBlock) {
        requestBlock(request);
    }
    
    [[RYNetworkManager sharedManager] sendRequest:request processBlock:progressBlock completionHandler:completionHandler];
    
    return request;
}

+ (RYBatchRequest *)sendBatchRequest:(RYHttpClientBacthRequestBlock)batchRequestBlock
                   completionHandler:(RYBatchRequestCompletionHandler)completionHandler {
    RYBatchRequest *batchRequest = [[RYBatchRequest alloc] init];
    [[RYBatchRequestManager sharedInstance] addBatchRequest:batchRequest];
    if (batchRequestBlock) {
        batchRequestBlock(batchRequest);
    }
    
    for (NSInteger i = 0; i < batchRequest.requestArr.count; i++) {
        RYNetworkRequest *request = [batchRequest.requestArr objectAtIndex:i];
        [[RYNetworkManager sharedManager] sendRequest:request processBlock:nil completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
            SEL resolveSelector = NSSelectorFromString(@"resolveWithResponse:error:completionHandler:");
            if ([batchRequest respondsToSelector:resolveSelector]) {
                IMP imp = [batchRequest methodForSelector:resolveSelector];
                void (*func)(id, SEL, RYNetworkResponse *, RYNetworkError *, RYBatchRequestCompletionHandler) = (void *)imp;
                func(batchRequest, resolveSelector, response, error, completionHandler);
            }
        }];
    }

    return batchRequest;
}

+ (RYChainRequest *)sendChainRequest:(RYHttpClientChainRequestBlock)chainRequestBlock
                   completionHandler:(RYChainRequestCompletionHandler)completionHandler {
    RYChainRequest *chainRequest = [[RYChainRequest alloc] init];
    [[RYChainRequestManager sharedInstance] addChainRequest:chainRequest];
    if (chainRequestBlock) {
        chainRequestBlock(chainRequest);
    }
    [self sendChainRequest:chainRequest withCompletionHandler:completionHandler];
    return chainRequest;
}

#pragma mark - Public Methods Default Config

+ (RYNetworkRequest *)GET:(NSString *)path
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
        completionHandler:(RYNetworkResponseBlock)completionHandler {
    return [self sendRequestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodGET type:RYNetworkRequestTypeNormal onProcess:nil completionHandler:completionHandler];
}

+ (RYNetworkRequest *)POST:(NSString *)path
                parameters:(NSDictionary *)parameters
                   headers:(NSDictionary *)headers
         completionHandler:(RYNetworkResponseBlock)completionHandler {
    return [self sendRequestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodPOST type:RYNetworkRequestTypeNormal onProcess:nil completionHandler:completionHandler];
}

+ (RYNetworkRequest *)HEAD:(NSString *)path
                parameters:(NSDictionary *)parameters
                   headers:(NSDictionary *)headers
         completionHandler:(RYNetworkResponseBlock)completionHandler {
    return [self sendRequestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodHEAD type:RYNetworkRequestTypeNormal onProcess:nil completionHandler:completionHandler];
}

+ (RYNetworkRequest *)DELETE:(NSString *)path
                  parameters:(NSDictionary *)parameters
                     headers:(NSDictionary *)headers
           completionHandler:(RYNetworkResponseBlock)completionHandler {
    return [self sendRequestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodDELETE type:RYNetworkRequestTypeNormal onProcess:nil completionHandler:completionHandler];
}

+ (RYNetworkRequest *)PUT:(NSString *)path
               parameters:(NSDictionary *)parameters
                  headers:(NSDictionary *)headers
        completionHandler:(RYNetworkResponseBlock)completionHandler {
    RYNetworkRequest * request = [self sendRequestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodPUT type:RYNetworkRequestTypeNormal onProcess:nil completionHandler:completionHandler];

    return request;
}

+ (RYNetworkRequest *)PATCH:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    headers:(NSDictionary *)headers
          completionHandler:(RYNetworkResponseBlock)completionHandler {
    RYNetworkRequest * request = [self sendRequestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodPATCH type:RYNetworkRequestTypeNormal onProcess:nil completionHandler:completionHandler];

    
    return request;
}

+ (RYNetworkRequest *)Upload:(NSString *)path
                  parameters:(NSDictionary *)parameters
                     headers:(NSDictionary *)headers
                   dataArray:(NSArray <RYUploadFormData *> *)array
                   onProcess:(RYNetworkProgressBlock)processBlock
           completionHandler:(RYNetworkResponseBlock)completionHandler {
    RYNetworkRequest * request = [self requestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodPOST type:RYNetworkRequestTypeUpload];
    request.uploadFormDatas = [array mutableCopy];

    [[RYNetworkManager sharedManager] sendRequest:request processBlock:processBlock completionHandler:completionHandler];

    return request;
}

+ (RYNetworkRequest *)DownLoad:(NSString *)path
              downloadSavePath:(NSString * _Nonnull)downloadSavePath
                    parameters:(NSDictionary *)parameters
                       headers:(NSDictionary *)headers
                     onProcess:(RYNetworkProgressBlock)processBlock
             completionHandler:(RYNetworkResponseBlock)completionHandler {
    NSParameterAssert(downloadSavePath.length);
    RYNetworkRequest * request = [self requestWithPath:path parameters:parameters headers:headers method:RYNetworkRequestMethodGET type:RYNetworkRequestTypeDownload];
    request.downloadSavePath = downloadSavePath;
    [[RYNetworkManager sharedManager] sendRequest:request processBlock:processBlock completionHandler:completionHandler];
    
    return request;
}


#pragma mark - Private Methods

+ (RYNetworkRequest *)requestWithPath:(NSString *)path
                            parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers
                                method:(RYNetworkRequestMethod)method
                                 type:(RYNetworkRequestType)type {
    RYNetworkRequest *request = [self defaultConfigRequest];
    request.type = type;
    request.apiPath = path;
    request.method = method;
    NSMutableDictionary *paraMulDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [paraMulDict addEntriesFromDictionary:request.parameters];
    request.parameters = [paraMulDict copy];
    
    NSMutableDictionary *headerMulDict = [NSMutableDictionary dictionaryWithDictionary:headers];
    [headerMulDict addEntriesFromDictionary:request.headers];
    request.headers = headerMulDict;

    return request;
}

+ (RYNetworkRequest *)sendRequestWithPath:(NSString *)path
                            parameters:(NSDictionary *)parameters
                                  headers:(NSDictionary *)headers
                                   method:(RYNetworkRequestMethod)method
                                     type:(RYNetworkRequestType)type
                                onProcess:(RYNetworkProgressBlock)processBlock
                        completionHandler:(RYNetworkResponseBlock)completionHandler {
    
    RYNetworkRequest *request = [self defaultConfigRequest];
    request.type = type;
    request.apiPath = path;
    request.method = method;
    NSMutableDictionary *paraMulDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [paraMulDict addEntriesFromDictionary:request.parameters];
    request.parameters = [paraMulDict copy];
    
    NSMutableDictionary *headerMulDict = [NSMutableDictionary dictionaryWithDictionary:headers];
    [headerMulDict addEntriesFromDictionary:request.headers];
    request.headers = headerMulDict;
    
    [[RYNetworkManager sharedManager] sendRequest:request processBlock:processBlock completionHandler:completionHandler];
    return request;
}

+ (void)sendChainRequest:(RYChainRequest *)chainRequest withCompletionHandler:(RYChainRequestCompletionHandler)completionHandler {
    if (chainRequest.currentRequest) {
        [[RYNetworkManager sharedManager] sendRequest:chainRequest.currentRequest processBlock:nil completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
            if (error) {
                chainRequest.currentRequest = nil;
                [[RYChainRequestManager sharedInstance] removeChainRequest:chainRequest];
                if (completionHandler) {
                    completionHandler(NO, chainRequest.responseArr, error);
                }
            } else {
                RYChainRequestBlock reqeustBlock =  [chainRequest.chainBlockArray firstObject];
                if (response) {
                    [chainRequest.responseArr addObject:response];
                }
                if (reqeustBlock) {
                    RYNetworkRequest *request = [[RYNetworkRequest alloc] init];
                    reqeustBlock(request, response);
                    chainRequest.currentRequest = request;
                    [chainRequest.chainBlockArray removeObjectAtIndex:0];
                    [self sendChainRequest:chainRequest withCompletionHandler:completionHandler];
                } else {
                    [[RYChainRequestManager sharedInstance] removeChainRequest:chainRequest];
                    if (completionHandler) {
                        completionHandler(YES, chainRequest.responseArr, error);
                    }
                }
            }
        }];
    }
}


@end
