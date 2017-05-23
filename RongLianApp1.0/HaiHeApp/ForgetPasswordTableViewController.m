//
//  ForgetPasswordTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/16.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ForgetPasswordTableViewController.h"
#import "RightButtonTableViewCell.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "ForgetNextTableViewController.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
#import "RegularClass.h"

@interface ForgetPasswordTableViewController ()
@property (nonatomic, retain)UIButton * yanzhengBtn;
@property (nonatomic, retain)UILabel * timeLabel;
@property (assign)NSInteger secondCount;
@property (nonatomic,retain)NSTimer * cutdownT;
@property (nonatomic, retain)NSString * yanzhengStr;
//@property (nonatomic, retain)UIButton * deleteBtn;
@property (nonatomic, retain)UIButton * yuyinBtn;
@property (nonatomic, assign)BOOL sendyuyin;

@property (nonatomic, retain)NSString * phoneStr;
@end

@implementation ForgetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    _sendyuyin = NO;
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    
    UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
    if ([phhoneTF isFirstResponder]) {
        [phhoneTF resignFirstResponder];
    }
    if ([yanzhengTF isFirstResponder]) {
        [yanzhengTF resignFirstResponder];
    }
    
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
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
        static NSString * cellidentifi = @"forgetpwcell";
        RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
        if(!cell){
            cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
        }
        cell.titleTextfield.placeholder = @"请输入手机号";
        cell.titleTextfield.tag = 1000;
        //_deleteBtn = cell.deleteBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        static NSString * cellident = @"forgetpwnext";
        RightButtonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellident];
        if(!cell){
            cell = [[RightButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellident];
        }
        cell.titleTextfield.tag = 1001;
        _yanzhengBtn = cell.getcodeBtn;
        _timeLabel = cell.timeLable;
        [_yanzhengBtn addTarget:self action:@selector(yanzhengButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        cell.titleTextfield.placeholder = @"请输入验证码";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
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
    
    
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, 50, tableView.frame.size.width-20, 44);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = nav_bgcolor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextBtn addTarget:self action:@selector(NextButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius= 3;
    nextBtn.layer.masksToBounds = YES;
    [footerV addSubview:nextBtn];
    
    return footerV;
}


////验证码按钮
//- (void)captchaWasError{
//    if(_cutdownT){
//        [_cutdownT invalidate];
//    }
//    _timeLabel.text = @"";
//    _yanzhengBtn.enabled = YES;
//    _yanzhengBtn.selected = NO;
//    [self yuyinButtonEdit];
//    [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    
//}
//
//-(void)startTime{
//    _secondCount--;
//    _timeLabel.text = [NSString stringWithFormat:@"%ld",_secondCount];
//    //_secondCount--;
//    if(_secondCount==0){
//        [_cutdownT invalidate];
//        _yanzhengBtn.selected = NO;
//        _timeLabel.text = @"";
//        _yanzhengBtn.enabled = YES;
//        [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    }
//}
//
//- (void)yanzhengButtonBeTouched:(UIButton *)sender{
//    
//    UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    _phoneStr = phhoneTF.text;
//    //    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
//    if ([[RegularClass shareManager] isTelePhoneNumber:phhoneTF.text]) {
//        phhoneTF.enabled = NO;
//        
//        [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:phhoneTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//            phhoneTF.enabled = YES;
//            if (respString) {
//                [[ShowMessageView shareManager] showMessage:respString];
//            }else{
//                if ([[datadic objectForKey:@"isExist"]isEqualToString:@"001"]) {
////                    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:phhoneTF.text andVerifyType:@"8" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
////                        if(respString){
////                            [[ShowMessageView shareManager] showMessage:respString];
////                        }else{
////                            _yuyinBtn = NO;
////                            _yanzhengStr = [datadic objectForKey:@"verifyCode"];
////                            _secondCount = 120;
////                            [sender setTitle:@"秒后重新发送" forState:UIControlStateNormal];
////                            //[sender setTitleColor:nav_bgcolor forState:UIControlStateNormal];
////                            sender.enabled = NO;
////                            _cutdownT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
////                            [self startTime];
////                        }
////                    }];
//                    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:phhoneTF.text andVerifyType:@"8" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                        if(respString){
//                            [[ShowMessageView shareManager] showMessage:respString];
//                        }else{
//                            [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                            //_yuyinBtn = NO;
//                            _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                            _secondCount = 120;
//                            [sender setTitle:@"秒后重新发送" forState:UIControlStateNormal];
//                            //[sender setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//                            sender.enabled = NO;
//                            _cutdownT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
//                            [self startTime];
//                        }
//                    }];
//                    
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"手机号不存在"];
//                }
//            }
//        }];
//        
//        }else{
//        [[ShowMessageView shareManager] showMessage:@"手机号格式不正确,须位11位数字"];
//    }
//}
//
//
////语音验证码;
//- (void)yuyinButtonBeTouch:(id)sender{
//    if (_yuyinBtn) {
//        [[ShowMessageView shareManager] showMessage:@"120秒内不可重复获取验证码"];
//    }else{
//    UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    _phoneStr = phhoneTF.text;
//    phhoneTF.enabled = NO;
//
//        if ([[RegularClass shareManager] isTelePhoneNumber:phhoneTF.text]) {
//            [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:phhoneTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                phhoneTF.enabled = YES;
//                if (respString) {
//                    [[ShowMessageView shareManager] showMessage:respString];
//                    //return @"1";
//                }else{
//                    if ([[datadic objectForKey:@"isExist"]isEqualToString:@"001"]) {
////                        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:phhoneTF.text andWithType:@"6" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
////                            if (!respString) {
////                                [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
////                                _yanzhengStr = [datadic objectForKey:@"verifyCode"];
////                                _yuyinBtn = NO;
////                                [NSTimer timerWithTimeInterval:120 target:self selector:@selector(yuyinButtonEdit) userInfo:nil repeats:NO];
////                            }else{
////                                [[ShowMessageView shareManager] showMessage:respString];
////                            }
////                        }];
//                        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:phhoneTF.text andWithType:@"6" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                            if (!respString) {
//                                [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                                _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                                // [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//                                _sendyuyin = YES;
//                                [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                                
//                                NSTimer *timer = [NSTimer timerWithTimeInterval:120 target:self selector:@selector(yuyinButtonEdit) userInfo:nil repeats:NO];
//                                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//                            }else{
//                                [[ShowMessageView shareManager] showMessage:respString];
//                            }
//                        }];
//                        
//                    }else{
//                        [[ShowMessageView shareManager] showMessage:@"手机号不存在"];
//                    }
//                }
//            }];
//            
//            }else{
//            [[ShowMessageView shareManager] showMessage:@"手机号格式不正确,须位11位数字"];
//        }
//    }
//}
//
//- (void)yuyinButtonEdit{
//    _yuyinBtn.enabled = NO;
//    [_yuyinBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//}
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
        UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
        _phoneStr = phhoneTF.text;
        //phhoneTF.enabled = NO;
    if (![[RegularClass shareManager] isTelePhoneNumber:phhoneTF.text]) {
        [[ShowMessageView shareManager] showMessage:@"手机号须为11位数字"];
    }else{
        //判断手机号存在与否;
        [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:_phoneStr WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            if(respString){
                [[ShowMessageView shareManager] showMessage:respString];
            }else{
                if([[datadic objectForKey:@"isExist"] isEqualToString:@"001"]){
                    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:phhoneTF.text andVerifyType:@"108" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                        if(respString){
                            [[ShowMessageView shareManager] showMessage:respString];
                        }else{
                            _phoneStr = phhoneTF.text;
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

                }else{
                    [[ShowMessageView shareManager] showMessage:@"该号码不存在"];
                }
            }
        }];

        
//        [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:phhoneTF.text andVerifyType:@"8" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//            if(respString){
//                [[ShowMessageView shareManager] showMessage:respString];
//            }else{
//                _phoneStr = phhoneTF.text;
//                [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                //_yuyinBtn = NO;
//                _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                _secondCount = 120;
//                [sender setTitle:@"秒后重新发送" forState:UIControlStateNormal];
//                //[sender setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//                sender.enabled = NO;
//                _cutdownT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
//                [self startTime];
//            }
//        }];
    }
}


- (void)yuyinButtonBeTouch:(UIButton *)sender{
    UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
    _phoneStr = phhoneTF.text;
    //phhoneTF.enabled = NO;
    if (_sendyuyin) {
        [[ShowMessageView shareManager] showMessage:@"120秒内不能重复获取"];
    }else{
        if (![[RegularClass shareManager] isTelePhoneNumber:_phoneStr]){
            [[ShowMessageView shareManager] showMessage:@"手机号须为11位数字"];
        }else{
            //判断手机号存在与否;
            [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:_phoneStr WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                if(respString){
                    [[ShowMessageView shareManager] showMessage:respString];
                }else{
                    if([[datadic objectForKey:@"isExist"] isEqualToString:@"001"]){
                        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_phoneStr andWithType:@"106" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                            if (!respString) {
                                _phoneStr = phhoneTF.text;
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

                    }else{
                        [[ShowMessageView shareManager] showMessage:@"该号码不存在"];
                    }
                }
            }];
            
            
//            [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_phoneStr andWithType:@"6" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                if (!respString) {
//                    _phoneStr = phhoneTF.text;
//                    [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                    _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                    // [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//                    _sendyuyin = YES;
//                    [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                    
//                    NSTimer *timer = [NSTimer timerWithTimeInterval:120 target:self selector:@selector(yuyinButtonEdit) userInfo:nil repeats:NO];
//                    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//                }else{
//                    [[ShowMessageView shareManager] showMessage:respString];
//                }
//            }];
        }
    }
}

- (void)yuyinButtonEdit{
    _sendyuyin = NO;
    [_yuyinBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
}



//下一步;
- (void)NextButtonBeTouched:(id)sender{
    
    UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
    [self captchaWasError];
    if ([[RegularClass shareManager] isTelePhoneNumber:phhoneTF.text]) {
        if (![[RegularClass shareManager] isTrueCaptCha:yanzhengTF.text]) {
            [[ShowMessageView shareManager] showMessage:@"验证码须为6位数字"];
        }else if (![phhoneTF.text isEqualToString:_phoneStr]){
            [[ShowMessageView shareManager] showMessage:@"手机号已修改,请重新发送验证码"];
        }else{
        if ([yanzhengTF.text isEqualToString:_yanzhengStr]) {
            ForgetNextTableViewController * newphoneVC = [[ForgetNextTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            newphoneVC.phoneStr = phhoneTF.text;
            [self.navigationController pushViewController:newphoneVC animated:YES];
        }else{
            [[ShowMessageView shareManager] showMessage:@"验证码不正确,请核对或重写发送验证码"];
        }
        }
    }else{
        [[ShowMessageView shareManager] showMessage:@"手机号格式不正确"];
    }
    
}


@end
