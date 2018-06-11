//
//  RYNetworkTool.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/24.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkResponse.h"

@interface RYNetworkTool : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, assign) BOOL logEnable;

void RYNetworkLog(NSString *format, ...);

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSStringEncoding)stringEncodingWithEncodingName:(NSString *)textEncodingName;

+ (BOOL)validateResumeData:(NSData *)data;

@end
