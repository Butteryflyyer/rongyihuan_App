//
//  JudgerespCodeObject.h
//  HaiHeApp
//
//  Created by 马广召 on 15/10/19.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JudgerespCodeObject : NSObject
+ (JudgerespCodeObject *)sharedManager;
- (NSString *)returnJudgeCodeStringWithString:(NSString *)codeString;
@end
