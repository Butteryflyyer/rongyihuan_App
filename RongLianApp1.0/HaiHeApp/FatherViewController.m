//
//  FatherViewController.m
//  HaiHeFinance
//
//  Created by 马广召 on 15/9/14.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import "FatherViewController.h"
#import "HaiheHeader.h"
@interface FatherViewController ()

@end

@implementation FatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = _COLOR_RGB(0xf5f5f5);
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @" ";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden =NO;
    self.tabBarController.tabBar.hidden = NO;
    
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
