//
//  RegisterTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/16.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "HaiheHeader.h"
#import "RightImageTableViewCell.h"
#import "RegisterNextTableViewController.h"
#import "HaiHeNetBridge.h"
#import "RegularClass.h"
#import "ShowMessageView.h"
#import "SeviceAgreementViewController.h"

@interface RegisterTableViewController ()
@property (nonatomic, retain)UITextField * phoneTF;
@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    if ([_phoneTF isFirstResponder]) {
        [_phoneTF resignFirstResponder];
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
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidentifi = @"bankcardcell";
    RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
    if(!cell){
        cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifi];
    }
    cell.titleTextfield.placeholder = @"请输入手机号";
    _phoneTF = cell.titleTextfield;
    cell.titleTextfield.keyboardType = UIKeyboardTypeNumberPad;
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerV = [[UIView alloc] init];
    
    UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 40)];
    hintL.text = @"点击\"下一步\"代表您已阅读并同意";
    //hintL.numberOfLines = ;
    //hintL.backgroundColor = [UIColor redColor];
    hintL.font = [UIFont systemFontOfSize:12];
    hintL.textColor = [UIColor grayColor];
    [footerV addSubview:hintL];
    
    UIButton * seviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seviceBtn.frame = CGRectMake(190, 0, 120, 40);
    //seviceBtn.backgroundColor = [UIColor greenColor];
    [seviceBtn setTitle:@"《融联创投服务协议》" forState:UIControlStateNormal];
    [seviceBtn setTitleColor:nav_bgcolor  forState:UIControlStateNormal];
    seviceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [seviceBtn addTarget:self action:@selector(seviceButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:seviceBtn];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 50, tableView.frame.size.width-20, 44);
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = nav_bgcolor;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [submitBtn addTarget:self action:@selector(SubmitButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    [footerV addSubview:submitBtn];
    
    return footerV;
    
}

- (void)seviceButtonBeTouch:(id)sender{
    SeviceAgreementViewController * seviceVC = [[SeviceAgreementViewController alloc] init];
    [self.navigationController pushViewController:seviceVC animated:YES];
    
}

- (void)SubmitButtonBeTouched:(UIButton *)sender{
     NSString * phoneStr = [_phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([phoneStr isEqualToString:@""]) {
        [[ShowMessageView shareManager] showMessage:@"手机号不能为空"];
    }else{
    if([[RegularClass shareManager] isTelePhoneNumber:phoneStr]){
        [[HaiHeNetBridge sharedManager] vertifyUserphoneRequestWithUserPhone:phoneStr WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            if(respString){
                [[ShowMessageView shareManager] showMessage:respString];
            }else{
                if([[datadic objectForKey:@"isExist"] isEqualToString:@"002"]){
                    [[ShowMessageView shareManager] showMessage:@"验证码已发送"];
                    RegisterNextTableViewController * registernextVC = [[RegisterNextTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    registernextVC.registerPhone = phoneStr;
                    [self.navigationController pushViewController:registernextVC animated:YES];
                }else{
                    [[ShowMessageView shareManager] showMessage:@"该号码已注册"];
                }
            }
        }];
    }else{
        [[ShowMessageView shareManager] showMessage:@"手机号须为11位数字"];
    }
    }
    
}

@end
