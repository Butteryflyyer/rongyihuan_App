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
#import "Shenhe_Progress_Cell.h"
#import "Shenhe_Header_View.h"
#import "Main_ComponyIntoduce.h"
#import "Shenhe_Model.h"
#import "noInfo_footer_View.h"
static NSString *const CellId = @"Shenhe_Progress_Cell";
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
@property(nonatomic,strong)noInfo_footer_View *noinfo_View;

@end

@implementation Shenhe_Progress_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleL.text = @"审批进度";
    titleL.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleL;
    //判断是否登录;

    if ([UserLoginStatus shareManager].userid.length > 0) {
          [self getdataFromNetWork];
    }

      self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    // Do any additional setup after loading the view.
 

    
    [self initUI];
    [self initdata];


    
}
//__weak __typeof(self) weakSelf  = self;
//self.block = ^{
//    __strong __typeof(self) strongSelf = weakSelf;
-(void)initdata{
    self.dataSource = [[NSMutableArray alloc]init];
}
-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = _COLOR_RGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:CellId bundle:nil] forCellReuseIdentifier:CellId];
    __weak typeof(self)weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[HaiHeNetBridge sharedManager]getShenhe_progressWithUserid: [UserLoginStatus shareManager].userid WithTel:[UserLoginStatus shareManager].userTel WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            __strong typeof(self)strongSelf = weakSelf;
              [strongSelf.tableView.mj_header endRefreshing];
            
            if (!respString) {
                NSLog(@"%@",datadic);
                strongSelf.dataSource = [Shenhe_Model mj_objectArrayWithKeyValuesArray:datadic[@"list"]];
                
            }else{
                 [[ShowMessageView shareManager] showMessage:respString];
            }

            if (strongSelf.dataSource.count == 0) {
                strongSelf.noinfo_View = [[[NSBundle mainBundle]loadNibNamed:@"noInfo_footer_View" owner:self options:nil]firstObject];
                strongSelf.noinfo_View.frame = CGRectMake(0, 64, SCREEN_WIDTH, 200);
                strongSelf.noinfo_View.titlelabel.text = respString;
                [strongSelf.view addSubview:strongSelf.noinfo_View];
                
            }else{
                [strongSelf.noinfo_View removeFromSuperview];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }];
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Shenhe_Progress_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (self.dataSource.count > 0) {
     cell.shenheModel = self.dataSource[indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    Shenhe_Header_View *header_View =[[[NSBundle mainBundle]loadNibNamed:@"Shenhe_Header_View" owner:self options:nil]firstObject];
    header_View.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    
    return header_View;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return  0.1;
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
    
    
    if ([UserLoginStatus shareManager].userid.length == 0) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
    
        if ([UserLoginStatus shareManager].userid.length > 0) {
            if ([Main_Jump shareManager].postNum_location_phone == 0) {
                //            __weak LoginViewController *weakSelf = self;
                [[gaode_Location shareInstance] getLocation:^(CLLocation *location, AMapLocationReGeocode *regeocode) {
                    [[HaiHeNetBridge sharedManager]postLocationWithlatitude:[NSString stringWithFormat:@"%f",location.coordinate.latitude] Withlongitude:[NSString stringWithFormat:@"%f",location.coordinate.longitude] WithUserId:[UserLoginStatus shareManager].userid WithAddress:regeocode.formattedAddress WithSuccess:^(NSString *respString, NSDictionary *datadic) {
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
                    
                    [[HaiHeNetBridge sharedManager]postPhoneListWitharr:muarr WithUserid:[UserLoginStatus shareManager].userid WithSuccess:^(NSString *respString, NSDictionary *datadic) {
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
                [Main_Jump shareManager].postNum_location_phone = 1;
            }

            
        }
        

    }
    if ([UserLoginStatus shareManager].userid.length > 0) {
        __weak Shenhe_Progress_Vc *weakself = self;
        [[Main_ComponyIntoduce shareManager]goIntoMain:^(NSString *str) {
            if ([str integerValue]== 1|| [str integerValue] == 0) {
                
                [weakself leftBtnInit];
            }else{
                
            }
            
        } WithView:self];
        [self.tableView.mj_header beginRefreshing];
    }
   
    
}
-(void)leftBtnInit{
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setImage:[UIImage imageNamed:@"左上角-更多"] forState:UIControlStateNormal];
    leftbtn.frame = CGRectMake(0, 0, 14.5, 2.5);
    
    [leftbtn setEnlargeEdgeWithTop:10 right:2 bottom:5 left:10];
    [leftbtn addTarget:self action:@selector(slideLeft:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbarItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftbarItem;
    
}
-(void)slideLeft:(UIButton *)btn{
    
    SlideRootViewController *slideVc =(SlideRootViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [slideVc slideToLeft];
    
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
