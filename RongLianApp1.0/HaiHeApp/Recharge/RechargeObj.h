//
//  RechargeObj.h
//  HaiHeApp
//
//  Created by 马广召 on 15/10/29.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeObj : NSObject
@property (nonatomic, retain)NSString * txTime;
@property (nonatomic, retain)NSString * czje;
@property (nonatomic, retain)NSString * liushuihao;
@property (nonatomic, retain)NSString * czjg;




+ (void)globalTimelineWithDrawRecordWithUserId:(NSString *)userid andWithStartPage:(NSString *)startpage andWithPresentStatus:(NSString *)status andWithBlock:(void (^)(NSArray *invests, NSString *errorStr,NSString * currentPage))block;

@end
