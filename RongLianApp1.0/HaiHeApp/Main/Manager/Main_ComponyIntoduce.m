//
//  Main_ComponyIntoduce.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/10.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Main_ComponyIntoduce.h"
#import "ComponyIntroduce_View.h"
#import "Main_Jump.h"
@interface Main_ComponyIntoduce ()

@end

@implementation Main_ComponyIntoduce
+(id)shareManager{
    static Main_ComponyIntoduce *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[Main_ComponyIntoduce alloc]init];
        shareManager.Compony_Num = 0;
    });
    return shareManager;
}

-(void)goIntoMain:(void(^)(NSString *str))block WithView:(UIViewController *)vc{
    /**
     EnterPage = 1 首页为审核进度页面。EnterPage = 0  没有申请显示公司介绍弹框。 EnterPage = 2 还款计划表
     
     */

    
    __weak typeof(self) weakself = self;
    [[HaiHeNetBridge sharedManager]goIntoSomePageWithUserid:[UserLoginStatus shareManager].userid WithTel:[UserLoginStatus shareManager].userTel WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        if (respString) {
            
        }else{
            NSLog(@"%@",datadic);
            if ([datadic[@"EnterPage"] integerValue]==2) {
                block(@"2");
//                       RootTableViewController *root_main = [[RootTableViewController alloc]init];
//                [[Main_Jump shareManager] addNsnotionWithView:root_main];
            }else if ([datadic[@"EnterPage"] integerValue]==0){
                if ([vc isKindOfClass:[Shenhe_Progress_Vc class]]) {
                    [weakself getCompanyIntroduce];
                }
                   block(@"0");
//                  Shenhe_Progress_Vc *shenhe_main = [[Shenhe_Progress_Vc alloc]init];
//                 [[Main_Jump shareManager] addNsnotionWithView:shenhe_main];
            }else if ([datadic[@"EnterPage"] integerValue] == 1){
                 block(@"1");
//                  Shenhe_Progress_Vc *shenhe_main = [[Shenhe_Progress_Vc alloc]init];
////                [[Main_Jump shareManager] addNsnotionWithView:shenhe_main];
            }
        }
    }];
}
#pragma mark -- 获取公司说明
-(void)getCompanyIntroduce{
    
    if ([UserLoginStatus shareManager].userid.length > 0) {
        
        __weak Main_ComponyIntoduce *weakself = self;
        [[HaiHeNetBridge sharedManager] getCompanyIntorduceWithUserid:[UserLoginStatus shareManager].userid WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            __strong typeof(self)strongSelf = weakself;
            if (!respString) {
               
                NSString *Introduce = datadic[@"SoftwareIntroduce"];
                if (strongSelf.Compony_Num == 0) {
                    [strongSelf addTishi:Introduce];
                    strongSelf.Compony_Num = 1;
                }
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

@end
