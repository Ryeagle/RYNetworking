//
//  RYNetworkConfig.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYNetworkConfig.h"
#import "RYNetworkTool.h"

@implementation RYNetworkConfig

+ (instancetype)sharedInstance {
    static RYNetworkConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RYNetworkConfig alloc] init];
        sharedInstance.sslPinningMode = RYSSLPinningModeNone;
    });
    
    return sharedInstance;
}

#pragma mark - Accessors

- (void)setLogEnable:(BOOL)logEnable {
    [RYNetworkTool sharedInstance].logEnable = logEnable;
}
@end
