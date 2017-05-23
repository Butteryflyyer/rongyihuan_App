//
//  UserLoginStatus.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/30.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "UserLoginStatus.h"

@implementation UserLoginStatus
+ (UserLoginStatus *)shareManager{
    static UserLoginStatus * loginManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        loginManagerInstance = [[self alloc] init];
    });
    return loginManagerInstance;
}

@end
