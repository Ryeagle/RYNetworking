//
//  TableViewModel.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewModel : NSObject
// name : NSString                 Group Name
// data : NSArray<NSString *>      Section data
@property (nonatomic, strong) NSArray<NSDictionary *> *sectionArr;

- (void)action:(NSIndexPath *)indexPath;

@end
