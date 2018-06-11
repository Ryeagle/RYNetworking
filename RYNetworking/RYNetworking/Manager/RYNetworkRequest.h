//
//  RYNetworkRequest.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RYRequestState) {
    RYRequestStateRunning = 0,
    RYRequestStateSuspended = 1,
    RYRequestStateCanceling = 2,
    RYRequestStateCompleted = 3,
};


@class RYUploadFormData;

@interface RYNetworkRequest : NSObject
@property (nonatomic, assign, readonly) NSUInteger requestIdentifier;
@property (nonatomic, copy, nullable) NSString *urlStr;
@property (nonatomic, copy, nullable) NSString *baseUrl;
@property (nonatomic, copy, nullable) NSString *apiPath;
@property (nonatomic, copy, nullable) NSString *downloadSavePath;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *parameters;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (nonatomic, assign) RYNetworkRequestType type;
@property (nonatomic, assign) RYNetworkRequestMethod method;
@property (nonatomic, assign) RYNetworkRequestSerializerType requestSerializerType;
@property (nonatomic, assign) RYNetworkResponseSerializerType responeseSerializerType;
@property (nonatomic, assign) BOOL allowsCellularAccess;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, assign) RYSSLPinningMode sslPinningMode;
@property (nonatomic, strong) NSData *certData;

@property (nonatomic, assign, readonly) RYRequestState state;

@property (nonatomic, strong, nullable) NSMutableArray<RYUploadFormData *> *uploadFormDatas;

- (void)addFormDataWithName:(NSString *)name fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
- (void)addFormDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
- (void)addFormDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;
@end

@interface RYUploadFormData : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *mimeType;
@property (nonatomic, strong, nullable) NSURL *fileURL;
@property (nonatomic, strong, nullable) NSData *fileData;

+ (instancetype)formDataWithName:(NSString *)name fileData:(NSData *)fileData;
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)fileData;
+ (instancetype)formDataWithName:(NSString *)name fileURL:(NSURL *)fileURL;
+ (instancetype)formDataWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileURL:(NSURL *)fileURL;
@end

NS_ASSUME_NONNULL_END
