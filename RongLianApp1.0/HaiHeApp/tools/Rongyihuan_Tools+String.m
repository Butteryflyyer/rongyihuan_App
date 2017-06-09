//
//  Rongyihuan_Tools+String.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Rongyihuan_Tools+String.h"

@implementation Rongyihuan_Tools (String)
+ (CGFloat)heigtOfLabelForFromString:(NSString *)text fontSizeandLabelWidth:(CGFloat)width andFontSize:(CGFloat)fontSize
{
    
    if (!text) {
        return 0;
    }
    
    CGSize textSize = [self sizeOfLabelForFromString:text fontSizeandLabelWidth:width andFontSize:fontSize];
    //    DLOG(@"textSize.height:%f",textSize.height);
    //    DLOG(@"textSize.width:%f",textSize.width);
    if (textSize.height<16.6) {
        textSize.height = 16.6 ;
    }
    return textSize.height;
}

+ (CGSize)sizeOfLabelForFromString:(NSString *)text fontSizeandLabelWidth:(CGFloat)width andFontSize:(CGFloat)fontSize
{
    
    if (!text) {
        return CGSizeMake(0, 0);
    }
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, 1600) // 用于计算文本绘制时占据的矩形块
                                         options:NSStringDrawingUsesLineFragmentOrigin   // 文本绘制时的附加选项
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}        // 文字的属性
                                         context:nil].size;
    //    DLOG(@"textSize.height:%f",textSize.height);
    //    DLOG(@"textSize.width:%f",textSize.width);
    if (textSize.height<16.6) {
        textSize.height = 16.6 ;
    }
    return textSize;
}


@end
