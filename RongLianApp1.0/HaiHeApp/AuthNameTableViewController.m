
//
//  AuthNameTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/15.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "AuthNameTableViewController.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "BindingCardTableViewController.h"
#import "ShowMessageView.h"
#import "RegularClass.h"

@interface AuthNameTableViewController ()
@property (nonatomic, retain)NSArray * titleArr;
@property (nonatomic, retain)UITextField * realnameTF;
@property (nonatomic, retain)UITextField * idcardTF;
@end

@implementation AuthNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    _titleArr = @[@"您的真实姓名",@"您的身份证号"];
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    if ([_realnameTF isFirstResponder]) {
        [_realnameTF resignFirstResponder];
    }
    if ([_idcardTF isFirstResponder]) {
        [_idcardTF resignFirstResponder];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (RightImageTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidentifi = @"authnamecell";
    RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
    if(!cell){
        cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
    
    }
    cell.titleTextfield.placeholder = _titleArr[indexPath.row];
    if (indexPath.row==0) {
        _realnameTF = cell.titleTextfield;
    }else if (indexPath.row==1){
        _idcardTF = cell.titleTextfield;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerV = [[UIView alloc] init];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 10, tableView.frame.size.width-20, 44);
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = nav_bgcolor;
    [submitBtn addTarget:self action:@selector(SubmitButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    [footerV addSubview:submitBtn];
    
    return footerV;
    
}

- (void)SubmitButtonBeTouched:(UIButton *)sender{
    
    NSString * realnameStr = [_realnameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * idcardStr = [_idcardTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([realnameStr isEqualToString:@""]) {
        [[ShowMessageView shareManager] showMessage:@"真实姓名不能为空"];
    }else if ([idcardStr isEqualToString:@""]){
        [[ShowMessageView shareManager] showMessage:@"身份证号不能为空"];
    }else{
        BindingCardTableViewController * bindingVC = [[BindingCardTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        bindingVC.fromH5 = _fromH5;
        bindingVC.realnameStr = realnameStr;
        bindingVC.idcardStr = idcardStr;
        bindingVC.zhuceTime = _zhuceTime;
        bindingVC.phoneStr = _phoneStr;
        bindingVC.issetdealpwStr = _issetdealpwStr;
        [self.navigationController pushViewController:bindingVC animated:YES];
    }
    
//    if (_realnameTF.text) {
//        if ([[RegularClass shareManager] isIdCard:_idcardTF.text]) {
//            BindingCardTableViewController * bindingVC = [[BindingCardTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//            bindingVC.realnameStr = _realnameTF.text;
//            bindingVC.idcardStr = _idcardTF.text;
//            bindingVC.zhuceTime = _zhuceTime;
//            bindingVC.phoneStr = _phoneStr;
//            bindingVC.issetdealpwStr = _issetdealpwStr;
//            [self.navigationController pushViewController:bindingVC animated:YES];
//
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"身份证号格式不正确"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"真实姓名不能为空"];
//}
}


@end
