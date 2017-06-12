//
//  RootNavigationController.m
//  HaiHeApp
//
//  Created by 马广召 on 16/3/3.
//  Copyright © 2016年 马广召. All rights reserved.
//

#import "RootNavigationController.h"
#import "FirstStartViewController.h"
//#import "RootTableViewController.h"
@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:177/255.0 green:25/255.0 blue:25/255.0 alpha:1];
//    self.navigationController.navigationBar.translucent = YES;//    Bar的模糊效果，默认为YES
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
     self.navigationController.navigationBar.backItem.hidesBackButton = YES;
;
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults * userdefualt = [NSUserDefaults standardUserDefaults];
    if (![userdefualt objectForKey:@"isfirststart1"]) {
        FirstStartViewController * firstVC = [[FirstStartViewController alloc] init];
        [self presentViewController:firstVC animated:YES completion:nil];
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
