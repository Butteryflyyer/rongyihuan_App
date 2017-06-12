//
//  ShowWebView.h
//  HaiHeApp
//
//  Created by 马广召 on 15/11/9.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowWebView : UIView<UIGestureRecognizerDelegate,NSURLConnectionDelegate>
+ (ShowWebView *)shareManager;

- (void)showMessage;
@end
