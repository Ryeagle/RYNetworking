//
//  BatchRequestVC.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/12/4.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "BatchRequestVC.h"
#import "BatchRequestViewModel.h"

@interface BatchRequestVC ()

@end

@implementation BatchRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[BatchRequestViewModel alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    BatchRequestViewModel *batchVM = (BatchRequestViewModel *)self.viewModel;
    [batchVM cancelAllBatch];
}

- (void)dealloc {
    NSLog(@"BatchVC deallced.");
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
