//
//  ChainRequestTableVC.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/12/5.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "ChainRequestTableVC.h"
#import "ChainRequestVM.h"
#import "RYNetworkConfig.h"

@interface ChainRequestTableVC ()

@end

@implementation ChainRequestTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[ChainRequestVM alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
