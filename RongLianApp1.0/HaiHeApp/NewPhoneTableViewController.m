//
//  NewPhoneTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/15.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "NewPhoneTableViewController.h"
#import "RightButtonTableViewCell.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "HaiHeNetBridge.h"
#import "RegularClass.h"
#import "ShowMessageView.h"

@interface NewPhoneTableViewController ()
@property (nonatomic, retain)UITextField * newphoneTF;

@property (nonatomic, retain)UIButton * yanzhengBtn;
@property (nonatomic, retain)UILabel * timeLabel;
@property (assign)NSInteger secondCount;
@property (nonatomic,retain)NSTimer * cutdownT;
@property (nonatomic, retain)NSString * yanzhengStr;

@property (nonatomic, retain)UIButton * yuyinBtn;
@property (nonatomic, assign)BOOL sendyuyin;

@property (nonatomic, retain)NSString * phoneStr;
@end

@implementation NewPhoneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证新手机号";
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    _sendyuyin = NO;
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    if ([_newphoneTF isFirstResponder]) {
        [_newphoneTF resignFirstResponder];
    }
    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
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
        static NSString * cellidentifi = @"chengephonecell";
        RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
        if(!cell){
            cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
        }
        cell.titleTextfield.placeholder = @"输入新手机号";
        _newphoneTF = cell.titleTextfield;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        static NSString * cellident = @"chengephone";
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
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = nav_bgcolor;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextBtn addTarget:self action:@selector(NextButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [footerV addSubview:nextBtn];
    
    return footerV;
}


//验证码按钮
//- (void)captchaWasError{
//    if(_cutdownT){
//        [_cutdownT invalidate];
//    }
//    UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    phhoneTF.enabled = YES;
//    //_deleteBtn.hidden = NO;
//    _timeLabel.text = @"";
//    _yanzhengBtn.enabled = YES;
//    _yanzhengBtn.selected = NO;
//    _yuyinBtn = YES;
//    [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    
//}
//
//-(void)startTime{
//    _secondCount--;
//    _timeLabel.text = [NSString stringWithFormat:@"%ld",_secondCount];
//    //_secondCount--;
//    if(_secondCount==0){
//        [self captchaWasError];
//    }
//}
//
//
//- (void)yanzhengButtonBeTouched:(UIButton *)sender{
//    
//    // UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    //    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
//    if ([[RegularClass shareManager] isTelePhoneNumber:_newphoneTF.text]) {
//        _newphoneTF.enabled = NO;
//        
//        [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:_newphoneTF.text andVerifyType:@"5" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//            if(respString){
//                [[ShowMessageView shareManager] showMessage:respString];
//            }else{
//                [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                _yuyinBtn = NO;
//                _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                _secondCount = 120;
//                [sender setTitle:@"秒后重新发送" forState:UIControlStateNormal];
//                //[sender setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//                sender.enabled = NO;
//                _cutdownT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
//                [self startTime];
//            }
//        }];
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"手机格式不正确"];
//    }
//    
//}
//
//
////语音验证码;
//- (void)yuyinButtonBeTouch:(id)sender{
//    // UITextField * phhoneTF = (UITextField *)[self.view viewWithTag:1000];
//    if (_yuyinBtn) {
//        if ([[RegularClass shareManager] isTelePhoneNumber:_newphoneTF.text]) {
//            [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_newphoneTF.text andWithType:@"4" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
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
//        [[ShowMessageView shareManager] showMessage:@"120秒内不能重复点击"];
//    }
//}
//
//- (void)yuyinButtonEdit{
//    _yuyinBtn = YES;
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
    if (![[RegularClass shareManager] isTelePhoneNumber:_newphoneTF.text]) {
        [[ShowMessageView shareManager] showMessage:@"手机号须为11位数字"];
    }else{
        //验证手机号存在
        [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:_newphoneTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            if(respString){
                [[ShowMessageView shareManager] showMessage:respString];
            }else{
                if([[datadic objectForKey:@"isExist"] isEqualToString:@"002"]){
                    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:_newphoneTF.text andVerifyType:@"5" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                        if(respString){
                            [[ShowMessageView shareManager] showMessage:respString];
                        }else{
                            _phoneStr = _newphoneTF.text;
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
                    [[ShowMessageView shareManager] showMessage:@"该号码已存在"];
                }
            }
        }];
        
        
//    [[HaiHeNetBridge sharedManager] sendSmsModelRequestWithUserPhone:_newphoneTF.text andVerifyType:@"5" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//        if(respString){
//            [[ShowMessageView shareManager] showMessage:respString];
//        }else{
//            _phoneStr = _newphoneTF.text;
//            [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//            //_yuyinBtn = NO;
//            _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//            _secondCount = 120;
//            [sender setTitle:@"秒后重新发送" forState:UIControlStateNormal];
//            //[sender setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//            sender.enabled = NO;
//            _cutdownT = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
//            [self startTime];
//        }
//    }];
    }
}


- (void)yuyinButtonBeTouch:(UIButton *)sender{
    if (_sendyuyin) {
        [[ShowMessageView shareManager] showMessage:@"120秒内不能重复获取"];
    }else{
        if (![[RegularClass shareManager] isTelePhoneNumber:_newphoneTF.text]){
            [[ShowMessageView shareManager] showMessage:@"手机号须为11位数字"];
        }else{
            //验证手机号存在与否
            [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:_newphoneTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                if(respString){
                    [[ShowMessageView shareManager] showMessage:respString];
                }else{
                    if([[datadic objectForKey:@"isExist"] isEqualToString:@"002"]){
                        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_newphoneTF.text andWithType:@"104" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                            if (!respString) {
                                _phoneStr = _newphoneTF.text;
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
                        [[ShowMessageView shareManager] showMessage:@"该号码已存在"];
                    }
                }
            }];
            
//        [[HaiHeNetBridge sharedManager] sendAudioSmsRequestWithUserPhone:_newphoneTF.text andWithType:@"4" WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//            if (!respString) {
//                _phoneStr = _newphoneTF.text;
//                [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
//                _yanzhengStr = [datadic objectForKey:@"verifyCode"];
//                // [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//                _sendyuyin = YES;
//                [_yuyinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                
//                NSTimer *timer = [NSTimer timerWithTimeInterval:120 target:self selector:@selector(yuyinButtonEdit) userInfo:nil repeats:NO];
//                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//            }else{
//                [[ShowMessageView shareManager] showMessage:respString];
//            }
//        }];
        }
    }
}

- (void)yuyinButtonEdit{
    _sendyuyin = NO;
    [_yuyinBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
}

- (void)NextButtonBeTouched:(id)sender{
    [self captchaWasError];
    UITextField * yanzhengTF = (UITextField *)[self.view viewWithTag:1001];
    if (![[RegularClass shareManager] isTelePhoneNumber:_newphoneTF.text]) {
        [[ShowMessageView shareManager] showMessage:@"手机号须为11位数字"];
    }else if (![[RegularClass shareManager] isTrueCaptCha:yanzhengTF.text]){
        [[ShowMessageView shareManager] showMessage:@"验证码须为6位数字"];
    }else if (![yanzhengTF.text isEqualToString:_yanzhengStr]){
        [[ShowMessageView shareManager] showMessage:@"验证码不正确,请核对或重写发送"];
    }else if (![_newphoneTF.text isEqualToString:_phoneStr]){
        [[ShowMessageView shareManager] showMessage:@"手机号有变化请请求新验证码"];
    }else{
        
        UIButton * subBtn = (UIButton *)sender;
        subBtn.enabled = NO;
        subBtn.backgroundColor = [UIColor lightGrayColor];
        [[HaiHeNetBridge sharedManager] userEditTelRequestWithUserId:_userid andNewPhonenum:_newphoneTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            subBtn.enabled = YES;
            subBtn.backgroundColor = nav_bgcolor;
            if(!respString){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
                            // UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }];
            
                            //[alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];                        }else{
            [[ShowMessageView shareManager] showMessage:respString];
                            }
                }];

    }
    
//    if([[RegularClass shareManager] isTelePhoneNumber:_newphoneTF.text]){
//        if ([[RegularClass shareManager] isTrueCaptCha:yanzhengTF.text]&&[yanzhengTF.text isEqualToString:_yanzhengStr]) {
//        [[HaiHeNetBridge sharedManager] userEditTelRequestWithUserId:_userid andNewPhonenum:_newphoneTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//            if(!respString){
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
//                // UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }];
//                
//                //[alertController addAction:cancelAction];
//                [alertController addAction:okAction];
//                [self presentViewController:alertController animated:YES completion:nil];                        }else{
//                    [[ShowMessageView shareManager] showMessage:respString];
//                }
//        }];
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"验证码不正确"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"手机号格式不正确"];
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
