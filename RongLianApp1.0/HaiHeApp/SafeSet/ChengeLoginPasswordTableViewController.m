//
//  ChengeLoginPasswordTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/15.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ChengeLoginPasswordTableViewController.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
#import "RegularClass.h"

@interface ChengeLoginPasswordTableViewController ()
@property (nonatomic,retain)NSArray * titleArr;
@property (nonatomic, retain)UITextField * oldpasswordTF;
@property (nonatomic, retain)UITextField * newpasswordTF;
@property (nonatomic, retain)UITextField * newpasswordagainTF;
@end

@implementation ChengeLoginPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改登录密码";
    _titleArr = @[@"原密码",@"新密码",@"确认新密码"];
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SlideRootViewController *slideVc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    slideVc.panGesture.enabled = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    SlideRootViewController *slideVc = (SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    slideVc.panGesture.enabled = YES;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidentifi = @"chengelogincell";
    RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
    if(!cell){
        cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
    
    }
    cell.titleTextfield.placeholder = _titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:
            _oldpasswordTF = cell.titleTextfield;
            _oldpasswordTF.secureTextEntry = YES;
            break;
        case 1:
            _newpasswordTF = cell.titleTextfield;
            _newpasswordTF.secureTextEntry = YES;
            break;

        case 2:
            _newpasswordagainTF = cell.titleTextfield;
            _newpasswordagainTF.secureTextEntry = YES;
            break;

            
        default:
            break;
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerV = [[UIView alloc] init];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 10, tableView.frame.size.width-20, 44);
    [submitBtn setTitle:@"修改" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    submitBtn.backgroundColor = nav_bgcolor;
    [submitBtn addTarget:self action:@selector(submitButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    [footerV addSubview:submitBtn];
    
    return footerV;

}

- (void)submitButtonBeTouch:(id)sender{
    if (_oldpasswordTF.text.length<6) {
        [[ShowMessageView shareManager] showMessage:@"原密码不能小于6位"];
    }else if (_oldpasswordTF.text.length>20){
        [[ShowMessageView shareManager] showMessage:@"原密码不能大于20位"];
    }else if(![[[RegularClass shareManager] isUserPassword:_newpasswordTF.text]isEqualToString:@"yes"]) {
        [[ShowMessageView shareManager] showMessage:[[RegularClass shareManager] isUserPassword:_newpasswordTF.text]];
    }else if (![_newpasswordTF.text isEqualToString:_newpasswordagainTF.text]){
        [[ShowMessageView shareManager] showMessage:@"新密码两次输入不一致"];
    }else{
        [[HaiHeNetBridge sharedManager] userEditPasswordRequestWithUserId:_userid andNewPassword:_newpasswordTF.text andOldPassword:_oldpasswordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            
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
    
//    
//    
//    if ([[RegularClass shareManager] isUserPassword:_oldpasswordTF.text]) {
//        if ([[RegularClass shareManager] isUserPassword:_newpasswordTF.text]) {
//            if([_newpasswordTF.text isEqualToString:_newpasswordagainTF.text]){
//                
//                [[HaiHeNetBridge sharedManager] userEditPasswordRequestWithUserId:_userid andNewPassword:_newpasswordTF.text andOldPassword:_oldpasswordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                    
//                    if(!respString){
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
//                        // UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            [self.navigationController popToRootViewControllerAnimated:YES];
//                        }];
//                        
//                        //[alertController addAction:cancelAction];
//                        [alertController addAction:okAction];
//                        [self presentViewController:alertController animated:YES completion:nil];                        }else{
//                            [[ShowMessageView shareManager] showMessage:respString];
//                        }
//                }];
//            }else{
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
