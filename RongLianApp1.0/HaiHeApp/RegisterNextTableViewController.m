//
//  RegisterNextTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/16.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "RegisterNextTableViewController.h"
#import "RightImageTableViewCell.h"
#import "RightButtonTableViewCell.h"
#import "HaiheHeader.h"
#import "RegisterSuccessViewController.h"
#import "RegularClass.h"
#import "ShowMessageView.h"
#import "HaiHeNetBridge.h"
#import "SSKeychain.h"
#import "UserLoginStatus.h"


@interface RegisterNextTableViewController ()
@property (nonatomic, retain)NSMutableArray * titleArr;
@property (nonatomic, retain)UIImageView * yaoqingImgV;
@property (nonatomic, assign)BOOL yaoqingShow;
@property (nonatomic, retain)UIButton * yanzhengBtn;
@property (nonatomic,assign)NSInteger secondCount;
@property (nonatomic,retain)NSTimer * cutdownT;
@property (nonatomic, retain)UILabel * timeLabel;
@property (nonatomic, retain)NSString * yanzhengStr;
@property (nonatomic, retain)UIButton * yuyinBtn;
@property (nonatomic, assign)BOOL sendyuyin;


@end

@implementation RegisterNextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yaoqingShow = YES;
    NSArray * array = @[@"请输入验证码",@"请输入密码",@"请确认密码"];
    _titleArr = [NSMutableArray arrayWithArray:array];
    self.navigationItem.title = @"注册";
    _sendyuyin = NO;
    
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
 
}

- (void)selectViewBeTap{
    UITextField * yanzhengTF = (UITextField *)[self.tableView viewWithTag:1000];
    UITextField * passwordTF = (UITextField *)[self.tableView viewWithTag:1001];
    UITextField * psagainTF = (UITextField *)[self.tableView viewWithTag:1002];
    UITextField * yaoqingTF = (UITextField *)[self.tableView viewWithTag:1003];

    if ([yanzhengTF isFirstResponder]) {
        [yanzhengTF resignFirstResponder];
    }
    if ([passwordTF isFirstResponder]) {
        [passwordTF resignFirstResponder];
    }
    if ([psagainTF isFirstResponder]) {
        [psagainTF resignFirstResponder];
    }
    if ([yaoqingTF isFirstResponder]) {
        [yaoqingTF resignFirstResponder];
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return _titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        static NSString * cellidentifi = @"registernextcell";
        RightButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
        if(!cell){
            cell = [[RightButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
        }
        cell.titleTextfield.placeholder = @"请输入验证码";
        cell.titleTextfield.tag = 1000+indexPath.row;
        
        _yanzhengBtn = cell.getcodeBtn;
        _timeLabel = cell.timeLable;
        [_yanzhengBtn addTarget:self action:@selector(yanzhengButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self yanzhengButtonBeTouched:_yanzhengBtn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        static NSString * cellident = @"registernext";
        RightImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellident];
        if(!cell){
            cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
        }
        if(indexPath.row!=3){
            cell.titleTextfield.secureTextEntry = YES;
        }
        cell.titleTextfield.placeholder = _titleArr[indexPath.row];
        cell.titleTextfield.tag = 1000+indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerV = [[UIView alloc] init];
    UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    hintL.text = [NSString stringWithFormat:@"已向手机%@发送验证码",_registerPhone];
    hintL.textAlignment = NSTextAlignmentCenter;
    hintL.textColor = [UIColor lightGrayColor];
    hintL.font = [UIFont systemFontOfSize:14];
    [headerV addSubview:hintL];
    return headerV;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerV = [[UIView alloc] init];
    UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    hintL.text = @"收不到验证码?";
    hintL.textColor = [UIColor grayColor];
   // hintL.backgroundColor = [UIColor greenColor];
    hintL.textAlignment = NSTextAlignmentLeft;
    hintL.font = [UIFont systemFontOfSize:14];
    //[footerV addSubview:hintL];
    
    UIButton * yuyinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yuyinBtn = yuyinBtn;
    yuyinBtn.frame = CGRectMake(100, 0, 130, 50);
    yuyinBtn.backgroundColor = [UIColor clearColor];
    [yuyinBtn setTitle:@"点击获取语音验证码" forState:UIControlStateNormal];
    [yuyinBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
    yuyinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [yuyinBtn addTarget:self action:@selector(yuyinButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    //[footerV addSubview:yuyinBtn];
    
//    UIButton * yaoqingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    yaoqingBtn.frame = CGRectMake(tableView.frame.size.width-85, 0, 60, 50);
//    yaoqingBtn.backgroundColor = [UIColor clearColor];
//    [yaoqingBtn setTitle:@"邀请码" forState:UIControlStateNormal];
//    [yaoqingBtn setTitleColor:[UIColor colorWithRed:254/255.0 green:184/255.0 blue:62/255.0 alpha:1] forState:UIControlStateNormal];
//    yaoqingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [yaoqingBtn addTarget:self action:@selector(yaoqingButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [footerV addSubview:yaoqingBtn];
    
    _yaoqingImgV = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width-30, 20, 15, 10)];
    _yaoqingImgV.image = [UIImage imageNamed:@"yaoqingdown"];
    _yaoqingShow = NO;
    [footerV addSubview:_yaoqingImgV];
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, 50, tableView.frame.size.width-20, 40);
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = nav_bgcolor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextBtn addTarget:self action:@selector(NextButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [footerV addSubview:nextBtn];
    
    return footerV;
}

- (void)captchaWasError{
    if(_cutdownT){
        [_cutdownT invalidate];
    }
    _timeLabel.text = @"";
    _yanzhengBtn.enabled = YES;
    _yanzhengBtn.selected = NO;
    [self yuyinButtonEdit];
    [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
}

-(void)startTime{
    _secondCount--;
    _timeLabel.text = [NSString stringWithFormat:@"%ld",_secondCount];
    //_secondCount--;
    if(_secondCount==0){
        [_cutdownT invalidate];
        _yanzhengBtn.selected = NO;
        _timeLabel.text = @"";
        _yanzhengBtn.enabled = YES;
        [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


- (void)yanzhengButtonBeTouched:(UIButton *)sender{
    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:_registerPhone andVerifyType:@"1" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        if(respString){
            [[ShowMessageView shareManager] showMessage:respString];
        }else{
            [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
            //_yuyinBtn = NO;
            _yanzhengStr = [datadic objectForKey:@"verifyCode"];
            _secondCount = 120;
            [sender setTitle:@"秒后重新发送" forState:UIControlStateNormal];
            //[sender setTitleColor:nav_bgcolor forState:UIControlStateNormal];
            sender.enabled = NO;
            _cutdownT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
            [self startTime];
        }
    }];
}


- (void)yuyinButtonBeTouch:(UIButton *)sender{
    if (_sendyuyin) {
        [[ShowMessageView shareManager] showMessage:@"120秒内不能重复获取"];
    }else{
        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_registerPhone andWithType:@"107" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            if (!respString) {
                [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
                _yanzhengStr = [datadic objectForKey:@"verifyCode"];
               // [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                _sendyuyin = YES;
                [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

                 NSTimer *timer = [NSTimer timerWithTimeInterval:120 target:self selector:@selector(yuyinButtonEdit) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }else{
                [[ShowMessageView shareManager] showMessage:respString];
            }
        }];
    }
}

- (void)yuyinButtonEdit{
    _sendyuyin = NO;
    [_yuyinBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
}

//- (void)yaoqingButtonBeTouched:(id)sender{
//    if(_yaoqingShow){
//        _yaoqingShow = NO;
//        _yaoqingImgV.image = [UIImage imageNamed:@"yaoqingdown"];
//        [_titleArr removeLastObject];
//        [self.tableView beginUpdates];
//        NSIndexPath * deleteindex = [NSIndexPath indexPathForItem:3 inSection:0];
//        [self.tableView deleteRowsAtIndexPaths:@[deleteindex] withRowAnimation:UITableViewRowAnimationTop];
//        [self.tableView endUpdates];
//        
//    }else{
//        _yaoqingShow = YES;
//        _yaoqingImgV.image = [UIImage imageNamed:@"yaoqingup"];
//        [_titleArr addObject:@"邀请码(选填)"];
//        [self.tableView beginUpdates];
//        NSIndexPath * insertindex = [NSIndexPath indexPathForItem:3 inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[insertindex] withRowAnimation:UITableViewRowAnimationBottom];
//        [self.tableView endUpdates];
//    }
//}

- (void)NextButtonBeTouched:(id)sender{
    
    UITextField * yanzhengTF = (UITextField *)[self.tableView viewWithTag:1000];
    UITextField * passwordTF = (UITextField *)[self.tableView viewWithTag:1001];
    UITextField * psagainTF = (UITextField *)[self.tableView viewWithTag:1002];
    UITextField * yaoqingTF = (UITextField *)[self.tableView viewWithTag:1003];
    NSString * yaoqingStr = @"";
    if (yaoqingTF) {
        yaoqingStr = yaoqingTF.text;
    }else{
        yaoqingStr = @"";
    }
    
    if ([passwordTF.text isEqualToString:@""]) {
        [[ShowMessageView shareManager] showMessage:@"密码不能为空"];
    }else if (![[[RegularClass shareManager] isUserPassword:passwordTF.text]isEqualToString:@"yes"]){
        [[ShowMessageView shareManager] showMessage:[[RegularClass shareManager] isUserPassword:passwordTF.text]];
    }else if (![psagainTF.text isEqualToString:passwordTF.text]){
        [[ShowMessageView shareManager] showMessage:@"两次输入密码不一致"];
    }else if ([yanzhengTF.text isEqualToString:@""]){
        [[ShowMessageView shareManager] showMessage:@"验证码不能为空"];
    }else if (![[RegularClass shareManager] isTrueCaptCha:yanzhengTF.text]){
        [[ShowMessageView shareManager] showMessage:@"验证码须为6位数字"];
    }else if (![yanzhengTF.text isEqualToString:_yanzhengStr]){
        [[ShowMessageView shareManager] showMessage:@"验证码不正确,请核对或重写发送"];
    }else{
        UIButton * button = (UIButton*)sender;
        button.backgroundColor = [UIColor lightGrayColor];
        button.enabled = NO;
        [[HaiHeNetBridge sharedManager] UserregisterRequestWithUserName:_registerPhone andWithUserPassword:passwordTF.text andWithUserPhone:_registerPhone andInviteCode:yaoqingStr WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            button.backgroundColor = nav_bgcolor;
            button.enabled = YES;
            [self captchaWasError];
            if(respString){
                [[ShowMessageView shareManager] showMessage:respString];
            }else{
                
                NSArray * accArr = [SSKeychain accountsForService:@"ronglian"];
                for (int i=0; i<accArr.count; i++) {
                    NSDictionary * accDic  = accArr[i];
                    NSString * name = [accDic objectForKey:@"acct"];
                    [SSKeychain deletePasswordForService:@"ronglian" account:name];
                }
                
                [SSKeychain setPassword:passwordTF.text forService:@"ronglian" account:_registerPhone];
                    if ([[datadic objectForKey:@"userId"]isKindOfClass:[NSNull class]]) {
                        [[ShowMessageView shareManager] showMessage:@"数据错误,请重试"];
                    }else{
                        [UserLoginStatus shareManager].userid = [datadic objectForKey:@"userId"];
                        [UserLoginStatus shareManager].username = _registerPhone;
                    
                            NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
                            [userdefault setObject:_registerPhone forKey:@"phonestr"];
                            [userdefault synchronize];
                        
                        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction * sureA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
                            
                        }];
                        [alertC addAction:sureA];
                        [self presentViewController:alertC animated:YES completion:nil];
                    
//                            RegisterSuccessViewController * successVC = [[RegisterSuccessViewController alloc] init];
//                            [self.navigationController pushViewController:successVC animated:YES];
                       
                    }
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"错误000,联系开发者"];
//                }
            }
        }];

    }
    
    
//    if(![yanzhengTF.text isEqualToString:@""]){
//        if([[RegularClass shareManager] isTrueCaptCha:yanzhengTF.text]){
//            if(![passwordTF.text isEqualToString:@""]){
//                if([[RegularClass shareManager] isTrueCaptCha:yanzhengTF.text]){
//                    if([psagainTF.text isEqualToString:passwordTF.text]){
//                        if([yanzhengTF.text isEqualToString:_yanzhengStr]){
//                            UIButton * button = (UIButton*)sender;
//                            button.backgroundColor = [UIColor lightGrayColor];
//                            button.enabled = NO;
//                            [[HaiHeNetBridge sharedManager] UserregisterRequestWithUserName:_registerPhone andWithUserPassword:passwordTF.text andWithUserPhone:_registerPhone andInviteCode:yaoqingStr WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                                button.backgroundColor = nav_bgcolor;
//                                button.enabled = YES;
//                                [self captchaWasError];
//                                if(respString){
//                                    [[ShowMessageView shareManager] showMessage:respString];
//                                }else{
//                                    
//                                    NSArray * accArr = [SSKeychain accountsForService:@"haihejinrong"];
//                                    for (int i=0; i<accArr.count; i++) {
//                                        NSDictionary * accDic  = accArr[i];
//                                        NSString * name = [accDic objectForKey:@"acct"];
//                                        [SSKeychain deletePasswordForService:@"haihejinrong" account:name];
//                                    }
//                                    
//                                    if([SSKeychain setPassword:passwordTF.text forService:@"haihejinrong" account:_registerPhone]){
//                                        if ([[datadic objectForKey:@"userId"]isKindOfClass:[NSNull class]]) {
//                                            [[ShowMessageView shareManager] showMessage:@"数据错误,请重试"];
//                                        }else{
//                                            [UserLoginStatus shareManager].userid = [datadic objectForKey:@"userId"];
//                                            [UserLoginStatus shareManager].username = _registerPhone;
//                                            LLLockViewController * lockVC = [[LLLockViewController alloc] init];
//                                            lockVC.nLockViewType = LLLockViewTypeCreate;
//                                            
//                                            lockVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//                                            
//                                            [self presentViewController:lockVC animated:NO completion:^{
//                                                NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//                                                [userdefault setObject:_registerPhone forKey:@"phonestr"];
//                                                [userdefault setObject:@"1" forKey:@"haveshoushimima"];
//                                                [userdefault synchronize];
//                                    RegisterSuccessViewController * successVC = [[RegisterSuccessViewController alloc] init];
//                                                [self.navigationController pushViewController:successVC animated:YES];
//                                            }];
//                                        }
//                                    }else{
//                                        [[ShowMessageView shareManager] showMessage:@"错误000,联系开发者"];
//                                    }
//                                }
//                            }];
//                        }else{
//                            [[ShowMessageView shareManager] showMessage:@"验证码错误"];
//                            [self captchaWasError];
//                        }
//                    }else{
//                       [[ShowMessageView shareManager] showMessage:@"两次输入密码不相同"];
//                    }
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"密码格式不正确"];
//                }
//            }else{
//                [[ShowMessageView shareManager] showMessage:@"密码不能为空"];
//            }
//
//        }else{
//        [[ShowMessageView shareManager] showMessage:@"验证码格式不正确"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"验证码不能为空"];
//    }
}


@end
