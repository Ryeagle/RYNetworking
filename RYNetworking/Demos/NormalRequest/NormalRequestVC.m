//
//  NormalRequestVC.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "NormalRequestVC.h"
#import "NormalRequestViewModel.h"

@interface NormalRequestVC ()

@end

@implementation NormalRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[NormalRequestViewModel alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NormalRequestViewModel *vm = (NormalRequestViewModel *)self.viewModel;
    [vm cancelRequest];
}

- (void)dealloc {
    NSLog(@"🍑🍑🍑%@ is Deaaloced.", NSStringFromClass([self class]));
}

@end
