//
//  AppDelegate.m
//  RYNetworking
//
//  Created by Ryeagler on 2018/6/11.
//  Copyright © 2018年 Ryeagle. All rights reserved.
//

#import "AppDelegate.h"
#import "RYNetworkConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RYNetworkConfig sharedInstance].baseUrl = @"https://httpbin.org";
    [RYNetworkConfig sharedInstance].logEnable = YES;
    [RYNetworkConfig sharedInstance].timeoutInternalForRequest = 60;
    [RYNetworkConfig sharedInstance].allowsCellularAccess = YES;
    [RYNetworkConfig sharedInstance].baseUrl = @"https://httpbin.org";
    [RYNetworkConfig sharedInstance].headers = @{
                                                 @"common_HeaderName" : @"commonHeaderName_jindan",
                                                 @"common_HeaderAddr" : @"common_HeaderAddr_beijing",
                                                 };
    [RYNetworkConfig sharedInstance].parameters = @{
                                                    @"common_body_name" : @"common_body_jindan",
                                                    @"common_body_city" : @"common_body_beijing"
                                                    };
    [RYNetworkConfig sharedInstance].requestSerializerType = RYNetworkRequestSerializerTypeJSON;
    [RYNetworkConfig sharedInstance].responeseSerializerType = RYNetworkResponseSerializerTypeJSON;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
