//
//  SetDealPasswordTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/15.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "SetDealPasswordTableViewController.h"
#import "RightButtonTableViewCell.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "HaiHeNetBridge.h"
#import "RegularClass.h"
#import "ShowMessageView.h"
#import "UserLoginStatus.h"

@interface SetDealPasswordTableViewController ()
@property (nonatomic, retain)NSArray * titleArr;
@property (nonatomic, retain)UITextField * passwordTF;
@property (nonatomic, retain)UITextField * passwordAgainTF;

//验证码；
@property (nonatomic, retain)UIButton * yanzhengBtn;
@property (nonatomic, retain)UILabel * timeLabel;
@property (assign)NSInteger secondCount;
@property (nonatomic,retain)NSTimer * cutdownT;
@property (nonatomic, retain)NSString * yanzhengStr;

@property (nonatomic, retain)UIButton * yuyinBtn;
@property (nonatomic, assign)BOOL sendyuyin;

@end

@implementation SetDealPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"输入交易密码",@"确认交易密码"];
    self.navigationItem.title = @"设置交易密码";
    _sendyuyin = NO;
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    if ([_passwordTF isFirstResponder]) {
        [_passwordTF resignFirstResponder];
    }
    if ([_passwordAgainTF isFirstResponder]) {
        [_passwordAgainTF resignFirstResponder];
    }
    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:2000];
    if ([yanzhengTF isFirstResponder]) {
        [yanzhengTF resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0){
    static NSString * cellidenti = @"setdealtitle";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
        if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
        }
        NSString * usernameStr = [UserLoginStatus shareManager].username;
        cell.textLabel.text = [NSString stringWithFormat:@"账户:%@",usernameStr];
        //cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row==3){
        static NSString * cellidenti = @"setdealbutton";
        RightButtonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
        if(!cell){
            cell = [[RightButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
        }
        cell.titleTextfield.placeholder = @"验证码";
        cell.titleTextfield.tag = 2000;
        _yanzhengBtn = cell.getcodeBtn;
        _timeLabel = cell.timeLable;
        [_yanzhengBtn addTarget:self action:@selector(yanzhengButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        static NSString * cellidenti = @"setdealimage";
        RightImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
        if(!cell){
            cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
        }
        cell.titleTextfield.placeholder = _titleArr[indexPath.row-1];
        cell.titleTextfield.secureTextEntry = YES;
        if(indexPath.row == 1){
            _passwordTF = cell.titleTextfield;
        }else{
            _passwordAgainTF = cell.titleTextfield;
        }
        //cell.textLabel.text = @"小明";
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

    
        UIButton * submitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, 50, tableView.frame.size.width-20, 40);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = nav_bgcolor;
        [submitBtn addTarget:self action:@selector(ToSetDealPassword:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
        [footerV addSubview:submitBtn];
        
        return footerV;
    
}

//验证码按钮
//- (void)captchaWasError{
//    if(_cutdownT){
//        [_cutdownT invalidate];
//    }
//    _timeLabel.text = @"";
//    _yanzhengBtn.enabled = YES;
//    _yanzhengBtn.selected = NO;
//    [self yuyinButtonEdit];
//    [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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
//    // UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    //    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
//   // if ([[RegularClass shareManager] isTelePhoneNumber:_phoneStr]) {
//        
//        [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:_phoneStr andVerifyType:@"3" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//            if(respString){
//                [[ShowMessageView shareManager] showMessage:respString];
//            }else{
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
////    }else{
////        [[ShowMessageView shareManager] showMessage:@"手机格式不正确"];
////    }
//}
//
////语音验证码;
//- (void)yuyinButtonBeTouch:(id)sender{
//   // UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    if (_sendyuyin) {
//        if ([[RegularClass shareManager] isTelePhoneNumber:_phoneStr]) {
//            [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_phoneStr andWithType:@"2" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                if (!respString) {
//                    [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                    _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                    _yuyinBtn = NO;
//                    [NSTimer timerWithTimeInterval:120 target:self selector:@selector(yuyinButtonEdit) userInfo:nil repeats:NO];
//                }else{
//                    [[ShowMessageView shareManager] showMessage:respString];
//                }
//            }];
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"手机号不正确,请重试"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"120秒内不能重复获取验证码"];
//    }
//}
//
//- (void)yuyinButtonEdit{
//    _sendyuyin = NO;
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
    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:_phoneStr andVerifyType:@"3" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
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
        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_phoneStr andWithType:@"102" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
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


- (void)ToSetDealPassword:(id)sender{
    
    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:2000];
    [self captchaWasError];
    
    if (![[[RegularClass shareManager] isUserPassword:_passwordTF.text]isEqualToString:@"yes"]) {
        [[ShowMessageView shareManager] showMessage:[[RegularClass shareManager] isUserPassword:_passwordTF.text]];
    }else if (![_passwordTF.text isEqualToString:_passwordAgainTF.text]){
        [[ShowMessageView shareManager] showMessage:@"两次输入的密码不一致"];
    }else if (![[RegularClass shareManager] isTrueCaptCha:_yanzhengStr]){
        [[ShowMessageView shareManager] showMessage:@"验证码须为6位数字"];
    }else if (![yanzhengTF.text isEqualToString:_yanzhengStr]){
        [[ShowMessageView shareManager] showMessage:@"验证码不正确,请核对或重写发送"];
    }else{
        [[HaiHeNetBridge sharedManager] userEditPayPwRequestWithUserId:_userid andNewPassword:_passwordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            
                if(!respString){
                    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
                    [userdefault setObject:@"yes" forKey:@"issetdealpw"];
                    [userdefault synchronize];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
                                       // UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (_fromH5) {
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        }else{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                                        }];
            
                                        //[alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];                        }else{
                        [[ShowMessageView shareManager] showMessage:respString];
                                    }
                    }];

    }
    
    
//    if (![_passwordTF.text isEqualToString:@""]) {
//        if ([[RegularClass shareManager] isUserPassword:_passwordTF.text]) {
//            if([_passwordTF.text isEqualToString:_passwordAgainTF.text]){
//                if([[RegularClass shareManager] isTrueCaptCha:_yanzhengStr]&&[yanzhengTF.text isEqualToString:_yanzhengStr]){
//                    [[HaiHeNetBridge sharedManager] userEditPayPwRequestWithUserId:_userid andNewPassword:_passwordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//
//                        if(!respString){
//                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
//                           // UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            }];
//                            
//                            //[alertController addAction:cancelAction];
//                            [alertController addAction:okAction];
//                            [self presentViewController:alertController animated:YES completion:nil];                        }else{
//                            [[ShowMessageView shareManager] showMessage:respString];
//                        }
//                    }];
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"验证码不正确"];
//                }
//            }else{
//                [[ShowMessageView shareManager] showMessage:@"两次密码不匹配"];
//            }
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"密码格式不正确"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"密码不能为空"];
//    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
