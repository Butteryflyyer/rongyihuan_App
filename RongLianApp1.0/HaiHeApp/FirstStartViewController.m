//
//  FirstStartViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/6.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "FirstStartViewController.h"

@interface FirstStartViewController ()
@property (nonatomic, retain)UIPageControl * pageC;
@end

@implementation FirstStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton * dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    dissBtn.frame = CGRectMake(100, 100, 100, 50);
//    dissBtn.backgroundColor = [UIColor redColor];
//    [dissBtn addTarget:self action:@selector(dissViewC) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:dissBtn];
    [self addSomeSubViews];
    // Do any additional setup after loading the view.
}

- (void)addSomeSubViews{
    UIScrollView * scrollV = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*3, 0);
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.pagingEnabled = YES;
    scrollV.delaysContentTouches = NO;
    scrollV.delegate = self;
    //取消反弹
    scrollV.bounces = NO;
    scrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollV];
    
     NSArray * imgArr = @[@"yindao1",@"yindao2",@"yindao3"];
    //添加 pagecontrol
    _pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(100, scrollV.frame.size.height-80, scrollV.frame.size.width-200, 30)];
    _pageC.numberOfPages = imgArr.count;
    _pageC.currentPage = 0;
    [self.view addSubview:_pageC];
    
//    NSArray * imgArr = @[@"yindao1",@"yindao2",@"yindao3",@"yindao4"];
    for (int i=0; i<3; i++) {
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width*i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
        imageV.image = [UIImage imageNamed:imgArr[i]];
        [scrollV addSubview:imageV];
        if (i==2) {
            UIButton * dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dissBtn.frame = CGRectMake(scrollV.frame.size.width*2+100, scrollV.frame.size.height-150, scrollV.frame.size.width-200, 40);
            dissBtn.backgroundColor = [UIColor clearColor];
            [dissBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            dissBtn.userInteractionEnabled = YES;
            [dissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            dissBtn.layer.borderWidth = 1;
            dissBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            dissBtn.layer.cornerRadius = 20;
            dissBtn.layer.masksToBounds = YES;
            [dissBtn addTarget:self action:@selector(dissViewC) forControlEvents:UIControlEventTouchUpInside];
            [scrollV addSubview:dissBtn];
        }
//        [scrollV addSubview:imageV];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageC.currentPage = (int)scrollView.contentOffset.x/scrollView.frame.size.width;
    
}

- (void)dissViewC{
    
    NSUserDefaults * userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setBool:YES forKey:@"isfirststart1"];
    [userdefault synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
