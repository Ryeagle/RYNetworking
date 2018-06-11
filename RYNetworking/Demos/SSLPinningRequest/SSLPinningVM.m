//
//  SSLPinningVM.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/12/10.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "SSLPinningVM.h"
#import "RYHttpClient.h"

@interface SSLPinningVM()
@property (nonatomic, strong) RYNetworkRequest *sslRequest;

@end

@implementation SSLPinningVM

- (void)SSLPinning4CustomRequest {
    self.sslRequest = [RYHttpClient sendRequest:^(RYNetworkRequest * _Nonnull request) {
        request.urlStr = @"https://httpbin.org/get";
        request.parameters = @{
                               @"get" : @"custom_get_value"
                               };
        request.timeoutInterval = 20.f;
        request.allowsCellularAccess = NO;
        request.requestSerializerType = RYNetworkRequestSerializerTypeHTTP;
        request.responeseSerializerType = RYNetworkResponseSerializerTypeJSON;
        request.sslPinningMode = RYSSLPinningModeCertificate;
        NSString *certPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"httpbin.org" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:certPath];
        request.certData = certData;
    } completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (!error) {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        } else {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        }
    }];
}

- (void)SSLPinning4DefaultRequest {
    [RYHttpClient GET:@"get" parameters:@{} headers:@{} completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        if (!error) {
            [AlertHelper showMessage:response.responseString title:@"Response"];
        } else {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        }
    }];
}

- (void)CancelSSLRequest {
    [RYHttpClient cancelRequest:self.sslRequest];
}

#pragma mark - Accessors

- (NSArray<NSDictionary *> *)sectionArr {
    return @[
             @{@"name" : @"SSL Pinning",
               @"data" : @[@"SSLPinning4CustomRequest", @"SSLPinning4DefaultRequest", @"CancelSSLRequest"],
               }
             ];
}

@end
