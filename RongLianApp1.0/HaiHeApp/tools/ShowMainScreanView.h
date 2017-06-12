//
//  ShowMainScreanView.h
//  HaiHeApp
//
//  Created by 马广召 on 15/11/1.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMainScreanView : UIView<UIGestureRecognizerDelegate>
+ (ShowMainScreanView *)shareManager;

- (void)showMessage:(NSString *)message;
@end
