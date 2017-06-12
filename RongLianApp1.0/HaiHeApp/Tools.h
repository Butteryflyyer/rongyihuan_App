//
//  Tools.h
//  HaiHeApp
//
//  Created by 信昊 on 17/6/8.
//  Copyright © 2017年 马广召. All rights reserved.
//

#ifndef Tools_h
#define Tools_h


#define Nsnotion_Shenhe @"Shenhe_Progress"
#define Nsnotion_Huankuan @"HuanQuan_Jihua"
#define Nsnotion_SafeSet @"Safe_Set"
#define Nsnotion_ShuaXinPhone @"ShuaXinPhone"
#define Nsnotion_TanchuComponyIntroduce @"TanchuComponyIntroduce"
#define Nsnotion_AutonLogin_after_regist @"AutonLogin_after_regist" //注册之后自动登录

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define IMG(ImageName) [UIImage imageNamed:ImageName]

#define _COLOR_RGB(rgbValue) [UIColor colorWith\
Red     :(rgbValue & 0xFF0000)     / (float)0xFF0000 \
green   :(rgbValue & 0xFF00)       / (float)0xFF00 \
blue    :(rgbValue & 0xFF)         / (float)0xFF \
alpha   :1.0]

#define IPHONE5s 568
#define IPHONE4s 480

#define IPHONE6  667

#define IPHONE6PLUS 736

#endif /* Tools_h */
