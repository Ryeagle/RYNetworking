//
//  NormalRequestViewModel.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "NormalRequestViewModel.h"
#import "RYHttpClient.h"
#import "RYNetworkConfig.h"

@interface NormalRequestViewModel()
@property (nonatomic, strong) RYNetworkRequest *request;
@end

@implementation NormalRequestViewModel

- (void)cancelRequest {
    [RYHttpClient cancelRequest:self.request];
}

#pragma mark - Normal Request
 
- (void)GET {
    self.request = [RYHttpClient GET:@"get" parameters:@{@"get_key":@"get_value"} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        }
    }];
}

- (void)POST {
    [RYHttpClient POST:@"post" parameters:@{@"post_key":@"post_value"} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        }
    }];
}

- (void)HEAD {
    [RYHttpClient HEAD:@"" parameters:@{@"head_key":@"head_value"} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        }
    }];
}

- (void)DELETE {
    [RYHttpClient DELETE:@"delete" parameters:@{@"delete_key":@"delete_value"} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        }
    }];
}

- (void)PUT {
    [RYHttpClient PUT:@"put" parameters:@{@"puth_key":@"put_value"} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        }
    }];
}

- (void)PATCH {
    [RYHttpClient PATCH:@"patch" parameters:@{@"patch_key":@"patch_value"} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        }
    }];
}

#pragma mark - Custom Config Request

- (void)CustomGet {
    [RYHttpClient sendRequest:^(RYNetworkRequest * _Nonnull request) {
        request.urlStr = @"https://httpbin.org/get";
        request.parameters = @{
                               @"custom_get_key" : @"custom_get_value"
                               };
        request.timeoutInterval = 1.0f;
        request.allowsCellularAccess = NO;
        request.requestSerializerType = RYNetworkRequestSerializerTypeHTTP;
        request.responeseSerializerType = RYNetworkResponseSerializerTypeJSON;
    } completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        
    }];
}

#pragma mark - Other

- (void)Concurrent {
    for (NSInteger i = 1; i <= 30; i++) {
        [RYNetworkConfig sharedInstance].logEnable = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           RYNetworkRequest *request = [RYHttpClient GET:@"get" parameters:@{@"get_params" : @(i+10000)} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
                if (!error) {
                    NSDictionary *argDict =  [response.responseJSONObject objectForKey:@"args"];
                    NSInteger num =  [[argDict objectForKey:@"get_params"] integerValue];
                    NSLog(@"num:%ld===%@", (long)num, [argDict objectForKey:@"get_params"]);
                } else {
                    NSLog(@"Error:%@===num:%ld", error.titleForError, i+10000);
                }
            }];
            if (i % 5 == 0) {
                [RYHttpClient cancelRequest:request];
            }
        });
    }
}

#pragma mark - Accessors

- (NSArray<NSDictionary *> *)sectionArr {
    return @[
             @{@"name" : @"Default Config Request",
               @"data" : @[@"GET", @"POST", @"HEAD", @"DELETE", @"PUT", @"PATCH"],
               },
             @{@"name" : @"Custom Config Request",
               @"data" : @[@"Custom Get"],
               },
             @{@"name" : @"Other",
               @"data" : @[@"Concurrent"],
                 }
             ];
}

@end
