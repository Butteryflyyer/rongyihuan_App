//
//  LoginViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/16.
//  Copyright © 2015年 马广召. All rights reserved.
//

#define W (self.view.frame.size.width)
#define H (self.view.frame.size.height)
#import "LoginViewController.h"
#import "ForgetPasswordTableViewController.h"
#import "RegisterTableViewController.h"
#import "RegularClass.h"
#import "ShowMessageView.h"
#import "HaiHeNetBridge.h"
#import "UserLoginStatus.h"
#import "SSKeychain.h"
#import "HaiheHeader.h"
#import "Main_ComponyIntoduce.h"
@interface LoginViewController ()
@property (nonatomic, retain)UITextField * nameTF;
@property (nonatomic, retain)UITextField * passwordTF;
@property(nonatomic,strong)UIButton *Login_btn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg"]];
    [self addSomeSubViews];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLogin:) name:Nsnotion_AutonLogin_after_regist object:nil];
}
-(void)autoLogin:(NSNotification *)info{
 //        NSDictionary *dic = @{@"phone":strongSelf.registerPhone,@"password":passwordTF.text};
    NSDictionary *dic = [info object];
    if ([dic[@"phone"] length]>0 && [dic[@"password"] length]>0) {
        self.nameTF.text = dic[@"phone"];
        self.passwordTF.text = dic[@"password"];
        [self submitButtonBeTouched:self.Login_btn];
    }
}
- (void)selectViewBeTap{
    if ([_nameTF isFirstResponder]) {
        [_nameTF resignFirstResponder];
    }
    if ([_passwordTF isFirstResponder]) {
        [_passwordTF resignFirstResponder];
    }
}

- (void)addSomeSubViews{
    
    //左上角取消按钮;
    if (_hidendelete) {
        //
    }else{
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(20, 20, 50, 50);
        [deleteBtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 15, 30)];
        [deleteBtn addTarget:self action:@selector(deleteButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
        //[self.view addSubview:deleteBtn];
    }
    
    //两条横线;
    for (int i=0; i<2; i++) {
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(15, H/4+60*i+10, W-30, 1)];
        lineV.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineV];
    }
    //用户名;
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, H/4-30, W-80, 50)];
    _nameTF.placeholder = @"手机号/用户名";
    _nameTF.keyboardType = UIKeyboardTypeDefault;
    _nameTF.delegate = self;
    _nameTF.tag = 1000;
    [_nameTF setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _nameTF.textColor = [UIColor whiteColor];
    //_nameTF.backgroundColor = [UIColor redColor];
    _nameTF.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_nameTF];
    //密码;
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(15, H/4+30, W-130, 50)];
    _passwordTF.placeholder = @"密码";
    _passwordTF.delegate = self;
    _passwordTF.tag = 2000;
    _passwordTF.textColor = [UIColor lightGrayColor];
    [_passwordTF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTF.secureTextEntry = YES;
    _passwordTF.font = [UIFont systemFontOfSize:15];
    //_passwordTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:_passwordTF];
    //登录按钮;
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(20,H/4+110,W-40, 40);
    [submitBtn setTitle:@"登录" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = nav_bgcolor;
    [submitBtn addTarget:self action:@selector(submitButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.Login_btn = submitBtn;
    //取消按钮;
    for (int i=0; i<2; i++) {
        UIButton * clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.tag = 3000+i;
        clearBtn.frame = CGRectMake(W-65-50*i,H/4-30+60*i,50, 50);
        //[clearBtn setTitle:@"登录" forState:UIControlStateNormal];
        [clearBtn setImage:[UIImage imageNamed:@"deleteicon"] forState:UIControlStateNormal];
        clearBtn.hidden = YES;
        [clearBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        [clearBtn addTarget:self action:@selector(clearButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clearBtn];
        
    }
    //密码可见;
    UIButton * seeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seeBtn.frame = CGRectMake(W-65,H/4+30,50, 50);
    //seeBtn.backgroundColor = [UIColor redColor];
    [seeBtn setImage:[UIImage imageNamed:@"meimao"] forState:UIControlStateNormal];
    [seeBtn setImageEdgeInsets:UIEdgeInsetsMake(17,12,17,12)];
    [seeBtn addTarget:self action:@selector(seeButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seeBtn];
    
    //忘记密码 注册;
    NSArray * titleArray = @[@"忘记密码?",@"立刻注册"];
    for (int j=0; j<2; j++) {
        UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        bottomBtn.tag = 4000+j;
        bottomBtn.frame = CGRectMake((W-200)/2+100*j, H-90, 100 , 50);
        [bottomBtn setTitle:titleArray[j] forState:UIControlStateNormal];
        // bottomBtn.backgroundColor = [UIColor redColor];
        [bottomBtn addTarget:self action:@selector(forgetButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bottomBtn];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==1000) {
        UIButton * button = (UIButton *)[self.view viewWithTag:3000];
        if (range.location>0) {
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }else{
        UIButton * button = (UIButton *)[self.view viewWithTag:3001];
        if (range.location>0) {
            button.hidden = NO;
        }else{
            button.hidden = YES;
        }
    }
    return YES;
}

- (void)clearButtonBeTouched:(UIButton *)sender{
    if(sender.tag==3000){
        _nameTF.text = @"";
    }else if (sender.tag==3001){
        _passwordTF.text = @"";
    }
}

- (void)seeButtonBeTouched:(UIButton *)sender{
    //[sender setImage:[UIImage imageNamed:@"meimao"] forState:UIControlStateNormal];
    if(_passwordTF.secureTextEntry){
        [sender setImage:[UIImage imageNamed:@"login_show"] forState:UIControlStateNormal];
        _passwordTF.secureTextEntry = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"meimao"] forState:UIControlStateNormal];
        _passwordTF.secureTextEntry = YES;
    }
}

- (void)submitButtonBeTouched:(UIButton *)sender{
    
    
    UIActivityIndicatorView * actV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    actV.center = self.view.center;
    [self.view addSubview:actV];
    //    [actV startAnimating];
    [actV setHidesWhenStopped:YES];
    if ([_nameTF.text isEqualToString:@""]) {
        [[ShowMessageView shareManager] showMessage:@"用户名不能为空"];
    }else if (![[[RegularClass shareManager] isUserName:_nameTF.text] isEqualToString:@"yes"]){
        [[ShowMessageView shareManager] showMessage:[[RegularClass shareManager] isUserName:_nameTF.text]];
    }else if (_passwordTF.text.length<6){
        [[ShowMessageView shareManager] showMessage:@"密码不能少于6位"];
    }else if (_passwordTF.text.length>20){
        [[ShowMessageView shareManager] showMessage:@"密码不能大于20位"];
    }else{
        [actV startAnimating];
        __weak typeof(self)weakSelf = self;
                [[HaiHeNetBridge sharedManager] userLoginRequestWithUserName:_nameTF.text andWithPassword:_passwordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                    __strong typeof(self)strongify = weakSelf;
                            [actV stopAnimating];
                            sender.enabled = YES;
                        if(respString){
                            [[ShowMessageView shareManager] showMessage:respString];
                            }else{
                                    //保存用户名和密码;
                            NSArray * accArr = [SSKeychain accountsForService:@"ronglian"];
                                    for (int i=0; i<accArr.count; i++) {
                                        NSDictionary * accDic  = accArr[i];
                                        NSString * name = [accDic objectForKey:@"acct"];
                                        [SSKeychain deletePasswordForService:@"ronglian" account:name];
                                    }
        
                    if([SSKeychain setPassword:_passwordTF.text forService:@"ronglian" account:_nameTF.text]){
                        if ([[datadic objectForKey:@"userId"]isKindOfClass:[NSNull class]]) {
                                [[ShowMessageView shareManager] showMessage:@"数据错误,请重试"];
                        }else{
                       // 监听 
                          
                          
                            NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
                            [userdefault setObject:[datadic objectForKey:@"userId"] forKey:@"Myuserid"];
                            [userdefault setObject:[datadic objectForKey:@"userName"] forKey:@"UserName"];
                            [userdefault setObject:[datadic objectForKey:@"userTel"] forKey:@"userTel"];
                            [UserLoginStatus shareManager].userid = [datadic objectForKey:@"userId"];
                            NSLog(@"%@",[UserLoginStatus shareManager].userid);
                            
                            [UserLoginStatus shareManager].username = _nameTF.text;
                            [UserLoginStatus shareManager].userTel = [datadic objectForKey:@"userTel"];
                            [Main_ComponyIntoduce shareManager].Compony_Num = 0;
                            
                            [strongify.navigationController popViewControllerAnimated:YES];
                            
                            [strongify goIntoMain];
                                }
                                        
                                }else{
                            [[ShowMessageView shareManager] showMessage:@"本地数据有误,联系开发者"];
                                    }
                                }
                    
                    
                        }];

    }
    
    
//    if(![_nameTF.text isEqualToString:@""]){
//        
//        if ([[RegularClass shareManager] isUserName:_nameTF.text]) {
//            if (![_passwordTF.text isEqualToString:@""]) {
//                if([[RegularClass shareManager] isUserPassword:_passwordTF.text]){
//                    [actV startAnimating];
//                    [[HaiHeNetBridge sharedManager] userLoginRequestWithUserName:_nameTF.text andWithPassword:_passwordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                        [actV stopAnimating];
//                        sender.enabled = YES;
//                        if(respString){
//                            [[ShowMessageView shareManager] showMessage:respString];
//                        }else{
//                            //保存用户名和密码;
//                            NSArray * accArr = [SSKeychain accountsForService:@"haihejinrong"];
//                            for (int i=0; i<accArr.count; i++) {
//                                NSDictionary * accDic  = accArr[i];
//                                NSString * name = [accDic objectForKey:@"acct"];
//                                [SSKeychain deletePasswordForService:@"haihejinrong" account:name];
//                            }
//                            
//                            if([SSKeychain setPassword:_passwordTF.text forService:@"haihejinrong" account:_nameTF.text]){
//                                if ([[datadic objectForKey:@"userId"]isKindOfClass:[NSNull class]]) {
//                                    [[ShowMessageView shareManager] showMessage:@"数据错误,请重试"];
//                                }else{
//                                    [UserLoginStatus shareManager].userid = [datadic objectForKey:@"userId"];
//                                    [UserLoginStatus shareManager].username = _nameTF.text;
//                                    
//                                    LLLockViewController * lockVC = [[LLLockViewController alloc] init];
//                                    lockVC.nLockViewType = LLLockViewTypeCreate;
//                                    
//                                    lockVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                                    
//                                    [self presentViewController:lockVC animated:NO completion:^{
//                                        NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//                                        [userdefault setObject:@"1" forKey:@"haveshoushimima"];
//                                        [userdefault synchronize];
//                                        //self.tabBarController.selectedIndex = 0;
//                                    }];
//                                    
//                                    
//                                    [self.navigationController popToRootViewControllerAnimated:YES];
//                                }
//                                
//                            }else{
//                                [[ShowMessageView shareManager] showMessage:@"错误000,联系开发者"];
//                            }
//                        }
//                    }];
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"密码格式不正确"];
//                }
//            }else{
//                [[ShowMessageView shareManager] showMessage:@"密码不能为空"];
//            }
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"用户名格式不正确"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"用户名不能为空"];
//    }
}

- (void)deleteButtonBeTouched{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    SlideRootViewController *slideVc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    
//
//        slideVc.panGesture.enabled = NO;

}

//- (void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
//}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    SlideRootViewController *slideVc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    
//
//        slideVc.panGesture.enabled = YES;
    
}

- (void)forgetButtonBeTouched:(UIButton *)sender{
    if(sender.tag == 4000){
        ForgetPasswordTableViewController * forgetVC = [[ForgetPasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }else{
        RegisterTableViewController * registerVC = [[RegisterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}
#pragma mark -- 哪个是主页
-(void)goIntoMain{
    /**
     EnterPage = 1 首页为审核进度页面。EnterPage = 0  没有申请显示公司介绍弹框。 EnterPage = 2 还款计划表
     
     */
    __weak LoginViewController *weakSelf = self;
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
                
               [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                [[Main_Jump shareManager] addNsnotionWithView:root_main];
                
            }else if ([datadic[@"EnterPage"] integerValue]==0){
                Shenhe_Progress_Vc *shenhe_main = [[Shenhe_Progress_Vc alloc]init];
                
                leftMain_Vc *leftmain = [[leftMain_Vc alloc]init];
                
                RootNavigationController *ncMain = [[RootNavigationController alloc]initWithRootViewController:shenhe_main];
                RootNavigationController *ncLeft = [[RootNavigationController alloc]initWithRootViewController:leftmain];
                SlideRootViewController *vc = [[SlideRootViewController alloc]initWithLeftVC:ncLeft mainVC:ncMain slideTranslationX:200];
                
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                [[Main_Jump shareManager] addNsnotionWithView:shenhe_main];
                
            }else if ([datadic[@"EnterPage"] integerValue] == 1){
                Shenhe_Progress_Vc *shenhe_main = [[Shenhe_Progress_Vc alloc]init];
                
                leftMain_Vc *leftmain = [[leftMain_Vc alloc]init];
                
                RootNavigationController *ncMain = [[RootNavigationController alloc]initWithRootViewController:shenhe_main];
                RootNavigationController *ncLeft = [[RootNavigationController alloc]initWithRootViewController:leftmain];
                SlideRootViewController *vc = [[SlideRootViewController alloc]initWithLeftVC:ncLeft mainVC:ncMain slideTranslationX:200];
                
               [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                [[Main_Jump shareManager] addNsnotionWithView:shenhe_main];
   
                
            }
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
