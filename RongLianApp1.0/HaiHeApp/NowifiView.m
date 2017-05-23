//
//  NowifiView.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/6.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "NowifiView.h"

@implementation NowifiView
- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 140);
    }
    return self;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
