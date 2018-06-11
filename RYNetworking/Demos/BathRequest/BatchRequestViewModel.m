//
//  BatchRequestViewModel.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/12/4.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "BatchRequestViewModel.h"
#import "RYHttpClient.h"

@interface BatchRequestViewModel()
@property (nonatomic, strong) RYBatchRequest *successfulBatchRequest;
@property (nonatomic, strong) RYBatchRequest *failBatchRequest;
@property (nonatomic, strong) RYBatchRequest *cancelBatchRequest;

@end

@implementation BatchRequestViewModel

- (void)cancelAllBatch {
    [RYHttpClient cancelBathRequest:self.successfulBatchRequest];
    [RYHttpClient cancelBathRequest:self.failBatchRequest];
    [RYHttpClient cancelBathRequest:self.cancelBatchRequest];
}

- (void)SuccessfulRequest {
    self.successfulBatchRequest =  [RYHttpClient sendBatchRequest:^(RYBatchRequest * _Nonnull batchRequest) {
        RYNetworkRequest *request = [RYHttpClient defaultConfigRequest];
        request.method = RYNetworkRequestMethodGET;
        request.apiPath = @"get";
        request.parameters = @{@"batch_param": @"batch_1"};
        [batchRequest addRequest:request];
        
        RYNetworkRequest *request1 = [RYHttpClient defaultConfigRequest];
        request1.method = RYNetworkRequestMethodGET;
        request1.apiPath = @"get";
        request1.parameters = @{@"batch_param": @"batch_2"};
        [batchRequest addRequest:request1];
        
        RYNetworkRequest *request2 = [RYHttpClient defaultConfigRequest];
        request2.method = RYNetworkRequestMethodGET;
        request2.apiPath = @"get";
        request2.parameters = @{@"batch_param": @"batch_3"};
        [batchRequest addRequest:request2];
    } completionHandler:^(BOOL success, NSArray *responseArr, NSArray *errorArr) {
        if (success) {
            for (NSInteger i = 0; i < responseArr.count; i++) {
                RYNetworkResponse *response = [responseArr objectAtIndex:i];
                NSDictionary *arg = [response.responseJSONObject objectForKey:@"args"];
                NSLog(@"第%ld的batch_param是%@", (long)i, [arg objectForKey:@"batch_param"]);
            }
        } else {
            
        }
    }];
}

- (void)FailRequest {
    self.failBatchRequest =  [RYHttpClient sendBatchRequest:^(RYBatchRequest * _Nonnull batchRequest) {
        RYNetworkRequest *request = [RYHttpClient defaultConfigRequest];
        request.method = RYNetworkRequestMethodGET;
        request.apiPath = @"get";
        request.parameters = @{@"batch_param": @"1"};
        [batchRequest addRequest:request];
        
        RYNetworkRequest *request1 = [RYHttpClient defaultConfigRequest];
        request1.method = RYNetworkRequestMethodGET;
        request1.apiPath = @"get";
        request1.parameters = @{@"batch_param": @"2"};
        [batchRequest addRequest:request1];
        
        RYNetworkRequest *request2 = [RYHttpClient defaultConfigRequest];
        request2.apiPath = @"wrongGeg";
        request2.method = RYNetworkRequestMethodGET;
        request2.parameters = @{@"batch_param": @"3"};
        [batchRequest addRequest:request2];
    } completionHandler:^(BOOL success, NSArray *responseArr, NSArray *errorArr) {
        if (success) {
            for (NSInteger i = 0; i < responseArr.count; i++) {
                RYNetworkResponse *response = [responseArr objectAtIndex:i];
                NSLog(@"%@", response.responseString);
            }
        } else {
            for (NSInteger i = 0; i < responseArr.count; i++) {
                id response = [responseArr objectAtIndex:i];
                if ([response isKindOfClass:[RYNetworkResponse class]]) {
                    RYNetworkResponse *res = (RYNetworkResponse *)response;
                    NSDictionary *argDict = [res.responseJSONObject objectForKey:@"args"];
                    NSLog(@"第%ld个成功了,bath_param是%@", (long)i, [argDict objectForKey:@"batch_param"]);
                }
            }
            
            for (NSInteger i = 0; i < errorArr.count; i++) {
                id result = [errorArr objectAtIndex:i];
                if ([result isKindOfClass:[RYNetworkError class]]) {
                    RYNetworkError *error = (RYNetworkError *)result;
                    NSLog(@"第%ld个失败了,失败原因:%@", (long)i, error.titleForError);
                }
            }

        }
    }];
}

- (void)CancelRequest {
    self.cancelBatchRequest = [RYHttpClient sendBatchRequest:^(RYBatchRequest * _Nonnull batchRequest) {
        RYNetworkRequest *request = [RYHttpClient defaultConfigRequest];
        request.method = RYNetworkRequestMethodGET;
        request.apiPath = @"get";
        request.parameters = @{@"batch_param": @"1"};
        [batchRequest addRequest:request];
        
        RYNetworkRequest *request1 = [RYHttpClient defaultConfigRequest];
        request1.method = RYNetworkRequestMethodGET;
        request1.apiPath = @"get";
        request1.parameters = @{@"batch_param": @"2"};
        [batchRequest addRequest:request1];
        
        RYNetworkRequest *request2 = [RYHttpClient defaultConfigRequest];
        request2.apiPath = @"wrongGeg";
        request2.method = RYNetworkRequestMethodGET;
        request2.parameters = @{@"batch_param": @"3"};
        [batchRequest addRequest:request2];
    } completionHandler:^(BOOL success, NSArray *responseArr, NSArray *errorArr) {
        if (success) {
            for (NSInteger i = 0; i < responseArr.count; i++) {
                RYNetworkResponse *response = [responseArr objectAtIndex:i];
                NSLog(@"%@", response.responseString);
            }
        } else {
            for (NSInteger i = 0; i < responseArr.count; i++) {
                id response = [responseArr objectAtIndex:i];
                if ([response isKindOfClass:[RYNetworkResponse class]]) {
                    RYNetworkResponse *res = (RYNetworkResponse *)response;
                    NSDictionary *argDict = [res.responseJSONObject objectForKey:@"args"];
                    NSLog(@"第%ld个成功了,bath_param是%@", (long)i, [argDict objectForKey:@"batch_param"]);
                }
            }
            
            for (NSInteger i = 0; i < errorArr.count; i++) {
                id result = [errorArr objectAtIndex:i];
                if ([result isKindOfClass:[RYNetworkError class]]) {
                    RYNetworkError *error = (RYNetworkError *)result;
                    NSLog(@"第%ld个失败了,失败原因:%@", (long)i, error.titleForError);
                }
            }
            
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [RYHttpClient cancelBathRequest:self.cancelBatchRequest];
    });
}

#pragma mark - Accessors

- (NSArray<NSDictionary *> *)sectionArr {
    return @[
             @{@"name" : @"Batch Request",
               @"data" : @[@"Successful Request", @"Fail Request", @"Cancel Request"],
               }
             ];
}

@end
