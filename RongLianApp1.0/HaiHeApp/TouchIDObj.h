//
//  TouchIDObj.h
//  HaiHeApp
//
//  Created by 马广召 on 15/11/6.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchIDObj : NSObject
+ (TouchIDObj *)shareManager;
- (NSString *)authenticateUser;
@end
