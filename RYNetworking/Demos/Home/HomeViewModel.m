//
//  HomeViewModel.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "HomeViewModel.h"
#import "RYNetworkConst.h"
#import "RYNetworkConfig.h"
#import "NormalRequestVC.h"
#import "RYHttpClient.h"
#import "UploadController.h"
#import "DownloadViewController.h"
#import "BatchRequestVC.h"
#import "ChainRequestTableVC.h"
#import "SSLPinningTableVC.h"

@implementation HomeViewModel

- (void)LogEnable {
    [RYNetworkConfig sharedInstance].logEnable = ![RYNetworkConfig sharedInstance].logEnable;
    if ([RYNetworkConfig sharedInstance].logEnable) {
        [AlertHelper showMessage:@"" title:@"Console Log On"];
    } else {
        [AlertHelper showMessage:@"" title:@"Console Log Off"];
    }
}

- (void)AllowsCellularAccess {
    [RYNetworkConfig sharedInstance].allowsCellularAccess = ![RYNetworkConfig sharedInstance].allowsCellularAccess;
    if ([RYNetworkConfig sharedInstance].allowsCellularAccess) {
        [AlertHelper showMessage:@"CellularAccess Allowed." title:@""];
    } else {
        [AlertHelper showMessage:@"CellularAccess Denied." title:@""];
    }

}

- (void)NormalRequest {
    NormalRequestVC *vc = [[NormalRequestVC alloc] init];
    [[UIWindow currentVC].navigationController pushViewController:vc animated:YES];
}

- (void)Upload {
    UploadController *uploadVC = [[UploadController alloc] init];
    
    [[UIWindow currentVC].navigationController pushViewController:uploadVC animated:YES];
}

- (void)Download {
    DownloadViewController *downloadVC = [[DownloadViewController alloc] init];
    [[UIWindow currentVC].navigationController pushViewController:downloadVC animated:YES];
}

- (void)BatchRequest {
    BatchRequestVC *batchVC = [[BatchRequestVC alloc] init];
    [[UIWindow currentVC].navigationController pushViewController:batchVC animated:YES];
}

- (void)ChainRequest {
    ChainRequestTableVC *chainVC = [[ChainRequestTableVC alloc] init];
    [[UIWindow currentVC].navigationController pushViewController:chainVC animated:YES];
}

- (void)SSLPinningRequest {
    SSLPinningTableVC *sslPinningVC = [[SSLPinningTableVC alloc] init];
    [[UIWindow currentVC].navigationController pushViewController:sslPinningVC animated:YES];
}

#pragma mark - Accessors

- (NSArray<NSDictionary *> *)sectionArr {
    return @[
             @{@"name" : @"Config",
               @"data" : @[@"Log Enable", @"AllowsCellularAccess"],
               },
             @{@"name" : @"Signal Reqeust",
               @"data" : @[@"Normal Request", @"Upload", @"Download"],
               },
             @{@"name" : @"Multiple Request",
               @"data" : @[@"Batch Request", @"Chain Request"],
               },
             @{@"name" : @"SSL Pinning Request",
               @"data" : @[@"SSL Pinning Request"],
                 },
             ];
}


@end
