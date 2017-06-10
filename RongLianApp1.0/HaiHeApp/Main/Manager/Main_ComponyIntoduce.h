//
//  Main_ComponyIntoduce.h
//  HaiHeApp
//
//  Created by 信昊 on 17/6/10.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Main_ComponyIntoduce : NSObject
+(Main_ComponyIntoduce *)shareManager;

@property(nonatomic,assign)NSInteger Compony_Num;//弹出一次

-(void)goIntoMain:(void(^)(NSString *str))block WithView:(UIViewController *)vc;

@end
