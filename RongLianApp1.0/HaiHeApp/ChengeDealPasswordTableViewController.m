//
//  ChengeDealPasswordTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/15.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ChengeDealPasswordTableViewController.h"
#import "RightImageTableViewCell.h"
#import "SetDealPasswordTableViewController.h"
#import "HaiheHeader.h"
#import "HaiHeNetBridge.h"
#import "RegularClass.h"
#import "ShowMessageView.h"
#import "UserLoginStatus.h"

@interface ChengeDealPasswordTableViewController ()
@property (nonatomic, retain)NSArray * titleArr;
@property (nonatomic, retain)UITextField * oldpasswordTF;
@property (nonatomic, retain)UITextField * newpasswordTF;
@property (nonatomic, retain)UITextField * newpasswordagainTF;
@end

@implementation ChengeDealPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改交易密码";
    _titleArr = @[@"原交易密码",@"新交易密码",@"确认新交易密码"];
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    if ([_oldpasswordTF isFirstResponder]) {
        [_oldpasswordTF resignFirstResponder];
    }
    if ([_newpasswordTF isFirstResponder]) {
        [_newpasswordTF resignFirstResponder];
    }
    if ([_newpasswordagainTF isFirstResponder]) {
        [_newpasswordagainTF resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
    return 15;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 30;
    }else{
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0&&indexPath.row==0){
        static NSString * cellidentifi = @"chengedealpw";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
        }
        NSString * usernameStr = [UserLoginStatus shareManager].username;
        cell.textLabel.text = [NSString stringWithFormat:@"账户:%@",usernameStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * cellidenti = @"chengepw";
        RightImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
        if(!cell){
            cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
        }
        cell.titleTextfield.placeholder = _titleArr[indexPath.row+indexPath.section*2-1];
        cell.titleTextfield.secureTextEntry = YES;
        if(indexPath.section==0){
            _oldpasswordTF = cell.titleTextfield;
        }else{
            if (indexPath.row==0) {
                _newpasswordTF = cell.titleTextfield;
            }else{
                _newpasswordagainTF = cell.titleTextfield;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0){
        UIView * footerV = [[UIView alloc] init];
        UIButton * hintBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        hintBtn.frame = CGRectMake(tableView.frame.size.width-100, 0, 100, 30);
        [hintBtn setTitle:@"忘记交易密码?" forState:UIControlStateNormal];
        hintBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [hintBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        hintBtn.backgroundColor = [UIColor clearColor];
        [hintBtn addTarget:self action:@selector(ToSetDealPassword:) forControlEvents:UIControlEventTouchUpInside];
        [footerV addSubview:hintBtn];
        return footerV;
    }else{
        UIView * footerV = [[UIView alloc] init];
        UIButton * submitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, 10, tableView.frame.size.width-20, 40);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor = nav_bgcolor;
        [submitBtn addTarget:self action:@selector(submitButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.layer.cornerRadius = 3;
        submitBtn.layer.masksToBounds = YES;
        [footerV addSubview:submitBtn];

        return footerV;
    }
}

- (void)ToSetDealPassword:(id)sender{
    SetDealPasswordTableViewController * setdealVC = [[SetDealPasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    setdealVC.userid = _userid;
    setdealVC.usernameStr = _realnameStr;
    setdealVC.phoneStr = _phonenum;
    [self.navigationController pushViewController:setdealVC animated:YES];

}

- (void)submitButtonBeTouched:(id)sender{
    if (_oldpasswordTF.text.length<6) {
        [[ShowMessageView shareManager] showMessage:@"原密码不能小于6位"];
    }else if (_oldpasswordTF.text.length>20){
        [[ShowMessageView shareManager] showMessage:@"原密码不能大于20位"];
    }else if(![[[RegularClass shareManager] isUserPassword:_newpasswordTF.text]isEqualToString:@"yes"]) {
        [[ShowMessageView shareManager] showMessage:[[RegularClass shareManager] isUserPassword:_newpasswordTF.text]];
    }else if (![_newpasswordTF.text isEqualToString:_newpasswordagainTF.text]){
        [[ShowMessageView shareManager] showMessage:@"新密码两次输入不一致"];
    }else{
            [[HaiHeNetBridge sharedManager] userModifyPayPwRequestWithUserId:_userid andNewPassword:_newpasswordTF.text andOldPassword:_oldpasswordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        
                if(!respString){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
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
    
//    if ([[RegularClass shareManager] isUserPassword:_oldpasswordTF.text]) {
//        if ([[RegularClass shareManager] isUserPassword:_newpasswordTF.text]) {
//            if([_newpasswordTF.text isEqualToString:_newpasswordagainTF.text]){
//               
//                    [[HaiHeNetBridge sharedManager] userModifyPayPwRequestWithUserId:_userid andNewPassword:_newpasswordTF.text andOldPassword:_oldpasswordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                        
//                        if(!respString){
//                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
//                            // UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            }];
//                            
//                            //[alertController addAction:cancelAction];
//                            [alertController addAction:okAction];
//                            [self presentViewController:alertController animated:YES completion:nil];                        }else{
//                                [[ShowMessageView shareManager] showMessage:respString];
//                            }
//                    }];
//                }else{
//                [[ShowMessageView shareManager] showMessage:@"两次密码不匹配"];
//            }
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"密码格式不正确"];
//        }
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"原密码格式不正确"];
//    }
//

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
