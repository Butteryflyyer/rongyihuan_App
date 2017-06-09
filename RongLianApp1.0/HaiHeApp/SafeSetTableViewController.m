
//
//  SafeSetTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/9/24.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "SafeSetTableViewController.h"
#import "ChengeDealPasswordTableViewController.h"
#import "AuthNameTableViewController.h"
//#import "AboutUsViewController.h"
#import "ChengeLoginPasswordTableViewController.h"
#import "ChengePhoneTableViewController.h"
#import "SetDealPasswordTableViewController.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
#import "HaiheHeader.h"
#import "UserLoginStatus.h"
#import "SSKeychain.h"


@interface SafeSetTableViewController ()
@property (nonatomic, retain)NSArray * setArr;
@property (nonatomic, retain)NSArray * set2Arr;
@property (nonatomic, retain)NSMutableArray * detailArr;
@property (nonatomic, retain)NSString * realnameStr;
@property (nonatomic, retain)NSString * nameandidcardStr;
@property (nonatomic, retain)NSString * jiaoyimimaStr;
@property (nonatomic, retain)NSString * bankcardStr;
@property (nonatomic, retain)NSString * banknameStr;
@property (nonatomic, retain)NSString * phonenumStr;

//@property (nonatomic, retain)NSString * branchBankname;
@property (nonatomic, assign)BOOL ishaveBtn;
@end

@implementation SafeSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"安全设置";
    [self getMoreData];
//    _setArr = @[@"实名认证",@"银行卡",@"交易密码",@"指纹"];
//    _setArr = @[@"交易密码"];
    _set2Arr = @[@"修改登录密码",@"联系我们"];
    NSArray * arr = @[@"未认证，点击认证",@"未绑定，点击绑定",@"未设置，点击设置",@""];
    _detailArr = [NSMutableArray arrayWithArray:arr];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
//        case 3:
//            return 1;
//            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"safesetcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    if(indexPath.section == 1 || indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = [NSString stringWithFormat:@"账户:%@",_loginname];
            cell.textLabel.textColor = nav_bgcolor;
//            if (![_realnameStr isEqualToString:@""]) {
//                cell.textLabel.text = [NSString stringWithFormat:@"账户:%@",_realnameStr];
//            }else{
//            cell.textLabel.text = [NSString stringWithFormat:@"账户:%@",_phonenum];
//            }
        }
            break;
//        case 1:{
//            cell.textLabel.text = _setArr[indexPath.row];
//            cell.detailTextLabel.text = @"修改交易密码";
////            if (indexPath.row ==0&&![_nameandidcardStr isEqualToString:@""]) {
////                cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                cell.accessoryType = UITableViewCellAccessoryNone;
////            }
////            if (indexPath.row ==1&&![_nameandidcardStr isEqualToString:@""]) {
////                cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                cell.accessoryType = UITableViewCellAccessoryNone;
////            }
//        }
//            break;
        case 1:
            cell.textLabel.text = _set2Arr[indexPath.row];
            if(indexPath.row==1){
                cell.detailTextLabel.text = @"4000-133-770  (09:00-18:00)";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 2:{
            if (!_ishaveBtn) {
                UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                submitBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 55);
                [submitBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
                [submitBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
                submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [submitBtn addTarget:self action:@selector(submitButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:submitBtn];
                _ishaveBtn = YES;
            }
        }
            break;
            
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}

- (void)submitButtonBeTouch:(id)sender{
    
   // NSString * username = [UserLoginStatus shareManager].username;
    //[SSKeychain deletePasswordForService:@"haihejinrong" account:username];
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出当前账户" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:@"" forKey:@"Myuserid"];
        [userdefault synchronize];
        NSArray * accArr = [SSKeychain accountsForService:@"ronglian"];
        for (int i=0; i<accArr.count; i++) {
            NSDictionary * accDic  = accArr[i];
            NSString * name = [accDic objectForKey:@"acct"];
            [SSKeychain deletePasswordForService:@"ronglian" account:name];
        }
        [UserLoginStatus shareManager].userid = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
    UIAlertAction * cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertC addAction:sureA];
    [alertC addAction:cancelA];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    
//    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
//    [userdefault setObject:@"0" forKey:@"haveshoushi"];
//    [userdefault synchronize];
//    NSArray * accArr = [SSKeychain accountsForService:@"haihejinrong"];
//    for (int i=0; i<accArr.count; i++) {
//        NSDictionary * accDic  = accArr[i];
//        NSString * name = [accDic objectForKey:@"acct"];
//        [SSKeychain deletePasswordForService:@"haihejinrong" account:name];
//    }
//    [UserLoginStatus shareManager].userid = nil;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//header/footer高度；
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:
            
            break;
//        case 1:
//            switch (indexPath.row) {
////                case 0:{
////                    if ([_nameandidcardStr isEqualToString:@""]) {
////                        AuthNameTableViewController * authnameVC = [[AuthNameTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
////                        authnameVC.phoneStr = _phoneStr;
////                        authnameVC.zhuceTime = _zhuceTime;
////                        authnameVC.issetdealpwStr = _jiaoyimimaStr;
////                        [self.navigationController pushViewController:authnameVC animated:YES];
////                    }
////                }
////                    break;
////                case 1:{
////                    //没有绑卡;
////                    if(_banknameStr&&[_banknameStr isEqualToString:@""]){
////                        
////                        AuthNameTableViewController * authnameVC = [[AuthNameTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
////                        authnameVC.phoneStr = _phoneStr;
////                        authnameVC.zhuceTime = _zhuceTime;
////                        authnameVC.issetdealpwStr = _jiaoyimimaStr;
////                        [self.navigationController pushViewController:authnameVC animated:YES];
////
////                    }
////                }
////                    break;
//                case 0:{
//                    //判断是否设置交易密码;
//                    if ([_jiaoyimimaStr isEqualToString:@"已设置"]) {
//                        ChengeDealPasswordTableViewController * chengedealVC = [[ChengeDealPasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                        chengedealVC.userid = _userid;
//                        chengedealVC.realnameStr = [_realnameStr isEqualToString:@""]?_loginname:_realnameStr;
//                        chengedealVC.phonenum = _phonenum;
//                        [self.navigationController pushViewController:chengedealVC animated:YES];
//                    }else{
//                        SetDealPasswordTableViewController * setdealVC = [[SetDealPasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                         setdealVC.usernameStr = [_realnameStr isEqualToString:@""]?_loginname:_realnameStr;
//                        setdealVC.phoneStr = _phonenum;
//                        setdealVC.userid = [UserLoginStatus shareManager].userid;
//                        [self.navigationController pushViewController:setdealVC animated:YES];
//
//                    }
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            break;
        case 1:
            switch (indexPath.row) {
                case 0:{

                    ChengeLoginPasswordTableViewController * chengeloginVC = [[ChengeLoginPasswordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    chengeloginVC.userid = [UserLoginStatus shareManager].userid;
                    NSLog(@"%@",[UserLoginStatus shareManager].userid);
                    
                    [self.navigationController pushViewController:chengeloginVC animated:YES];
                }
                    break;
//                case 1:{
//                    ChengePhoneTableViewController * chengephoneVC = [[ChengePhoneTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//                    chengephoneVC.userid = [UserLoginStatus shareManager].userid;
//                    chengephoneVC.phonenumStr = _phonenumStr;
//                    chengephoneVC.phoneStr = _phonenum;
//                    [self.navigationController pushViewController:chengephoneVC animated:YES];
//                }
//                    break;
                case 1:{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨打" message:@"4000-133-770" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSString * telStr = @"tel:4000133770";
                        UIWebView * webtelV = [[UIWebView alloc] init];
                        [webtelV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telStr]]];
                        [self.view addSubview:webtelV];
                    }];
                    
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                default:
                    break;
            }

            break;
            
        default:
            break;
    }

}

- (void)getMoreData{
    [[HaiHeNetBridge sharedManager] userSecuritySafeRequestWithUserId:_userid WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        //
        if (!respString) {
            _realnameStr = [datadic objectForKey:@"zsxm"];
            _nameandidcardStr = [datadic objectForKey:@"zsxmAndSfzh"];
            _bankcardStr = [datadic objectForKey:@"cardlast"];
            _banknameStr = [datadic objectForKey:@"ssyh"];
            _jiaoyimimaStr = [datadic objectForKey:@"jjmm"];
            _phonenumStr = [datadic objectForKey:@"sjh"];
//            _loginname = [datadic objectForKey:@"dlm"];
           
            if (![_nameandidcardStr isEqualToString:@""]&&![_nameandidcardStr isKindOfClass:[NSNull class]]) {
                if (![_nameandidcardStr isKindOfClass:[NSNull class]]) {
                   [_detailArr replaceObjectAtIndex:0 withObject:_nameandidcardStr];
                }
                NSLog(@"%@",_bankcardStr);
                
                if (!_bankcardStr.length == 0) {
                  [_detailArr replaceObjectAtIndex:1 withObject:_bankcardStr];
                }

               
              
            }
            if ([_jiaoyimimaStr isEqualToString:@"已设置"]) {
                [_detailArr replaceObjectAtIndex:2 withObject:@"修改交易密码"];
            }
             [self.tableView reloadData];
        }else{
            [[ShowMessageView shareManager] showMessage:respString];
        }
        
    }];
}


@end
