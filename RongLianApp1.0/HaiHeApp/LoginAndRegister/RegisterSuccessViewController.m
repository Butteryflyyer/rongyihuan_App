//
//  RegisterSuccessViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/16.
//  Copyright © 2015年 马广召. All rights reserved.
//

#define W (self.view.frame.size.width)
#define H (self.view.frame.size.height)
#import "RegisterSuccessViewController.h"
#import "HaiheHeader.h"
#import "SafeSetTableViewController.h"
//#import "InvestViewController.h"
#import "UserLoginStatus.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
@interface RegisterSuccessViewController ()

@end

@implementation RegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册成功";
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSomeSubViews];
    // Do any additional setup after loading the view.
}

- (void)addSomeSubViews{
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(W*3/8, (H-W)/4, W/4, W/4)];
    //imgV.backgroundColor = [UIColor redColor];
    imgV.image = [UIImage imageNamed:@"success"];
    [self.view addSubview:imgV];
    
    UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, H/4, W, 40)];
    hintL.text = @"注册成功";
    hintL.textAlignment = NSTextAlignmentCenter;
    hintL.textColor = [UIColor grayColor];
    hintL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:hintL];


    UIButton * safeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    safeBtn.frame = CGRectMake(10, H/4+70, W-20, 40);
    [safeBtn setTitle:@"安全设置" forState:UIControlStateNormal];
    [safeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    safeBtn.backgroundColor = nav_bgcolor;
    [safeBtn addTarget:self action:@selector(safeButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
    safeBtn.layer.cornerRadius = 3;
    safeBtn.layer.masksToBounds = YES;
    [self.view addSubview:safeBtn];
    
}

- (void)safeButtonBeTouched{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
