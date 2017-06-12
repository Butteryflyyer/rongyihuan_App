//
//  RechargeSuccessTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/29.
//  Copyright © 2015年 马广召. All rights reserved.
//
#define W (self.view.frame.size.width)
#define H (self.view.frame.size.height)
#import "RechargeSuccessTableViewController.h"
#import "HaiheHeader.h"
#import "RechargeSuccessTableViewCell.h"

@interface RechargeSuccessTableViewController ()

@end

@implementation RechargeSuccessTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值成功";
    [self.navigationItem setHidesBackButton:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidenti = @"rechargesuccesscell";
    RechargeSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
    if (!cell) {
        cell = [[RechargeSuccessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
    }
//    cell.titleLabel1.text = @"银行卡信息";
//    cell.detailLabel1.text = @"小明银行";
//    cell.detailLabel2.text = @"1000******1234";
    
    if (indexPath.row==0) {
        cell.titleLabel1.text = @"银行卡信息";
        cell.detailLabel1.text = _banknameStr;
        cell.detailLabel2.text = [NSString stringWithFormat:@"*** **** **** %@",_bankcardStr];
    }else if (indexPath.row==1){
        cell.titleLabel1.text = @"流水号";
        cell.titleLabel2.text = @"充值金额";
        cell.detailLabel1.text = _orderStr;
        cell.detailLabel2.text = _moneyStr;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerV = [[UIView alloc] init];
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(W*3/8, 50, W/4, W/4)];
    //imgV.backgroundColor = [UIColor redColor];
    imgV.image = [UIImage imageNamed:@"success"];
    [headerV addSubview:imgV];
    
    UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, W/4+50, W, 30)];
    hintL.text = @"充值成功";
    hintL.textAlignment = NSTextAlignmentCenter;
    hintL.textColor = [UIColor grayColor];
    hintL.font = [UIFont systemFontOfSize:14];
    [headerV addSubview:hintL];
    
    return headerV;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerV = [[UIView alloc] init];
    UIButton * safeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    safeBtn.frame = CGRectMake(10, 150, W-20, 40);
    [safeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [safeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    safeBtn.backgroundColor = nav_bgcolor;
    safeBtn.layer.cornerRadius = 3;
    safeBtn.layer.masksToBounds = YES;
    [safeBtn addTarget:self action:@selector(safeButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:safeBtn];
    
//    UIButton * foundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    foundBtn.frame = CGRectMake(W/2+10, 150, W/2-20, 40);
//    //foundBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [foundBtn setTitle:@"我要投资" forState:UIControlStateNormal];
//    [foundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    foundBtn.backgroundColor = nav_bgcolor;
//    foundBtn.layer.cornerRadius = 3;
//    foundBtn.layer.masksToBounds = YES;
//    [foundBtn addTarget:self action:@selector(foundButtonBeTouched) forControlEvents:UIControlEventTouchUpInside];
//    [footerV addSubview:foundBtn];
    return footerV;

}


//- (void)foundButtonBeTouched{
//    
//    self.tabBarController.selectedIndex = 1;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)safeButtonBeTouched{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
