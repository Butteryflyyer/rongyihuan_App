//
//  UIButton+XHExtension.h
//  QianDaoWeiApp
//
//  Created by 信昊 on 17/5/15.
//  Copyright © 2017年 信昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XHExtension)
/**  扩大buuton点击范围  */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
