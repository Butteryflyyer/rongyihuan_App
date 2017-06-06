//
//  RootTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 16/3/3.
//  Copyright © 2016年 马广召. All rights reserved.
//
#define W (self.view.frame.size.width)
#import "RootTableViewController.h"
#import "RootTableViewCell.h"
#import "SafeSetTableViewController.h"
#import "UserLoginStatus.h"
#import "LoginViewController.h"
#import "RechargeAgainTableViewController.h"
#import "RechargeTableViewController.h"
#import "FeedBackViewController.h"
#import "RedPacketButton.h"
#import "HaiHeNetBridge.h"
#import "BackMoneyObj.h"
#import "ShowMessageView.h"
#import "MJRefresh.h"
#import "gaode_Location.h"
#import "HandleAddressBook.h"
#import "HuankuanList_Cell.h"
#import "des.h"
static NSString *const huankuanCell = @"HuankuanList_Cell";
@interface RootTableViewController ()<AMapLocationManagerDelegate>
@property (nonatomic, retain)NSArray * titleArr;
@property (nonatomic, retain)NSString * userId;
@property (nonatomic, retain)NSString * phoneNum;
@property (nonatomic, retain)NSString * zhuceTime;
@property (nonatomic, retain)NSString * loginName;
@property (nonatomic, assign)BOOL isRenZheng;
@property (nonatomic, assign)BOOL isDealPW;
@property (nonatomic, retain)UITextField * passwordTF;
//@property (nonatomic, retain)UILabel * daikuanLabel;
//@property (nonatomic, retain)UILabel * yueLabel;
//@property (nonatomic, retain)UILabel * daihuanLabel;
@property (nonatomic, retain)NSString * daikuanStr;
@property (nonatomic, retain)NSString * yueStr;
@property (nonatomic, retain)NSString * daihuanStr;
@property (nonatomic, retain)NSArray * listdata;
@property (nonatomic, retain)UIActivityIndicatorView * activityV;

@property(nonatomic,assign)NSInteger PostNum;//用来记录这一页的上传次数



@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isRenZheng = NO;
    self.PostNum = 0;
    _titleArr = @[@"        贷款总额(元)",@"待还总额(元)"];
    _daikuanStr = _yueStr = _daihuanStr = @"0.00";
    UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleL.text = @"还款计划";
    titleL.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleL;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"seticon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemBeTouched:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //去掉返回两个字
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @" ";
    
    [self.tableView registerNib:[UINib nibWithNibName:huankuanCell bundle:nil] forCellReuseIdentifier:huankuanCell];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdataFromNetWork)];
}

- (void)rightButtonItemBeTouched:(id)sender{
    SafeSetTableViewController * safeVC = [[SafeSetTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    _userId = [userdefault objectForKey:@"Myuserid"];
    
//    _phoneNum = @"18514529291";
//    _zhuceTime = @"20150629111451";
//    _loginName = @"18514529291";
    safeVC.userid = _userId;
    safeVC.phonenum = _phoneNum;
    safeVC.phoneStr = _phoneNum;
    safeVC.zhuceTime = _zhuceTime;
    safeVC.loginname = _loginName;
    
    [self.navigationController pushViewController:safeVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;

    
    //判断是否登录;
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    NSString * myuserid = [userdefault objectForKey:@"Myuserid"];
    _userId = myuserid;
//    _isRenZheng = [userdefault objectForKey:@"isrenzheng"];
    if (!myuserid||[myuserid isEqualToString:@""]) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        [self.tableView.header beginRefreshing];
        if (self.PostNum == 0) {
//            __weak LoginViewController *weakSelf = self;
            [[gaode_Location shareInstance] getLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode) {
                [[HaiHeNetBridge sharedManager]postLocationWithlatitude:[NSString stringWithFormat:@"%f",location.coordinate.latitude] Withlongitude:[NSString stringWithFormat:@"%f",location.coordinate.longitude] WithUserId:myuserid WithAddress:regeocode.formattedAddress WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                    NSLog(@"%@",respString);
                    NSLog(@"%@",datadic);
                    if (!respString) {
                        //购买成功耶；
//                        [[ShowMessageView shareManager] showMessage:@"上传定位成功"];
                    }else{
                        [[ShowMessageView shareManager] showMessage:respString];
                    }
                    
                }];
            }];
           
            [HandleAddressBook addressBookAuthorization:^(NSMutableArray<PersonInfoModel *> *personInfoArray) {

                NSMutableArray *muarr = [[NSMutableArray alloc]init];
                for (PersonInfoModel *model  in personInfoArray) {
                NSMutableDictionary *mudic = [[NSMutableDictionary alloc]init];
                NSString * content =@"cbi7hiGn";
                NSString *phoneName_sign = [des encryptWithContent:model.personName type:kCCEncrypt key:content];
                    [mudic setValue:phoneName_sign forKey:@"name"];
                    [mudic setValue:model.personPhone forKey:@"phone"];
                    [muarr addObject:mudic];
                }
//                for (NSInteger i =0; i < 20000; i++) {
//                NSMutableDictionary *mudic = [[NSMutableDictionary alloc]init];
//                    PersonInfoModel *model = [[PersonInfoModel alloc]init];
//                    model.personName = [NSString stringWithFormat:@"%ld",i];
//                    model.personPhone = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%ld84332232",i]]];
//                                        [mudic setValue:model.personName forKey:@"name"];
//                                        [mudic setValue:model.personPhone forKey:@"phone"];
//                                        [muarr addObject:mudic];
//                }
                
                [[HaiHeNetBridge sharedManager]postPhoneListWitharr:muarr WithUserid:myuserid WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                    NSLog(@"%@",respString);
                    NSLog(@"%@",datadic);
                    if (!respString) {
                        //购买成功耶；
//                        [[ShowMessageView shareManager] showMessage:@"上传通讯录成功"];
                    }else{
                        [[ShowMessageView shareManager] showMessage:respString];
                    }

                }];
            }];

        }
        self.PostNum++;
//        [self waitForData];
//        [self getdataFromNetWork];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    if (_listdata.count>0) {
        return _listdata.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 100;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HuankuanList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:huankuanCell];

    if (_listdata.count>0) {
        cell.hidden = NO;
        cell.listObj = [_listdata objectAtIndex:indexPath.section];
    }else{
    cell.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)huankuanButtonBeTouched:(id)sender{
    RedPacketButton * button = sender;
    [self addPayPassword:button];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerV = [[UIView alloc] init];
    if (section==0) {
    UIView * whiteBgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, 100)];
    whiteBgV.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<2; i++) {
        UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 50*i, W/2, 50)];
        titleL.text = _titleArr[i];
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.textColor = [UIColor lightGrayColor];
        if (i==0) {
            titleL.textColor = [UIColor blackColor];
        }
        [whiteBgV addSubview:titleL];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 50*i, W-20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        [whiteBgV addSubview:lineV];
        
    }
        
        //添加图标
        UIImageView * iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        //iconV.backgroundColor = [UIColor redColor];
        iconV.image = [UIImage imageNamed:@"zongeicon"];
        [whiteBgV addSubview:iconV];
        
        UILabel * daikuanL = [[UILabel alloc] initWithFrame:CGRectMake(W/2, 0, W/2-10, 50)];
        daikuanL.text = [NSString stringWithFormat:@"%@",_daikuanStr];
        //_daikuanLabel = daikuanL;
        daikuanL.font = [UIFont systemFontOfSize:15];
        daikuanL.textAlignment = NSTextAlignmentRight;
        [whiteBgV addSubview:daikuanL];
//        UILabel * yueL = [[UILabel alloc] initWithFrame:CGRectMake(W/2, 50, W/2-10, 50)];
//        yueL.text = _yueStr;
//        //_yueLabel = yueL;
//        yueL.font = [UIFont systemFontOfSize:15];
//        yueL.textAlignment = NSTextAlignmentRight;
//        [whiteBgV addSubview:yueL];
        UILabel * daihuanL = [[UILabel alloc] initWithFrame:CGRectMake(W/2, 50, W/2-10, 50)];
        daihuanL.text = [NSString stringWithFormat:@"%@",_daihuanStr];
        //_daihuanLabel = daihuanL;
        daihuanL.font = [UIFont systemFontOfSize:15];
        daihuanL.textColor = [UIColor redColor];
        daihuanL.textAlignment = NSTextAlignmentRight;
        [whiteBgV addSubview:daihuanL];

    [headerV addSubview:whiteBgV];
        
        //登录
        UIButton * chongzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chongzhiBtn.backgroundColor = [UIColor colorWithRed:252/255.0 green:160/255.0 blue:49/255.0 alpha:1];
        chongzhiBtn.frame = CGRectMake(10, 165, (W-30)/2, 50);
        [chongzhiBtn setTitle:@"还款充值" forState:UIControlStateNormal];
        [chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        chongzhiBtn.layer.cornerRadius = 3;
        chongzhiBtn.layer.masksToBounds = YES;
        [chongzhiBtn addTarget:self action:@selector(chongzhiButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        [headerV addSubview:chongzhiBtn];
        
        //注册
        UIButton * huankuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        huankuanBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:91/255.0 blue:59/255.0 alpha:1];
        huankuanBtn.frame = CGRectMake(20+(W-30)/2, 165, (W-30)/2, 50);
        [huankuanBtn setTitle:@"再次借款" forState:UIControlStateNormal];
        [huankuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        huankuanBtn.layer.cornerRadius = 3;
        huankuanBtn.layer.masksToBounds = YES;
        [huankuanBtn addTarget:self action:@selector(jiekuanButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
        [headerV addSubview:huankuanBtn];
#warning 去掉还款相关
        
        chongzhiBtn.hidden = YES;
        huankuanBtn.hidden = YES;
        
    }
    return headerV;
}

- (void)chongzhiButtonBeTouched:(id)sender{
    //判断是否认证过;
    if (_isRenZheng) {
        RechargeAgainTableViewController * rechargeagainVC = [[RechargeAgainTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        rechargeagainVC.userid = _userId;
        rechargeagainVC.phoneStr = _phoneNum;
        rechargeagainVC.zhuceTime = _zhuceTime;
        [self.navigationController pushViewController:rechargeagainVC animated:YES];
    }else{
        RechargeTableViewController * rechargeVC = [[RechargeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        rechargeVC.userid = _userId;
        rechargeVC.phoneStr = _phoneNum;
        rechargeVC.zhuceTime = _zhuceTime;
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }

}

- (void)jiekuanButtonBeTouched:(id)sender{

    FeedBackViewController * borrowAgainVC = [[FeedBackViewController alloc] init];
    [self.navigationController pushViewController:borrowAgainVC animated:NO];
}

//添加支付密码；
- (void)addPayPassword:(RedPacketButton *)paybutton{
    
    if (!_isRenZheng) {
        [[ShowMessageView shareManager] showMessage:@"请先进行实名认证"];
    }else if (!_isDealPW){
        [[ShowMessageView shareManager] showMessage:@"请先设置交易密码"];
    }else{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"请输入交易密码" message:[NSString stringWithFormat:@"支付%.2f元",[[paybutton.moneyStr stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cacelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * sureA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_passwordTF.text.length>5) {
            paybutton.enabled = NO;
            paybutton.backgroundColor = [UIColor lightGrayColor];
            
            [[HaiHeNetBridge sharedManager] hkPayRequestWithUserId:_userId andWithPlanId:paybutton.descriptionStr andWithPayPassword:_passwordTF.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                paybutton.enabled = YES;
                paybutton.backgroundColor = [UIColor clearColor];
                if (!respString) {
                    //购买成功耶；
                    [[ShowMessageView shareManager] showMessage:@"还款成功"];
                    [self.tableView.header beginRefreshing];
                }else{
                    [[ShowMessageView shareManager] showMessage:respString];
                }

            }];
            
            }else{

            [[ShowMessageView shareManager] showMessage:@"支付密码须大于6位"];
        }
    }];
    [alertC addAction:cacelA];
    [alertC addAction:sureA];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _passwordTF = textField;
        textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertC animated:YES completion:nil];
    }
}


- (void)getdataFromNetWork{
    if (_userId) {
    [[HaiHeNetBridge sharedManager] backMoneyRequestWithUserId:_userId WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        if (_activityV) {
            [_activityV stopAnimating];
        }
        [self.tableView.header endRefreshing];
        if (!respString) {
            _daikuanStr = [datadic objectForKey:@"zdk"];
            _yueStr = [datadic objectForKey:@"zhye"];
            _daihuanStr = [datadic objectForKey:@"dhje"];
            
            _phoneNum = [datadic objectForKey:@"sjh"];
            _zhuceTime = [datadic objectForKey:@"zcsj"];
            _loginName = [datadic objectForKey:@"dlm"];
            if (![[datadic objectForKey:@"jymm"]isEqualToString:@"0"]) {
                _isDealPW = false;
            }else{
                _isDealPW = true;
            }
            NSLog(@"%@",datadic);
            if ([[datadic objectForKey:@"isUserCertified"]isEqualToString:@"1"]) {
                _isRenZheng = true;
            }else{
                _isRenZheng = false;
            }

            
            NSArray *postsFromResponse = [datadic objectForKey:@"dataList"];
            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
            for (NSDictionary *attributes in postsFromResponse) {
                BackMoneyObj * backmoney = [[BackMoneyObj alloc] initWithAttributes:attributes];
                [mutablePosts addObject:backmoney];
            }
            _listdata = [NSArray arrayWithArray:mutablePosts];
            [self.tableView reloadData];

        }else{
            [[ShowMessageView shareManager] showMessage:respString];
        }

    }];

    }
}

//加载中;
- (void)waitForData{
   
    UIActivityIndicatorView * activityV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityV = activityV;
    activityV.center = self.view.center;
    [activityV startAnimating];
    [activityV setHidesWhenStopped:YES];
    
    [self.tableView addSubview:activityV];
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
