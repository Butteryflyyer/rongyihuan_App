//
//  ShowMainScreanView.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/1.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ShowMainScreanView.h"

@interface ShowMainScreanView()
@property (nonatomic, retain)UIView *showview;
@end

@implementation ShowMainScreanView

+ (ShowMainScreanView *)shareManager{
    static ShowMainScreanView * messageViewManagerinstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        messageViewManagerinstance = [[self alloc] init];
    });
    return messageViewManagerinstance;
}

- (void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _showview = showview;
    //点击事件;
    UITapGestureRecognizer * deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBuyView:)];
    //deleteTap.delegate = self;
    [deleteTap setNumberOfTapsRequired:1];
    [deleteTap setNumberOfTouchesRequired:1];
    [showview addGestureRecognizer:deleteTap];

    
    showview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    //showview.alpha = 1.0f;
    //showview.layer.cornerRadius = 5.0f;
    //showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(showview.frame.size.width-20, 9000)];
    
    //    CGSize  misize = [message boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>];
    
    label.frame = CGRectMake(10, showview.frame.size.height/4,showview.frame.size.width-20, LabelSize.height);
    label.text = message;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    [showview addSubview:label];
    //showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - LabelSize.width - 20)/2, [UIScreen mainScreen].bounds.size.height/2-50, LabelSize.width+20, LabelSize.height+10);
//    [UIView animateWithDuration:1.5 animations:^{
//        showview.alpha = 0;
//    } completion:^(BOOL finished) {
//        [showview removeFromSuperview];
//    }];
}

- (void)deleteBuyView:(id)sender{
    [_showview removeFromSuperview];
}

@end
