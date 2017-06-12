//
//  RechargeRecordTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/14.
//  Copyright © 2015年 马广召. All rights reserved.
//
#define W (self.view.frame.size.width)
#define H (self.view.frame.size.height)
#import "RechargeRecordTableViewController.h"
#import "FourLabelsTableViewCell.h"
#import "MJRefresh.h"
#import "ShowMessageView.h"
#import "RechargeObj.h"
#import "NowifiView.h"

@interface RechargeRecordTableViewController ()
@property (nonatomic, retain)UIView * selectMenuView;
@property (nonatomic, retain)NSArray * titleArr;
@property (nonatomic, retain)NSMutableArray * dataArr;
//@property (nonatomic, retain)UIView * selectMenuView;
@property (nonatomic, retain)NSString * currentpage;
@property (nonatomic, retain)NSString * selectType;
@property (nonatomic, retain)NSArray * buttonArr;
@property (nonatomic, retain)UIButton * selectBtn;
@property (nonatomic, retain)NSString * selectTitle;

@property (nonatomic ,retain)UIImageView * bgimgV;
@property (nonatomic ,retain)UILabel * bgTitleL;
@property (nonatomic, retain)NowifiView * nonetV;


@end

@implementation RechargeRecordTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _currentpage = @"1";
    _selectType = @"";
    _dataArr = [NSMutableArray array];
    self.navigationItem.title = @"充值记录";
    _titleArr = @[@"创建时间",@"充值金额(元)",@"流水号",@"充值结果"];
    _buttonArr = @[@"   全部",@"   未支付",@"   已支付"];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    [self.tableView.header beginRefreshing];
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.footer = footer;
    
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
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


- (FourLabelsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidentifier = @"withdrawrecordcell";
    FourLabelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if(!cell){
        cell = [[FourLabelsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    cell.rechargeobject = _dataArr[indexPath.row];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        UIView * titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
        
        UILabel * selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleV.frame.size.width/4, titleV.frame.size.height/2)];
        if (_selectTitle) {
            selectLabel.text = _selectTitle;
        }else{
            selectLabel.text = @"   全部";
        }

        selectLabel.textAlignment = NSTextAlignmentLeft;
        selectLabel.font = [UIFont systemFontOfSize:15];
        [titleV addSubview:selectLabel];
        
        UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn = selectBtn;
        selectBtn.frame = CGRectMake(titleV.frame.size.width/4*3, 0, titleV.frame.size.width/4, titleV.frame.size.height/2);
        [selectBtn addTarget:self action:@selector(showSelectMenu:) forControlEvents:UIControlEventTouchUpInside];
        //selectBtn.backgroundColor = [UIColor redColor];
        [selectBtn setImage:[UIImage imageNamed:@"xiala_arrow"] forState:UIControlStateNormal];
//        [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 40, 10, 35)];
        if ([UIScreen mainScreen].bounds.size.height==667) {
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 40, 10, 35)];
            
        }else if ([UIScreen mainScreen].bounds.size.height>667){
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 45, 10, 40)];
        }else{
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 35, 10, 30)];
        }

        [titleV addSubview:selectBtn];
        
        
        for (int i=0; i<4; i++) {
            UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(titleV.frame.size.width/4*i, titleV.frame.size.height/2, titleV.frame.size.width/4, titleV.frame.size.height/2)];
            titleL.text = _titleArr[i];
            titleL.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.font = [UIFont systemFontOfSize:14];
            [titleV addSubview:titleL];
        }
        return titleV;
    }
    return 0;
}

- (void)showSelectMenu:(UIButton *)sender{
    if(!_selectMenuView){
        [sender setImage:[UIImage imageNamed:@"shangla_arrow"] forState:UIControlStateNormal];
        _selectMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.tableView.frame.size.width, self.tableView.frame.size.height-100)];
        //_selectMenuView.alpha = 0.8;
        UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
        //lefttopTap.delegate = self;
        [lefttopTap setNumberOfTapsRequired:1];
        [lefttopTap setNumberOfTouchesRequired:1];
        [_selectMenuView addGestureRecognizer:lefttopTap];
        
        _selectMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.tableView addSubview:_selectMenuView];
        
        for (int i=0; i<3; i++) {
            UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            menuBtn.tag = 1000+i;
            menuBtn.backgroundColor = [UIColor whiteColor];
            menuBtn.frame = CGRectMake(0,44*i , self.tableView.frame.size.width, 44);
            [menuBtn setTitle:_buttonArr[i] forState:UIControlStateNormal];
            [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [menuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 10, 10)];
            menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [menuBtn addTarget:self action:@selector(menuButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
            [_selectMenuView addSubview:menuBtn];
        }
        
        //        _selectMenuView.backgroundColor = [UIColor lightGrayColor];
        //        [self.tableView addSubview:_selectMenuView];
    }else{
        
        if(_selectMenuView.hidden){
            [sender setImage:[UIImage imageNamed:@"shangla_arrow"] forState:UIControlStateNormal];
            _selectMenuView.hidden = NO;
        }else{
            [sender setImage:[UIImage imageNamed:@"xiala_arrow"] forState:UIControlStateNormal];
            _selectMenuView.hidden = YES;
        }
    }
}

- (void)selectViewBeTap{
    _selectMenuView.hidden = YES;
     [_selectBtn setImage:[UIImage imageNamed:@"xiala_arrow"] forState:UIControlStateNormal];
}

- (void)menuButtonBeTouched:(UIButton * )sender{
    _selectMenuView.hidden = YES;
     [_selectBtn setImage:[UIImage imageNamed:@"xiala_arrow"] forState:UIControlStateNormal];
    _selectTitle = sender.titleLabel.text;
    switch (sender.tag) {
        case 1000:{
          //  [_dataArr removeAllObjects];
            _selectType = @"";
            _currentpage = @"1";
            [self.tableView.header beginRefreshing];
            //[self refreshData];
        }
            break;
        case 1001:{
          //  [_dataArr removeAllObjects];
            _selectType = @"0";
            _currentpage = @"1";
            [self.tableView.header beginRefreshing];
            //[self refreshData];
        }
            break;
        case 1002:{
           // [_dataArr removeAllObjects];
            _selectType = @"1";
            _currentpage = @"1";
            [self.tableView.header beginRefreshing];
        }
            break;
        default:
            break;
    }
}


- (void)getMoreData{
    [RechargeObj globalTimelineWithDrawRecordWithUserId:_userid andWithStartPage:_currentpage andWithPresentStatus:_selectType andWithBlock:^(NSArray *invests, NSString *errorStr, NSString *currentPage) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (!errorStr) {
            if ([_currentpage isEqualToString:@"1"]) {
                [_dataArr removeAllObjects];
            }
            _currentpage = [NSString stringWithFormat:@"%d",[currentPage intValue]+1];
            [_dataArr addObjectsFromArray:invests];
            if (_nonetV) {
                _nonetV.hidden = YES;
            }
            if (_dataArr.count==0) {
                if (!_bgimgV) {
                    [self addBackgroundImage];
                }
                _bgimgV.hidden = NO;
                _bgTitleL.hidden = NO;
            }else{
                if (_bgimgV) {
                    _bgimgV.hidden = YES;
                    _bgTitleL.hidden = YES;
                }
            }

            [self.tableView reloadData];
        }else{
            [[ShowMessageView shareManager] showMessage:errorStr];
            if (_dataArr.count==0) {
                if (_bgimgV&&!_bgimgV.hidden) {
                    _bgimgV.hidden = YES;
                    _bgTitleL.hidden = YES;
                }
                if (_nonetV) {
                    _nonetV.hidden = NO;
                }else{
                    _nonetV = [[NowifiView alloc] initWithImage:[UIImage imageNamed:@"nowifi"]];
                    _nonetV.center = self.view.center;
                    //[self.view addSubview:_nonetV];
                    [self.tableView insertSubview:_nonetV atIndex:0];
                }
            }else{
                if (_nonetV) {
                    _nonetV.hidden = YES;
                }
            }
        }
    }];
}


//没有数据；
- (void)addBackgroundImage{
    if (_nonetV) {
        _nonetV.hidden = YES;
    }
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(W/3, H/3, W/3, W/2)];
    imageV.image = [UIImage imageNamed:@"investbg"];
    _bgimgV = imageV;
    //[self.view addSubview:imageV];
    [self.tableView insertSubview:imageV atIndex:0];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, H/3+W/2, W, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无记录";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:17];
    _bgTitleL = label;
    //[self.view addSubview:label];
    [self.tableView insertSubview:label atIndex:0];
    
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
