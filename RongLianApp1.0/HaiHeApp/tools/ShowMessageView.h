//
//  ShowMessageView.h
//  HaiHeBankingPro
//
//  Created by 马广召 on 15/7/15.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMessageView : UIView
+ (ShowMessageView *)shareManager;

- (void)showMessage:(NSString *)message;
@end
