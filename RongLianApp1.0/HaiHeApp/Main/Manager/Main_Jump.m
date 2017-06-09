//
//  Main_Jump.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Main_Jump.h"
#import "SafeSetTableViewController.h"

@interface Main_Jump ()

@property(nonatomic,strong)UIViewController *current;

@end

@implementation Main_Jump

+(id)shareManager{
     static Main_Jump *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[Main_Jump alloc]init];
    });
    return shareManager;
}


-(void)addNsnotionWithView:(UIViewController *)view{
    self.current = view;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Shenhe_Progress) name:Nsnotion_Shenhe object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HuanQuan_Jihua) name:Nsnotion_Huankuan object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Safe_Set) name:Nsnotion_SafeSet object:nil];
}
-(void)Shenhe_Progress{
    [self.current.navigationController popViewControllerAnimated:NO];
}
-(void)HuanQuan_Jihua{
    [self.current.navigationController popViewControllerAnimated:NO];
    RootTableViewController *rootvc = [[RootTableViewController alloc]init];
    [self.current.navigationController pushViewController:rootvc animated:NO];
    
}
-(void)Safe_Set{
    [self.current.navigationController popViewControllerAnimated:NO];
    SafeSetTableViewController * safeVC = [[SafeSetTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//    _userId = [userdefault objectForKey:@"Myuserid"];
    
    safeVC.userid = [userdefault objectForKey:@"Myuserid"];
    safeVC.phonenum = [UserLoginStatus shareManager].username;
    safeVC.phoneStr = [UserLoginStatus shareManager].username;
    safeVC.zhuceTime = @"";
    safeVC.loginname = [UserLoginStatus shareManager].username;
    
    [self.current.navigationController pushViewController:safeVC animated:NO];
    
}


@end



