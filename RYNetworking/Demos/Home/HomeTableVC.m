//
//  HomeTableVC.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "HomeTableVC.h"
#import "HomeViewModel.h"
#import "RYNetworkConfig.h"

@implementation HomeTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[HomeViewModel alloc] init];
}

@end
