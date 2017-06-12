//
//  RechargeAgainTableViewController.h
//  HaiHeApp
//
//  Created by 马广召 on 15/10/29.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FatherTableViewController.h"
#import "LLPaySdk.h"
@interface RechargeAgainTableViewController : FatherTableViewController<LLPaySdkDelegate>
@property (nonatomic, assign)BOOL fromH5;
@property (nonatomic, retain)NSString * userid;
@property (nonatomic, retain)NSString * phoneStr;
@property (nonatomic, retain)NSString * zhuceTime;
@end
