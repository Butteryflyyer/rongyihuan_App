//
//  DESObject.h
//  Security
//
//  Created by 马广召 on 15/7/27.
//  Copyright (c) 2015年 Daniate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESObject : NSObject
+ (NSString *) encryptUseDES:(NSString *)plainText;
//+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSString *)md5:(NSString *)str;
/************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 **********************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 **********************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;



+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;



+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
@end
