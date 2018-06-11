//
//  RYNetworkResponse.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkConst.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface RYNetworkResponse : NSObject
@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, strong, readonly, nullable) NSDictionary *allHeaderFields;
@property (nonatomic, strong, readonly, nullable) NSData *responseData;
@property (nonatomic, strong, readonly, nullable) id responseObject;
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseJSONObject;
@property (nonatomic, strong, readonly, nullable) NSString *responseString;


+ (RYNetworkResponse *)responseWithURLResponse:(NSURLResponse *)response resonseOjbect:(id)responseObject responseType:(RYNetworkResponseSerializerType)responseType responseSerializer:(AFHTTPResponseSerializer *)responseSerializer validationError:(NSError * _Nullable __autoreleasing *)validationError;

@end

NS_ASSUME_NONNULL_END
