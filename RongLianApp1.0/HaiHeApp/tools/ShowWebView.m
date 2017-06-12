//
//  ShowWebView.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/9.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ShowWebView.h"
//#import <WebKit/WebKit.h>
@interface ShowWebView()
@property (nonatomic, retain)UIView *showview;
@end

@implementation ShowWebView

+ (ShowWebView *)shareManager{
    static ShowWebView * messageViewManagerinstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        messageViewManagerinstance = [[self alloc] init];
    });
    return messageViewManagerinstance;
}

- (void)showMessage
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
    
    UIWebView * wkV = [[UIWebView alloc] initWithFrame:CGRectMake(10, showview.frame.size.height/3, showview.frame.size.width-20, showview.frame.size.height/3)];
    wkV.layer.cornerRadius = 5;
    wkV.layer.masksToBounds = YES;
    [wkV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://223.202.60.29/app_webservice/app/bankIllustration.html"]]];
    [showview addSubview:wkV];
    
}

- (void)deleteBuyView:(id)sender{
    [_showview removeFromSuperview];
}

@end
