//
//  Rongyihuan_Tools+Alert.h
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Rongyihuan_Tools.h"

@interface Rongyihuan_Tools (Alert)
/**
 *  提示 alertviewcontroller
 *
 *  @param title  <#title description#>
 *  @param detial <#detial description#>
 *  @param view   <#view description#>
 */

+(void)ShowTishiAlertControllerWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view;
/**
 *  提示alertviewcontroller 点击我知道了 返回前一页
 *
 *  @param title  <#title description#>
 *  @param detial <#detial description#>
 *  @param view   <#view description#>
 */
+(void)ShowTishiAlertControllerIKnowCanDoSomeThingWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view;
/**
 *  点击我知道了，进行相应的操作
 *
 *  @param title     <#title description#>
 *  @param detial    <#detial description#>
 *  @param view      <#view description#>
 *  @param KnowBlcok <#KnowBlcok description#>
 */
+(void)ShowTishiAlertControllerIKnowCanDoSomeThingWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view WithBlock:(void(^)(id data))KnowBlcok;
//  对于alerviewcontroller的封装。  block

+(void)ShowTishiAlertControllerWithTitle:(NSString *)title AndDetial:(NSString *)detial WithView:(UIViewController *)view WithCancelTitle:(NSString *)Canceltitle WithMakeSureTitle:(NSString *)MakeSureTitle  CancelActionBlock:(void(^)(id data))CancelBlock MakSureActionBlock:(void(^)(id data))MakeSureBlock;
@end
