//
//  UserLoginStatus.h
//  HaiHeApp
//
//  Created by 马广召 on 15/10/30.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginStatus : NSObject
@property (nonatomic, copy)NSString * userid;
@property (nonatomic, copy)NSString * username;//用户名
@property (nonatomic, copy)NSString *userTel;//手机号
+ (UserLoginStatus *)shareManager;
@end
