//
//  TableViewModel.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "TableViewModel.h"

@implementation TableViewModel

- (void)action:(NSIndexPath *)indexPath {
    NSString *string = self.sectionArr[indexPath.section][@"data"][indexPath.row];
    SEL selector =  NSSelectorFromString([string stringByReplacingOccurrencesOfString:@" " withString:@""]);
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self, selector);
    }
}

@end
