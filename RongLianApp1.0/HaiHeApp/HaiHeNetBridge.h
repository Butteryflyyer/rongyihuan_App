//
//  HaiHeNetBridge.h
//  SignNameTest
//
//  Created by 马广召 on 15/8/5.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SignBlock)(NSDictionary * dic,NSString * errorString);
typedef void (^ReturnBlock)(NSString * respString,NSDictionary * datadic) ;
@interface HaiHeNetBridge : NSObject
+ (HaiHeNetBridge *)sharedManager;



//- (void)vertifyUsernameWithUserName:(NSString *)username WithSuccess:(SignBlock)signData;
//判断手机接口;
- (void)vertifyUsernameRequestWithUserName:(NSString *)username WithSuccess:(ReturnBlock)returnData;
- (void)vertifyUserphoneRequestWithUserPhone:(NSString *)userphone WithSuccess:(ReturnBlock)returnData;
//注册接口;
- (void)UserregisterRequestWithUserName:(NSString *)username andWithUserPassword:(NSString *)password andWithUserPhone:(NSString *)userphone andInviteCode:(NSString *)invitecode WithSuccess:(ReturnBlock)returnData;
//登录接口;
- (void)userLoginRequestWithUserName:(NSString *)username andWithPassword:(NSString *)password WithSuccess:(ReturnBlock)returnData;
//请求非借款人的短信；
-(void)sendSmsModelRequestWithUserPhone:(NSString *)userphone andVerifyType:(NSString *)verifytype WithSuccess:(ReturnBlock)returnData;
//借款人请求短信；
//- (void)sendSmsModelRequestWithBorrowName:(NSString *)borrowname andWithBorrowPhone:(NSString *)borrowphone andWithUserPhone:(NSString *)userphone andBorrowArea:(NSString *)borrowarea andVerifyType:(NSString *)verifytype WithSuccess:(ReturnBlock)returnData;


//充值明细;
- (void)userRechargeRecordRequestWithUserId:(NSString *)userid andWithStartPage:(NSString *)startpage andWithPageSize:(NSString *)pagesize andWithRechargeStatus:(NSString *)rechargestatus WithSuccess:(ReturnBlock)returnData;

//安全设置;
- (void)userSecuritySafeRequestWithUserId:(NSString *)userid WithSuccess:(ReturnBlock)returnData;
//修改登录密码;
- (void)userEditPasswordRequestWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword andOldPassword:(NSString *)oldpassword WithSuccess:(ReturnBlock)returnData;
//修改交易密码;
- (void)userModifyPayPwRequestWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword andOldPassword:(NSString *)oldpassword WithSuccess:(ReturnBlock)returnData;
//设置交易密码;
- (void)userEditPayPwRequestWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword WithSuccess:(ReturnBlock)returnData;
//修改手机号;
- (void)userEditTelRequestWithUserId:(NSString *)userid andNewPhonenum:(NSString *)newphonenum WithSuccess:(ReturnBlock)returnData;

//充值和绑卡;
- (void)rechargeRzAndCzRequestWithUserId:(NSString *)userid andWithMoney:(NSString *)money andWithIdCard:(NSString *)idcard andWithRealname:(NSString *)realname andWithBankCard:(NSString *)bankcard andWithOrderid:(NSString *)orderid WithSuccess:(ReturnBlock)returnData;
//进入用户充值;
- (void)userIntoRechargeRequestWithUserId:(NSString *)userid WithSuccess:(ReturnBlock)returnData;
//语音验证码;
- (void)sendAudioSmsRequestWithUserPhone:(NSString *)phonenum andWithType:(NSString *)type WithSuccess:(ReturnBlock)returnData;
//设置登录密码;
- (void)userSetPasswordRequestWithUserPhone:(NSString *)phonenum andWithNewPassword:(NSString *)password WithSuccess:(ReturnBlock)returnData;
//意见反馈;
- (void)userFeedbackRequestWithUserId:(NSString *)userid andWithContact:(NSString *)contact andWithContent:(NSString *)content WithSuccess:(ReturnBlock)returnData;


//还款列表;
- (void)backMoneyRequestWithUserId:(NSString *)userid WithSuccess:(ReturnBlock)returnData;

//继续借款
- (void)hkLoanAgainRequestWithUserId:(NSString *)userid andWithliveCity:(NSString *)city andWithmonthMoney:(NSString *)moneymonth andWithborrowMoney:(NSString *)money andWithSex:(NSString *)sex andWithrealName:(NSString *)name andWithphoneNum:(NSString *)phonenum WithSuccess:(ReturnBlock)returnData;

//还款
- (void)hkPayRequestWithUserId:(NSString *)userid andWithPlanId:(NSString *)planid andWithPayPassword:(NSString *)paypassword WithSuccess:(ReturnBlock)returnData;
//上传通讯录
-(void)postPhoneListWitharr:(NSMutableArray *)phonelist WithUserid:(NSString *)userid WithSuccess:(ReturnBlock)retureBlock;
//上传定位地址
-(void)postLocationWithlatitude:(NSString *)latitude Withlongitude:(NSString *)longitude WithUserId:(NSString *)userid WithAddress:(NSString *)address WithSuccess:(ReturnBlock)retureBlock;
//获取公司说明
-(void)getCompanyIntorduceWithUserid:(NSString *)userid WithSuccess:(ReturnBlock)retureBlock;
@end
