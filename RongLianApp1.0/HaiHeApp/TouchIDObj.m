//
//  TouchIDObj.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/6.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "TouchIDObj.h"
#import <LocalAuthentication/LocalAuthentication.h>
@implementation TouchIDObj

+ (TouchIDObj *)shareManager{
    static TouchIDObj * regularManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        regularManagerInstance = [[self alloc] init];
    });
    return regularManagerInstance;

}



//- (NSString *)authenticateUser
//{
//    //初始化上下文对象
//    LAContext* context = [[LAContext alloc] init];
//    //错误对象
//    NSError* error = nil;
//    NSString* result = @"Authentication is needed to access your notes.";
//   // NSMutableString * returnStr = [NSMutableString string];
//    
//    //首先使用canEvaluatePolicy 判断设备支持状态
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
//        //支持指纹验证
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
//            if (success) {
//                //验证成功，主线程处理UI
//            }
//            else
//            {
//                NSLog(@"%@",error.localizedDescription);
//                switch (error.code) {
//                    case LAErrorSystemCancel:
//                    {
//                        NSLog(@"Authentication was cancelled by the system");
//                        //切换到其他APP，系统取消验证Touch ID
//                        break;
//                    }
//                    case LAErrorUserCancel:
//                    {
//                        NSLog(@"Authentication was cancelled by the user");
//                        //用户取消验证Touch ID
//                        break;
//                    }
//                    case LAErrorUserFallback:
//                    {
//                        NSLog(@"User selected to enter custom password");
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            //用户选择输入密码，切换主线程处理
//                        }];
//                        break;
//                    }
//                    default:
//                    {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            //其他情况，切换主线程处理
//                        }];
//                        break;
//                    }
//                }
//            }
//        }];
//    }
//    else
//    {
//        //不支持指纹识别，LOG出错误详情
//        
//        switch (error.code) {
//            case LAErrorTouchIDNotEnrolled:
//            {
//                NSLog(@"TouchID is not enrolled");
//                break;
//            }
//            case LAErrorPasscodeNotSet:
//            {
//                NSLog(@"A passcode has not been set");
//                break;
//            }
//            default:
//            {
//                NSLog(@"TouchID not available");
//                break;
//            }
//        }
//        
//        NSLog(@"%@",error.localizedDescription);
//        //[self showPasswordAlert];
//    }
//    
//    return 0;
//    
//    
//}
@end
