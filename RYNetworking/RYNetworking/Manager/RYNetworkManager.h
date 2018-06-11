//
//  RYNetworkManager.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//
//  Refences:
//  YTKNetworking
//  XMNetworking
//

#import <Foundation/Foundation.h>
#import "RYNetworkConst.h"
#import "RYNetworkError.h"
#import "RYNetworkResponse.h"
#import "RYNetworkRequest.h"

typedef void(^RYNetworkProgressBlock)(NSProgress * _Nonnull progress);
typedef void(^RYNetworkResponseBlock)(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error);

@interface RYNetworkManager : NSObject

@property (nonatomic, assign) RYNetworkReachabilityStatus reachabilityStatus;

+ (instancetype)sharedManager;

- (void)sendRequest:(RYNetworkRequest *)request processBlock:(RYNetworkProgressBlock)proccessBlock completionHandler:(RYNetworkResponseBlock)completionHandler;

- (void)cancelRequest:(RYNetworkRequest *)request;

@end
