//
//  Rongyihuan_Tools+Alert.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Rongyihuan_Tools+Alert.h"

@implementation Rongyihuan_Tools (Alert)
/**
 *  提示 alertviewcontroller
 *
 *  @param title  <#title description#>
 *  @param detial <#detial description#>
 *  @param view   <#view description#>
 */

+(void)ShowTishiAlertControllerWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view{
    
    
    UIAlertAction *BackHomePage = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detial preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:BackHomePage];
    
    
    [view presentViewController:alertController animated:YES completion:nil];
    
    
    
}
/**
 *  提示alertviewcontroller 点击我知道了 返回前一页
 *
 *  @param title  <#title description#>
 *  @param detial <#detial description#>
 *  @param view   <#view description#>
 */
+(void)ShowTishiAlertControllerIKnowCanDoSomeThingWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view{
    
    
    UIAlertAction *BackHomePage = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [view.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detial preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:BackHomePage];
    
    
    [view presentViewController:alertController animated:YES completion:nil];
    
    
    
}
/**
 *  点击我知道了，进行相应的操作
 *
 *  @param title     <#title description#>
 *  @param detial    <#detial description#>
 *  @param view      <#view description#>
 *  @param KnowBlcok <#KnowBlcok description#>
 */
+(void)ShowTishiAlertControllerIKnowCanDoSomeThingWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view WithBlock:(void(^)(id data))KnowBlcok{
    
    
    UIAlertAction *BackHomePage = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        KnowBlcok(@"Back");
        
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detial preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:BackHomePage];
    
    
    [view presentViewController:alertController animated:YES completion:nil];
    
    
    
}
//  对于alerviewcontroller的封装。  block

+(void)ShowTishiAlertControllerWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view WithCancelTitle:(NSString *)Canceltitle WithMakeSureTitle:(NSString *)MakeSureTitle  CancelActionBlock:(void(^)(id data))CancelBlock MakSureActionBlock:(void(^)(id data))MakeSureBlock{
    
    
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:Canceltitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CancelBlock(@"cancel");
        
        
    }];
    
    UIAlertAction *MakeSure = [UIAlertAction actionWithTitle:MakeSureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MakeSureBlock(@"makesure");
        
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detial preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:Cancel];
    [alertController addAction:MakeSure];
    
    [view presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}


@end
