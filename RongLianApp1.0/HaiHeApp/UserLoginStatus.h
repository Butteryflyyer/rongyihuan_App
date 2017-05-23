//
//  UserLoginStatus.h
//  HaiHeApp
//
//  Created by 马广召 on 15/10/30.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginStatus : NSObject
@property (nonatomic, retain)NSString * userid;
@property (nonatomic, retain)NSString * username;
+ (UserLoginStatus *)shareManager;
@end
