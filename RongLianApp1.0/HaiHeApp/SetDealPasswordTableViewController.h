//
//  SetDealPasswordTableViewController.h
//  HaiHeApp
//
//  Created by 马广召 on 15/10/15.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FatherTableViewController.h"

@interface SetDealPasswordTableViewController : FatherTableViewController
@property (nonatomic, assign)BOOL fromH5;
@property (nonatomic, retain)NSString * userid;
@property (nonatomic, retain)NSString * usernameStr;
@property (nonatomic, retain)NSString * phoneStr;
@end
