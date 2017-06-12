//
//  RegularClass.m
//  HaiHeBankingPro
//
//  Created by 马广召 on 15/7/15.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import "RegularClass.h"

@implementation RegularClass
+ (RegularClass *)shareManager{
    static RegularClass * regularManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        regularManagerInstance = [[self alloc] init];
    });
    return regularManagerInstance;
}

//验证用户名
- (NSString *)isUserName:(NSString *)candidate{
    
//    NSString * nameRegex = @"^[a-zA-Z0-9_]{6,18}$";
//    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
//    return [phoneTest evaluateWithObject:candidate];
    if (candidate.length<6) {
        return @"用户名不能少于6位";
    }else if (candidate.length>20){
        return @"用户名不能超过20位";
    }else{
        return @"yes";
    }
    //return YES;
}
//验证密码
- (NSString *)isUserPassword:(NSString *)candidate{
    
    if (candidate.length<6) {
        return @"密码长度不能少于6位";
    }else if (candidate.length>30){
        return @"密码长度不能大于30位";
    }
    
    NSString * zimuStr = @"^[a-zA-Z]{6,30}$";
    NSString * shuziStr = @"^[0-9]{6,30}$";
    NSPredicate * zimuTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zimuStr];
    NSPredicate * shuziTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",shuziStr];
    if ([zimuTest evaluateWithObject:candidate]) {
        return @"密码不能全为字母";
    }else if ([shuziTest evaluateWithObject:candidate]){
        return @"密码不能全为数字";
    }
    
    NSArray * array = @[@"and",@"exec",@"insert",@"select",@"delete",@"update",@"count",@"drop",@"chr",@"mid",@"master",@"truncate",@"char",@"declare",@"sitename",@"net user",@"xp_cmdshell",@"create",@"drop",@"from",@"grant",@"use",@"group_concat",@"column_name",@"information_schema.columns",@"table_schema",@"union",@"where",@"order",@"by",@"count",@"like",@"%",@"&",@"\\*",@"'",@",",@"\"",@";",@">",@"<"];
    for (int i=0; i<array.count; i++) {
        if ([candidate rangeOfString:array[i]].location != NSNotFound) {
            return @"密码不能包含关键词";
            }
    }
    return @"yes";
   // return YES;
}

//是否为手机号；
- (BOOL)isTelePhoneNumber:(NSString *)candidate{
    
    NSString * phoneRegex = @"^[0-9]{11}$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:candidate];
}
//是否为验证码；
- (BOOL)isTrueCaptCha:(NSString *)captcha{
    NSString * captchaRegex = @"^[0-9]{6}$";
    NSPredicate * captchaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",captchaRegex];
    return [captchaTest evaluateWithObject:captcha];
}

//是否为身份证号;
- (BOOL)isIdCard:(NSString *)idcard{
    NSString * captchaRegex = @"^[0-9]{17}([0-9]|x|X)$";
    NSPredicate * captchaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",captchaRegex];
    return [captchaTest evaluateWithObject:idcard];

}




@end
