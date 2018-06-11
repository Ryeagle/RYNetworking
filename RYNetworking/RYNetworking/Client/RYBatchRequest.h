//
//  RYBatchRequest.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkRequest.h"
#import "RYNetworkResponse.h"
#import "RYNetworkError.h"

typedef void(^RYBatchRequestCompletionHandler)(BOOL success, NSArray *responseArr, NSArray *errorArr);

@interface RYBatchRequest : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<RYNetworkRequest *> *requestArr;

- (void)addRequest:(RYNetworkRequest *)request;

@end

@interface RYBatchRequestManager : NSObject

+ (instancetype)sharedInstance;
- (void)addBatchRequest:(RYBatchRequest *)batchRequest;
- (void)removeBatchRequest:(RYBatchRequest *)batchRequest;

@end
