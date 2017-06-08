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

@interface leftMain_Vc ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation leftMain_Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initdata];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 200, 300) style:UITableViewStylePlain];
    
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
  
    main_left_header_View *header = [[[NSBundle mainBundle]loadNibNamed:@"main_left_header_View" owner:self options:nil]firstObject];
    header.frame = CGRectMake(0, 0, 200, 100);
    
    
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_Shenhe object:nil];
    }
    if (indexPath.row == 1) {
    [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_Huankuan object:nil];
    }
    if (indexPath.row == 2) {
    [[NSNotificationCenter defaultCenter]postNotificationName:Nsnotion_SafeSet object:nil];
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
