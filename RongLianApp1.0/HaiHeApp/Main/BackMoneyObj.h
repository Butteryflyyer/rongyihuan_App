//
//  BackMoneyObj.h
//  HaiHeApp
//
//  Created by 马广召 on 16/3/4.
//  Copyright © 2016年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackMoneyObj : NSObject
@property (nonatomic, retain)NSString * proid;
@property (nonatomic, retain)NSString * hkrq;
@property (nonatomic, retain)NSString * qs;
@property (nonatomic, retain)NSString * bj;
@property (nonatomic, retain)NSString * fwf;
@property (nonatomic, retain)NSString * yhze;
@property (nonatomic, retain)NSString * qtfy;
@property (nonatomic, retain)NSString * zt;
@property (nonatomic, retain)NSString * ztcode;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
