//
//  ViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/9/24.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSomeSubViews];
    UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleL.text = @"账户中心";
    titleL.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleL;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonItemBeTouched:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
  
    
}

- (void)rightButtonItemBeTouched:(id)sender{

}

- (void)addSomeSubViews{
    UIButton * redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.frame = CGRectMake(20, 100, 50, 50);
    redBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:redBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
