//
//  RYBatchRequest.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYBatchRequest.h"

@interface RYBatchRequest ()
@property (nonatomic, strong, readwrite) NSMutableArray<RYNetworkRequest *> *requestArr;
@property (nonatomic, strong, readwrite) NSMutableArray *responseArr;
@property (nonatomic, strong, readwrite) NSMutableArray *errorArr;

@property (nonatomic, assign) NSInteger finishAmount;
@property (nonatomic, assign) BOOL isSuccessful;
@end

@implementation RYBatchRequest

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _isSuccessful = YES;
        _finishAmount = 0;
    }
    
    return self;
}


- (void)addRequest:(RYNetworkRequest *)request {
    if (request) {
        [self.requestArr addObject:request];
    }
}

- (void)resolveWithResponse:(RYNetworkResponse *)response error:(RYNetworkError *)error completionHandler:(RYBatchRequestCompletionHandler)completionHandler {
    self.finishAmount++;
    
    if (error) {
        self.isSuccessful = NO;
        [self.responseArr addObject:[NSNull null]];
        [self.errorArr addObject:error];
    } else {
        [self.responseArr addObject:response];
        [self.errorArr addObject:[NSNull null]];
    }
    
    if (self.finishAmount == self.requestArr.count) {
        if (completionHandler) {
            completionHandler(self.isSuccessful, self.responseArr, self.errorArr);
        }
        [[RYBatchRequestManager sharedInstance] removeBatchRequest:self];
    }
}

#pragma mark - Accessors

- (NSMutableArray<RYNetworkRequest *> *)requestArr {
    if (!_requestArr) {
        _requestArr = [NSMutableArray array];
    }
    
    return _requestArr;
}

- (NSMutableArray<RYNetworkResponse *> *)responseArr {
    if (!_responseArr) {
        _responseArr = [NSMutableArray array];
    }
    
    return _responseArr;
}

- (NSMutableArray<RYNetworkError *> *)errorArr {
    if (!_errorArr) {
        _errorArr = [NSMutableArray array];
    }
    
    return _errorArr;
}

@end

#pragma mark - RYBatchRequestManager

@interface RYBatchRequestManager()
@property (nonatomic, strong) NSMutableArray *batchRequestArr;
@property (nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation RYBatchRequestManager

+ (instancetype)sharedInstance {
    static RYBatchRequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RYBatchRequestManager alloc] init];
        sharedInstance.lock = dispatch_semaphore_create(1);
    });
    
    return sharedInstance;
}

- (void)addBatchRequest:(RYBatchRequest *)batchRequest {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    [self.batchRequestArr addObject:batchRequest];
    dispatch_semaphore_signal(self.lock);
}

- (void)removeBatchRequest:(RYBatchRequest *)batchRequest {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    [self.batchRequestArr removeObject:batchRequest];
    dispatch_semaphore_signal(self.lock);
}

#pragma mark - Accessors

- (NSMutableArray *)batchRequestArr {
    if (!_batchRequestArr) {
        _batchRequestArr = [NSMutableArray array];
    }
    
    return _batchRequestArr;
}

@end
