//
//  ComponyIntroduce_View.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "ComponyIntroduce_View.h"

@interface ComponyIntroduce_View ()
@property (weak, nonatomic) IBOutlet UIButton *colse_btn;

@end

@implementation ComponyIntroduce_View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.colse_btn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    
}
- (IBAction)Close_button:(id)sender {
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
 
}

@end
