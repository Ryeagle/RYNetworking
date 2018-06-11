//
//  RYChainRequest.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYChainRequest.h"

@interface RYChainRequest()
@property (nonatomic, strong) RYNetworkResponse *currentResponse;
@property (nonatomic, strong) RYNetworkError *currentError;
@end

@implementation RYChainRequest

- (RYChainRequest *)addRequest:(void(^)(RYNetworkRequest *request))requestBlock {
    if (requestBlock) {
        RYNetworkRequest *request = [[RYNetworkRequest alloc] init];
        requestBlock(request);
        self.currentRequest = request;
    }
    return self;
}

- (RYChainRequest *)addRequestWithResponse:(RYChainRequestBlock)requestBlock {
    if (requestBlock) {
        [self.chainBlockArray addObject:requestBlock];
    }
    return self;
}


#pragma mark - Accessors

- (NSMutableArray<RYChainRequestBlock> *)chainBlockArray {
    if (!_chainBlockArray) {
        _chainBlockArray = [NSMutableArray array];
    }
    
    return _chainBlockArray;
}

- (NSMutableArray *)responseArr {
    if (!_responseArr) {
        _responseArr = [NSMutableArray array];
    }
    
    return _responseArr;
}

@end


@interface RYChainRequestManager()
@property (nonatomic, strong) NSMutableArray *chainRequestArr;
@end


@implementation RYChainRequestManager

+ (instancetype)sharedInstance {
    static RYChainRequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RYChainRequestManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)addChainRequest:(RYChainRequest *)batchRequest {
    @synchronized(self) {
        [self.chainRequestArr addObject:batchRequest];
    }
}
- (void)removeChainRequest:(RYChainRequest *)batchRequest {
    @synchronized(self) {
        [self.chainRequestArr removeObject:batchRequest];
    }
}

#pragma mark - Accessors

- (NSMutableArray *)chainRequestArr {
    if (!_chainRequestArr) {
        _chainRequestArr = [NSMutableArray array];
    }
    
    return _chainRequestArr;
}

@end
