//
//  JudgerespCodeObject.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/19.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "JudgerespCodeObject.h"

@implementation JudgerespCodeObject

+ (JudgerespCodeObject *)sharedManager
{
    static JudgerespCodeObject * judgeManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        judgeManagerInstance = [[self alloc] init];
    });
    return judgeManagerInstance;
}

- (NSString *)returnJudgeCodeStringWithString:(NSString *)codeString{
    
    return nil;
}

@end
