//
//  RYNetworkConfig.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkConst.h"

@interface RYNetworkConfig : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, copy, nullable) NSString *baseUrl;
@property (nonatomic, copy, nullable) NSString *path;
@property (nonatomic, copy, nullable) NSString *downloadSavePath;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *parameters;
@property (nonatomic, assign) NSTimeInterval timeoutInternalForRequest;
@property (nonatomic, assign) BOOL allowsCellularAccess;
@property (nonatomic, assign) RYNetworkRequestSerializerType requestSerializerType;
@property (nonatomic, assign) RYNetworkResponseSerializerType responeseSerializerType;

@property (nonatomic, assign) RYSSLPinningMode sslPinningMode;
@property (nonatomic, strong) NSData *certData;

@property (nonatomic, assign) BOOL logEnable;

@end
