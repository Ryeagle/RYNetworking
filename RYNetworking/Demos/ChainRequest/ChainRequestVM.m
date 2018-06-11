//
//  ChainRequestVM.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/12/5.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "ChainRequestVM.h"
#import "RYHttpClient.h"

@interface ChainRequestVM()
@property (nonatomic, strong) RYChainRequest *successfulRequest;
@end

@implementation ChainRequestVM


- (void)SuccessfulRequest {
    self.successfulRequest = [RYHttpClient sendChainRequest:^(RYChainRequest * _Nonnull chainRequest) {
        [[[chainRequest addRequest:^(RYNetworkRequest *request) {
            [RYHttpClient configDefaultRequest:request];
            request.apiPath = @"get";
            request.method = RYNetworkRequestMethodGET;
            request.parameters = @{@"chain_param": @"chain1_"};
        }] addRequestWithResponse:^(RYNetworkRequest *request, RYNetworkResponse *respose) {
            [RYHttpClient configDefaultRequest:request];
            request.apiPath = @"get";
            request.method = RYNetworkRequestMethodGET;
            if (respose.responseJSONObject) {
                NSDictionary *argsDict = [respose.responseJSONObject objectForKey:@"args"];
                NSString *string = [argsDict objectForKey:@"chain_param"];
                string = [string stringByAppendingString:@"chain2"];
                request.parameters = @{
                                       @"chain_param" : string.length ? string : @""
                                       };
                
            }
        }] addRequestWithResponse:^(RYNetworkRequest *request, RYNetworkResponse *respose) {
            [RYHttpClient configDefaultRequest:request];
            request.apiPath = @"get";
            request.method = RYNetworkRequestMethodGET;
            if (respose.responseJSONObject) {
                NSDictionary *argsDict = [respose.responseJSONObject objectForKey:@"args"];
                NSString *string = [argsDict objectForKey:@"chain_param"];
                string = [string stringByAppendingString:@"chain3"];
                request.parameters = @{
                                       @"chain_param" : string.length ? string : @""
                                       };
            }
        }];
    } completionHandler:^(BOOL success, NSArray *responseArr, RYNetworkError *error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            for (NSInteger i = 0;  i < responseArr.count; i++) {
                RYNetworkResponse *respose = [responseArr objectAtIndex:i];
                NSLog(@"返回了第%ld个请求：%@", (long)i, [respose.responseJSONObject objectForKey:@"args"]);
            }
        }
    }];
}

- (void)FailRequest {
    [RYHttpClient sendChainRequest:^(RYChainRequest * _Nonnull chainRequest) {
        [[[chainRequest addRequest:^(RYNetworkRequest *request) {
            [RYHttpClient configDefaultRequest:request];
            request.apiPath = @"get";
            request.method = RYNetworkRequestMethodGET;
            request.parameters = @{@"chain_param": @"chain1_"};
        }] addRequestWithResponse:^(RYNetworkRequest *request, RYNetworkResponse *respose) {
            [RYHttpClient configDefaultRequest:request];
            request.apiPath = @"wrongGet";
            request.method = RYNetworkRequestMethodGET;
            if (respose.responseJSONObject) {
                NSDictionary *argsDict = [respose.responseJSONObject objectForKey:@"args"];
                NSString *string = [argsDict objectForKey:@"chain_param"];
                string = [string stringByAppendingString:@"chain2"];
                request.parameters = @{
                                       @"chain_param" : string.length ? string : @""
                                       };
                
            }
        }] addRequestWithResponse:^(RYNetworkRequest *request, RYNetworkResponse *respose) {
            [RYHttpClient configDefaultRequest:request];
            request.apiPath = @"get";
            request.method = RYNetworkRequestMethodGET;
            if (respose.responseJSONObject) {
                NSDictionary *argsDict = [respose.responseJSONObject objectForKey:@"args"];
                NSString *string = [argsDict objectForKey:@"chain_param"];
                string = [string stringByAppendingString:@"chain3"];
                request.parameters = @{
                                       @"chain_param" : string.length ? string : @""
                                       };
            }
        }];
    } completionHandler:^(BOOL success, NSArray *responseArr, RYNetworkError *error) {
        if (error) {
            for (NSInteger i = 0;  i < responseArr.count; i++) {
                RYNetworkResponse *respose = [responseArr objectAtIndex:i];
                NSLog(@"发生了错误...返回了第%ld个请求：%@", (long)i, [respose.responseJSONObject objectForKey:@"args"]);
            }
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            for (NSInteger i = 0;  i < responseArr.count; i++) {
                RYNetworkResponse *respose = [responseArr objectAtIndex:i];
                NSLog(@"返回了第%ld个请求：%@", (long)i, [respose.responseJSONObject objectForKey:@"args"]);
            }
        }
    }];
}

- (void)CancelRequest {
    [RYHttpClient cancelChainRequest:self.successfulRequest];
}

#pragma mark - Accessors

- (NSArray<NSDictionary *> *)sectionArr {
    return @[
             @{@"name" : @"Chain Request",
               @"data" : @[@"Successful Request", @"Fail Request", @"Cancel Request"],
               }
             ];
}

@end
