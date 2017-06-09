//
//  ComponyIntroduce_View.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "ComponyIntroduce_View.h"

@implementation ComponyIntroduce_View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)Close_button:(id)sender {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
 
}

@end
