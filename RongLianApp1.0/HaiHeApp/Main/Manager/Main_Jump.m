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



@end

@implementation Main_Jump

+(id)shareManager{
     static Main_Jump *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[Main_Jump alloc]init];
        shareManager.postNum_location_phone = 0;
    });
    return shareManager;
}


-(void)addNsnotionWithView:(UIViewController *)view{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.current = view;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Shenhe_Progress) name:Nsnotion_Shenhe object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HuanQuan_Jihua) name:Nsnotion_Huankuan object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Safe_Set) name:Nsnotion_SafeSet object:nil];
}
-(void)Shenhe_Progress{
     [self.current.navigationController popViewControllerAnimated:NO];
    if ([self.current isKindOfClass:[RootTableViewController class]]) {
        Shenhe_Progress_Vc *shenVc = [[Shenhe_Progress_Vc alloc]init];
        [self.current.navigationController pushViewController:shenVc animated:NO];
        NSLog(@"%@",[self.current class]);
        NSLog(@"%@",self.current);
        
    }else{
       
    }
    SlideRootViewController *rootvc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootvc slideBack];
}
-(void)HuanQuan_Jihua{
    [self.current.navigationController popViewControllerAnimated:NO];
    if ([self.current isKindOfClass:[Shenhe_Progress_Vc class]]) {
        RootTableViewController *rootvc = [[RootTableViewController alloc]init];
        [self.current.navigationController pushViewController:rootvc animated:NO];
    }
    SlideRootViewController *rootvc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootvc slideBack];
}
-(void)Safe_Set{
    [self.current.navigationController popViewControllerAnimated:NO];
    SafeSetTableViewController * safeVC = [[SafeSetTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    safeVC.userid = [UserLoginStatus shareManager].userid;
    safeVC.phonenum = [UserLoginStatus shareManager].userTel;
    safeVC.loginname = [UserLoginStatus shareManager].userTel;
    
    [self.current.navigationController pushViewController:safeVC animated:NO];
    SlideRootViewController *rootvc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootvc slideBack];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end



