//
//  RegularClass.h
//  HaiHeBankingPro
//
//  Created by 马广召 on 15/7/15.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularClass : NSObject
+ (RegularClass *)shareManager;
//验证用户名
- (NSString *)isUserName:(NSString *)candidate;
//验证密码
- (NSString *)isUserPassword:(NSString *)candidate;
//是否为手机号；
- (BOOL)isTelePhoneNumber:(NSString *)candidate;
//是否为验证码；
- (BOOL)isTrueCaptCha:(NSString *)captcha;
//是否为身份证号;
- (BOOL)isIdCard:(NSString *)idcard;
////是否是真实姓名;
//- (BOOL)isRealName:(NSString *)realname;
@end
