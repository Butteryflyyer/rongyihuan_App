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
#import "ComponyIntroduce_View.h"

@interface Shenhe_Progress_Vc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain)NSString * userId;
@property(nonatomic,assign)NSInteger PostNum;//用来记录这一页的上传次数


@property (nonatomic, retain)NSString * phoneNum;
@property (nonatomic, retain)NSString * zhuceTime;
@property (nonatomic, retain)NSString * loginName;
@property (nonatomic, assign)BOOL isRenZheng;
@property (nonatomic, assign)BOOL isDealPW;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,retain)NSMutableArray *dataSource;
@end

@implementation Shenhe_Progress_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleL.text = @"审批进度";
    titleL.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleL;
    //判断是否登录;
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    NSString * myuserid = [userdefault objectForKey:@"Myuserid"];
    _userId = myuserid;

    [self getdataFromNetWork];
    [self getCompanyIntroduce];

      self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    // Do any additional setup after loading the view.
 
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setTitle:@"测滑" forState:UIControlStateNormal];
    leftbtn.frame = CGRectMake(0, 0, 50, 20);
    UIBarButtonItem *leftbarItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftbarItem;
    
    [[Main_Jump shareManager] addNsnotionWithView:self];
    
    [self initUI];
    [self initdata];
}
-(void)initdata{
    self.dataSource = [[NSMutableArray alloc]init];
}
-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 200, 300) style:UITableViewStylePlain];
    self.tableView.backgroundColor = _COLOR_RGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"main_left_Cell" bundle:nil] forCellReuseIdentifier:@"main_left_Cell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark -- 获取公司说明
-(void)getCompanyIntroduce{
    if (_userId) {
        __weak Shenhe_Progress_Vc *weakself = self;
      [[HaiHeNetBridge sharedManager] getCompanyIntorduceWithUserid:_userId WithSuccess:^(NSString *respString, NSDictionary *datadic) {
          if (!respString) {
              NSLog(@"%@",datadic);
//              NSString *Introduce = datadic[@"SoftwareIntroduce"];
            NSString *introduce = @"监考老师打了肯定是拉快疯了会计法大数据路口的发生了空间进度反馈拉数据库";
            [weakself addTishi:introduce];
              
          }else{
              [[ShowMessageView shareManager] showMessage:respString];
          }
      }];
    }
}
-(void)addTishi:(NSString *)introduce{
    UIView *introduce_Back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    introduce_Back.backgroundColor = [UIColor clearColor];
    
    CGFloat introduce_Height = [Rongyihuan_Tools heigtOfLabelForFromString:introduce fontSizeandLabelWidth:190 andFontSize:12];
    
    ComponyIntroduce_View *componyView = [[[NSBundle mainBundle]loadNibNamed:@"ComponyIntroduce_View" owner:self options:nil]firstObject];
    componyView.ComponyDetail_Label.text =introduce;
    
    componyView.frame = CGRectMake(40, 40, 240, introduce_Height+110);
    
    componyView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    [introduce_Back addSubview:componyView];
    [[UIApplication sharedApplication].keyWindow addSubview:introduce_Back];

}
#pragma mark --获取用户信息
- (void)getdataFromNetWork{
    if (_userId) {
        [[HaiHeNetBridge sharedManager] backMoneyRequestWithUserId:_userId WithSuccess:^(NSString *respString, NSDictionary *datadic) {

            if (!respString) {

                
                _phoneNum = [datadic objectForKey:@"sjh"];
                _zhuceTime = [datadic objectForKey:@"zcsj"];
                _loginName = [datadic objectForKey:@"dlm"];
                NSLog(@"%@,%@",_phoneNum,_loginName);
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
