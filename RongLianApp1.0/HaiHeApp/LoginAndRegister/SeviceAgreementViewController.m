//
//  SeviceAgreementViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/4.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "SeviceAgreementViewController.h"
#import <WebKit/WebKit.h>
@interface SeviceAgreementViewController ()
@property (nonatomic, retain)WKWebView * wkV;

@property (nonatomic, retain)UIProgressView * progressView;
@end

@implementation SeviceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"融易还服务协议";
    WKWebView * wkV = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkV = wkV;
    
    ////测试地址：http://192.168.12.196:8080/app_webservice/webservice/publicRequest?wsdl
    //http://223.202.60.29/app_webservice/webservice/publicRequest?wsdl
//    http://ryh.zyskcn.com:8092/WebService/RYH_Interface.asmx
    [wkV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ryh.zyskcn.com:8092//app/xieyi_zhuce_HK.html"]]];
    [wkV addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:wkV];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(0, 64, self.view.frame.size.width, 5);
    [self.view addSubview:_progressView];

    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == _wkV) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:_wkV.estimatedProgress animated:YES];
            
            if(_wkV.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    //    else if ([keyPath isEqualToString:@"title"])
    //    {
    //        if (object == _wkV) {
    //            self.title = _wkV.title;
    //
    //        }
    //        else
    //        {
    //            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    //
    //        }
    //    }
    else {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [self.wkV removeObserver:self forKeyPath:@"estimatedProgress"];
    //[self.wkV removeObserver:self forKeyPath:@"title"];
    
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
