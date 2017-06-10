//
//  Main_Jump.h
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Main_Jump : NSObject

+(Main_Jump *)shareManager;

@property(nonatomic,assign)NSInteger postNum_location_phone; 

@property(nonatomic,strong)UIViewController *current;


-(void)addNsnotionWithView:(UIViewController *)view;

@end
