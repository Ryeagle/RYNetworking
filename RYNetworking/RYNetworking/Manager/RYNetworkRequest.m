//
//  RYNetworkRequest.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYNetworkRequest.h"

@interface RYNetworkRequest()
@property (nonatomic, strong) NSURLSessionTask *currentTask;
@end

@implementation RYNetworkRequest


- (instancetype)init {
    if (self = [super init]) {
        _method = RYNetworkRequestMethodGET;
        _requestSerializerType = RYNetworkRequestSerializerTypeJSON;
        _responeseSerializerType = RYNetworkResponseSerializerTypeJSON;
        _allowsCellularAccess = YES;
        _timeoutInterval = 60;
    }
    
    return self;
}

- (RYRequestState)state {
    return @(self.currentTask.state).integerValue;
}

#pragma mark - Public Methods

- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData {
    RYUploadFormData *formData = [RYUploadFormData formDataWithName:name fileData:fileData];
    [self.uploadFormDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    RYUploadFormData *formData = [RYUploadFormData formDataWithName:name fileName:fileName mimeType:mimeType fileData:fileData];
    [self.uploadFormDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    RYUploadFormData *formData = [RYUploadFormData formDataWithName:name fileURL:fileURL];
    [self.uploadFormDatas addObject:formData];
}

- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    RYUploadFormData *formData = [RYUploadFormData formDataWithName:name fileName:fileName mimeType:mimeType fileURL:fileURL];
    [self.uploadFormDatas addObject:formData];
}


#pragma mark - Private Methods


#pragma mark - Accessors

- (NSMutableArray<RYUploadFormData *> *)uploadFormDatas {
    if (!_uploadFormDatas) {
        _uploadFormDatas = [NSMutableArray array];
    }
    
    return _uploadFormDatas;
}

@end


@implementation RYUploadFormData

#pragma mark - Public Methods

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData {
    return [self formDataWithName:name fileName:nil mimeType:nil fileData:fileData fileURL:nil];
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData {
    return [self formDataWithName:name fileName:fileName mimeType:mimeType fileData:fileData fileURL:nil];
}

+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL {
    return [self formDataWithName:name fileName:nil mimeType:nil fileData:nil fileURL:fileURL];
}

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL {
    return [self formDataWithName:name fileName:fileName mimeType:mimeType fileData:nil fileURL:fileURL];
}


#pragma mark - Private Methods

+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData fileURL:(NSURL *)fileURL {
    RYUploadFormData *formData = [[RYUploadFormData alloc] init];
    formData.name = name;
    formData.fileName = fileName;
    formData.mimeType = mimeType;
    formData.fileData = fileData;
    formData.fileURL = fileURL;
    
    return formData;
}

@end
