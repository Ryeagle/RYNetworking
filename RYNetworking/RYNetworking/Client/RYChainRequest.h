//
//  RYChainRequest.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkRequest.h"
#import "RYNetworkResponse.h"
#import "RYNetworkError.h"

typedef void(^RYChainRequestCompletionHandler)(BOOL success, NSArray *responseArr, RYNetworkError *error);
typedef void(^RYChainRequestBlock)(RYNetworkRequest *request, RYNetworkResponse *respose);

@interface RYChainRequest : NSObject
@property (nonatomic, strong) NSMutableArray<RYChainRequestBlock> *chainBlockArray;
@property (nonatomic, strong) RYNetworkRequest *currentRequest;
@property (nonatomic, strong) NSMutableArray *responseArr;

- (RYChainRequest *)addRequest:(void(^)(RYNetworkRequest *request))requestBlock;
- (RYChainRequest *)addRequestWithResponse:(RYChainRequestBlock)requestBlock;
@end

@interface RYChainRequestManager : NSObject
+ (instancetype)sharedInstance;
- (void)addChainRequest:(RYChainRequest *)batchRequest;
- (void)removeChainRequest:(RYChainRequest *)batchRequest;
@end
