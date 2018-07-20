//
//  AppDelegate.m
//  HaiHeApp
//
//  Created by 马广召 on 15/9/24.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"
#import "HaiHeNetBridge.h"
#import "UserLoginStatus.h"
//ShareSDK
#import "DESObject.h"
//#import "APService.h"
//#import "JPUSHService.h"
#import "gaode_Location.h"
#import "DESEncryptFile.h"
#import "HandleAddressBook.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SlideRootViewController.h"
#import "Shenhe_Progress_Vc.h"
#import "LoginViewController.h"
#import "RootNavigationController.h"
#import "leftMain_Vc.h"
#import "ViewController.h"

//dasfafsdfdsfadadsads

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RootTableViewController *Root_main = [[RootTableViewController alloc]init];
    
    leftMain_Vc *leftmain = [[leftMain_Vc alloc]init];
    
    RootNavigationController *ncMain = [[RootNavigationController alloc]initWithRootViewController:Root_main];
     RootNavigationController *ncLeft = [[RootNavigationController alloc]initWithRootViewController:leftmain];
    SlideRootViewController *vc = [[SlideRootViewController alloc]initWithLeftVC:ncLeft mainVC:ncMain slideTranslationX:200];
    
    self.window.rootViewController = vc;
    [[Main_Jump shareManager] addNsnotionWithView:Root_main];

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"]) {
        [UserLoginStatus shareManager].username = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Myuserid"]) {
        [UserLoginStatus shareManager].userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"Myuserid"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userTel"]) {
        [UserLoginStatus shareManager].userTel = [[NSUserDefaults standardUserDefaults]objectForKey:@"userTel"];
    }
     [AMapServices sharedServices].apiKey = @"64042588deacc84669e9a718e0c9c481";
//      __weak AppDelegate *weakSelf = self;
//    [[gaode_Location shareInstance] getLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode) {
//
//    }];
    [HandleAddressBook addressBookAuthorization:^(NSMutableArray<PersonInfoModel *> *personInfoArray) {
        NSLog(@"%@",personInfoArray);
    }];
    //love
    if ([UserLoginStatus shareManager].userid.length > 0) {
        NSArray * accoutArr = [SSKeychain accountsForService:@"ronglian"];
        NSLog(@"%@",accoutArr);
        if (accoutArr&&accoutArr.count>0) {
            NSDictionary * usermessageDic = accoutArr[0];
            NSString * usernameStr = [usermessageDic objectForKey:@"acct"];
            [UserLoginStatus shareManager].username = usernameStr;
 
            NSString * passwordStr = [SSKeychain passwordForService:@"ronglian" account:usernameStr];
            if (passwordStr) {
                //登录;
                [[HaiHeNetBridge sharedManager] userLoginRequestWithUserName:usernameStr andWithPassword:passwordStr WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                    if(respString){
        
                        [[Rongyihuan_Tools getCurrentVC].navigationController pushViewController:[[LoginViewController alloc]init] animated:NO];
                    }else{
                        //保存用户名和密码;
                        if ([[datadic objectForKey:@"userId"]isKindOfClass:[NSNull class]]) {
                            
                        }else{
                            NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
                            if (![userdefault objectForKey:@"isfirststart1"]) {
                                NSArray * accArr = [SSKeychain accountsForService:@"ronglian"];
                                for (int i=0; i<accArr.count; i++) {
                                    NSDictionary * accDic  = accArr[i];
                                    NSString * name = [accDic objectForKey:@"acct"];
                                    [SSKeychain deletePasswordForService:@"ronglian" account:name];
                                    [userdefault setObject:@"10" forKey:@"haveshoushimima"];
                                    [userdefault setObject:@"" forKey:@"username_lock"];
                                }
                                 [self goIntoMain];
                            }else{
                                [UserLoginStatus shareManager].userid = [datadic objectForKey:@"userId"];
                                [UserLoginStatus shareManager].username = usernameStr;
                                [UserLoginStatus shareManager].userTel = [datadic objectForKey:@"userTel"];
                                [self goIntoMain];
                            }
                            
                            
                        }
                    }
                }];
                
            }else{
                //修改密码了;
                
            }
        }else{
            //新用户;
            
        }

    }
    
    
  
    
    
    
        NSLog(@"%@",[UserLoginStatus shareManager].userid);
    
//    //装过卸载后的问题
//    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//    if (![userdefault objectForKey:@"isfirststart1"]) {
//        [userdefault setObject:@"meiyou" forKey:@"haveshoushimima"];
//    }else{
//        [UserLoginStatus shareManager].userid = @"";
//        [UserLoginStatus shareManager].username = @"";
//    }
//    
    
    
#pragma makr Jpush;
    //极光推送;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                       UIUserNotificationTypeSound |
//                                                       UIUserNotificationTypeAlert)
//                                           categories:nil];
//    } else {
//        //categories 必须为nil
////        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
////                                                       UIRemoteNotificationTypeSound |
////                                                       UIRemoteNotificationTypeAlert)
////                                           categories:nil];
//    }
//    
//    // Required
//    [JPUSHService setupWithOption:launchOptions];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
////    else {
////        //categories 必须为nil
////        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
////                                                          UIRemoteNotificationTypeSound |
////                                                          UIRemoteNotificationTypeAlert)
////                                              categories:nil];
////    }
//    
//    // Required
//    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
//    [JPUSHService setupWithOption:launchOptions appKey:@"52c8127df555fdcd9b8d80da" channel:nil apsForProduction:YES];
    
  
    return YES;
}

#pragma mark -- 哪个是主页
-(void)goIntoMain{
/**
 EnterPage = 1 首页为审核进度页面。EnterPage = 0  没有申请显示公司介绍弹框。 EnterPage = 2 还款计划表
 
 */
    __weak AppDelegate *weakSelf = self;
    [[HaiHeNetBridge sharedManager]goIntoSomePageWithUserid:[UserLoginStatus shareManager].userid WithTel:[UserLoginStatus shareManager].userTel WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        if (respString) {
            
        }else{
            NSLog(@"%@",datadic);
            if ([datadic[@"EnterPage"] integerValue]==2) {
                RootTableViewController *root_main = [[RootTableViewController alloc]init];
                
                leftMain_Vc *leftmain = [[leftMain_Vc alloc]init];
                
                RootNavigationController *ncMain = [[RootNavigationController alloc]initWithRootViewController:root_main];
                RootNavigationController *ncLeft = [[RootNavigationController alloc]initWithRootViewController:leftmain];
                SlideRootViewController *vc = [[SlideRootViewController alloc]initWithLeftVC:ncLeft mainVC:ncMain slideTranslationX:200];
                
                weakSelf.window.rootViewController = vc;
                [[Main_Jump shareManager] addNsnotionWithView:root_main];

            }else if ([datadic[@"EnterPage"] integerValue]==0){
                Shenhe_Progress_Vc *shenhe_main = [[Shenhe_Progress_Vc alloc]init];
                
                leftMain_Vc *leftmain = [[leftMain_Vc alloc]init];
                
                RootNavigationController *ncMain = [[RootNavigationController alloc]initWithRootViewController:shenhe_main];
                RootNavigationController *ncLeft = [[RootNavigationController alloc]initWithRootViewController:leftmain];
                SlideRootViewController *vc = [[SlideRootViewController alloc]initWithLeftVC:ncLeft mainVC:ncMain slideTranslationX:200];
                
                weakSelf.window.rootViewController = vc;
                [[Main_Jump shareManager] addNsnotionWithView:shenhe_main];

            }else if ([datadic[@"EnterPage"] integerValue] == 1){
                Shenhe_Progress_Vc *shenhe_main = [[Shenhe_Progress_Vc alloc]init];
                
                leftMain_Vc *leftmain = [[leftMain_Vc alloc]init];
                
                RootNavigationController *ncMain = [[RootNavigationController alloc]initWithRootViewController:shenhe_main];
                RootNavigationController *ncLeft = [[RootNavigationController alloc]initWithRootViewController:leftmain];
                SlideRootViewController *vc = [[SlideRootViewController alloc]initWithLeftVC:ncLeft mainVC:ncMain slideTranslationX:200];
                
                weakSelf.window.rootViewController = vc;
                [[Main_Jump shareManager] addNsnotionWithView:shenhe_main];
                [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_TanchuComponyIntroduce object:nil];

            }
        }
    }];
}


//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    // Required
//    [JPUSHService registerDeviceToken:deviceToken];
//}
////2016年1月18号
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    // IOS 7 Support Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    // Required
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    if ([[userdefault objectForKey:@"haveshoushimima"]isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoushiActive" object:self];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//    if ([userdefault objectForKey:@"haveshoushi"]) {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShoushiActive" object:self];
//    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
