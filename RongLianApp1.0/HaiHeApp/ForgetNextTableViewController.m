//
//  ForgetNextTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/16.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ForgetNextTableViewController.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
#import "RegularClass.h"


@interface ForgetNextTableViewController ()
@property (nonatomic, retain)NSArray * titleArr;
@end

@implementation ForgetNextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置密码";
    _titleArr = @[@"新密码",@"确认新密码"];
    // Uncomment the following line to preserve selection between presentations.
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    UITextField * passwrdTF = (UITextField *)[self.view viewWithTag:1000];
    UITextField * againpasswrdTF = (UITextField *)[self.view viewWithTag:1001];
    if ([passwrdTF isFirstResponder]) {
        [passwrdTF resignFirstResponder];
    }
    if ([againpasswrdTF isFirstResponder]) {
        [againpasswrdTF resignFirstResponder];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidentifi = @"foregetnextcell";
    RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifi];
    if(!cell){
        cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifi];
        
    }
    cell.titleTextfield.placeholder = _titleArr[indexPath.row];
    cell.titleTextfield.secureTextEntry = YES;
    cell.titleTextfield.tag = 1000+indexPath.row;
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerV = [[UIView alloc] init];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, 10, tableView.frame.size.width-20, 44);
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    submitBtn.backgroundColor = nav_bgcolor;
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:submitBtn];
    
    return footerV;
    
}

- (void)submitButtonBeTouch:(id)sender{
    UITextField * passwrdTF = (UITextField *)[self.view viewWithTag:1000];
    UITextField * againpasswrdTF = (UITextField *)[self.view viewWithTag:1001];
    
    if (![[[RegularClass shareManager] isUserPassword:passwrdTF.text]isEqualToString:@"yes"]) {
        [[ShowMessageView shareManager] showMessage:[[RegularClass shareManager] isUserPassword:passwrdTF.text]];
    }else{
        if ([passwrdTF.text isEqualToString:againpasswrdTF.text]) {
            [[HaiHeNetBridge sharedManager] userSetPasswordRequestWithUserPhone:_phoneStr andWithNewPassword:passwrdTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                if (!respString) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[ShowMessageView shareManager] showMessage:@"密码修改成功"];
                }else{
                    [[ShowMessageView shareManager] showMessage:respString];
                }
            }];
        }else{
            [[ShowMessageView shareManager] showMessage:@"两次密码输入不一致"];
        }
    }
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
