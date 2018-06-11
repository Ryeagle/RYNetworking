//
//  RYNetworkError.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * RYNetworkErrorDesription;

FOUNDATION_EXPORT NSErrorDomain const RYNetworkErrorHTTPErrorDomain;

@interface RYNetworkError : NSError

- (NSString *)titleForError;

+ (instancetype)bulidNetworkError:(NSError *)error;

@end
