//
//  UIWindow+NetworkingDemo.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "UIWindow+NetworkingDemo.h"

@implementation UIWindow (NetworkingDemo)

+ (UIViewController *)currentVC {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return [window _currentViewController];
}

- (UIViewController *)_currentViewController {
    UIViewController *topViewController = [self rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end
