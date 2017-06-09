//
//  HaiHeNetBridge.m
//  SignNameTest
//
//  Created by 马广召 on 15/8/5.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import "HaiHeNetBridge.h"
#import "HaiHeNetworking.h"
#import "DESObject.h"
#import "Utility.h"

#import "DESEncryptFile.h"
#import "RSAEncryptor.h"
#import "Base64.h"
#import "Base64Util.h"
#define VERSION @"10"
#define PHONETYPE @"002"
#define PRONAME @"rl"
#import "des.h"
@implementation HaiHeNetBridge
//单例;
+ (HaiHeNetBridge *)sharedManager{
    static HaiHeNetBridge * bridgeManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        bridgeManagerInstance = [[self alloc] init];
    });
    return bridgeManagerInstance;
}

//验证用户名接口;
#pragma mark 验证用户名接口
- (void)vertifyUsernameWithUserName:(NSString *)username WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"VerifyUsername";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,username,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userName\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,username,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)vertifyUsernameRequestWithUserName:(NSString *)username WithSuccess:(ReturnBlock)returnData{

    [self vertifyUsernameWithUserName:username WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
        if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"respCodeDesc"]&&[dic objectForKey:@"userName"]&&[dic objectForKey:@"isExist"]){
            NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userName"],[dic objectForKey:@"isExist"]];
            //验证签名；
//            RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//            BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
            BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
            
            if(isTrue){
                //验证签名成功；
                if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                    returnData(nil,dic);
                }else{
                    returnData([dic objectForKey:@"respCodeDesc"],nil);
                }
                
            }else{
                //验证签名失败；
                returnData(@"验证签名失败",nil);
            }
        }else{
            returnData(dic[@"respCodeDesc"],nil);
        }
        }
    }];
}
#pragma mark 验证手机号接口;
- (void)vertifyUserphoneWithUserPhone:(NSString *)userphone WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"VerifyUserTel";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userphone,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
//    
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userTel\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userphone,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)vertifyUserphoneRequestWithUserPhone:(NSString *)userphone WithSuccess:(ReturnBlock)returnData{
    
    [self vertifyUserphoneWithUserPhone:userphone WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
        if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"respCodeDesc"]&&[dic objectForKey:@"userTel"]&&[dic objectForKey:@"isExist"]){
            NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userTel"],[dic objectForKey:@"isExist"]];
            //验证签名；
//            RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//            BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];

             BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
            if(isTrue){
                //验证签名成功；
                if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                    returnData(nil,dic);
                }else{
                    returnData([dic objectForKey:@"respCodeDesc"],nil);
                }
                
            }else{
                //验证签名失败；
                returnData(@"验证签名失败",nil);
            }
        }else{
            returnData(dic[@"respCodeDesc"],nil);
        }
        }
    }];
}

//对密码进行RSA加密;
#pragma mark 用户注册接口;
- (void)UserregisterWithUserName:(NSString *)username andWithUserPassword:(NSString *)password andWithUserPhone:(NSString *)userphone andInviteCode:(NSString *)invitecode WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserRegister";
    //对password加密；
   // NSString * desStr = [Utility encryptStr:password];
   // desStr = [Utility encodeBase64WithString:desStr];
   // NSString * enStr = [Utility decryptStr:desStr];
//    NSString * userPassword = [DESObject md5:desStr];
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * userpasswordStr = [rsa rsaEncryptString:password];
    
    NSString *userpasswordStr = [DESEncryptFile md5Str:password];
    
    NSLog(@"%@",userpasswordStr);
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",VERSION,methodStr,username,userpasswordStr,userphone,PHONETYPE,invitecode];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userName\":\"%@\",\"loginPassword\":\"%@\",\"userTel\":\"%@\",\"phoneType\":\"%@\",\"inviteCode\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,username,userpasswordStr,userphone,PHONETYPE,invitecode,signStr];
    
    
    
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)UserregisterRequestWithUserName:(NSString *)username andWithUserPassword:(NSString *)password andWithUserPhone:(NSString *)userphone andInviteCode:(NSString *)invitecode WithSuccess:(ReturnBlock)returnData{
    
    [self UserregisterWithUserName:username andWithUserPassword:password andWithUserPhone:userphone andInviteCode:invitecode WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
        if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userName"]&&[dic objectForKey:@"userId"]){
            NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userName"],[dic objectForKey:@"userId"]];
            //验证签名；
//            RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//            BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
      BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
            if(isTrue){
                //验证签名成功；
                if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                    returnData(nil,dic);
                }else{
                    returnData([dic objectForKey:@"respCodeDesc"],nil);
                }
                
            }else{
                //验证签名失败；
                returnData(@"验证签名失败",nil);
            }
        }else{
            returnData(dic[@"respCodeDesc"],nil);
        }}
    }];
}

//对密码进行RSA加密;
#pragma mark 用户登陆接口;
- (void)userLoginWithUserName:(NSString *)username andWithPassword:(NSString *)password WithSuccess:(SignBlock)signData{
    //格式化处理数据；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
    
    NSString * methodStr = @"UserLogin";
    
//    NSString * rsapassword = [rsa rsaEncryptString:password];
    
//    NSString *Despassword = [Base64codeFunc base64StringFromText:password];
    NSString *Despassword = [DESEncryptFile md5Str:password];
    
    NSLog(@"%@",Despassword);
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,username,PHONETYPE];
    
    NSLog(@"%@",Message);
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    

    //IOS 自带DES加密 Begin
    //  NSString *key = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC+7HQ8XX82rJunwkI35Z4zAJs9yfA/jRvutU1gQrAKEXLYr0HdqwIsVuljVrFDaLXOxIoxgEvIVSXrwfGmqFQwL5dajCzuGpWW2a+lm+hEv+ekxHr0RuhdiqXPGiKucQQadiaFpBrjQN/DmsReXfE5xukhIu7dIkPt81tKQHH8QIDAQAB";//[[NSBundle mainBundle] bundleIdentifier];
    NSString * content =@"cbi7hiGn";

    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"projectFlag\":\"%@\", \"messageType\":\"%@\",\"userName\":\"%@\",\"loginPassword\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,PRONAME,methodStr,username,Despassword,PHONETYPE,signStr];
    NSLog(@"%@",sendMessage);
    
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}

- (void)userLoginRequestWithUserName:(NSString *)username andWithPassword:(NSString *)password WithSuccess:(ReturnBlock)returnData{
    
    [self userLoginWithUserName:username andWithPassword:password WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]&&[dic objectForKey:@"userName"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userName"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];

                BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
  
                NSLog(@"%@",verifyStr);
                NSLog(@"%@",[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]);
                
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }
        }
    }];
}

#pragma mark 发送短信信息的辅助类；
- (void)sendSmsModelRequestWithUserPhone:(NSString *)userphone andVerifyType:(NSString *)verifytype WithSuccess:(ReturnBlock)returnData{
    [self sendSmsModelRequestWithBorrowName:@"" andWithBorrowPhone:@"" andWithUserPhone:userphone andBorrowArea:@"" andVerifyType:verifytype WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        returnData(respString,datadic);
    }];
}



#pragma mark 发送短信信息;
- (void)sendSmsModelWithBorrowName:(NSString *)borrowname andWithBorrowPhone:(NSString *)borrowphone andWithUserPhone:(NSString *)userphone andBorrowArea:(NSString *)borrowarea andVerifyType:(NSString *)verifytype WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"SendSmsModel";
    
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@",VERSION,methodStr,PHONETYPE,userphone,verifytype];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"phoneType\":\"%@\",\"userTel\":\"%@\",\"verifyType\":\"%@\",\"borrowPeople\":\"%@\",\"bmPhone\":\"%@\",\"area\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,PHONETYPE,userphone,verifytype,borrowname,borrowphone,borrowarea,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)sendSmsModelRequestWithBorrowName:(NSString *)borrowname andWithBorrowPhone:(NSString *)borrowphone andWithUserPhone:(NSString *)userphone andBorrowArea:(NSString *)borrowarea andVerifyType:(NSString *)verifytype WithSuccess:(ReturnBlock)returnData{
    
    [self sendSmsModelWithBorrowName:borrowname andWithBorrowPhone:borrowphone andWithUserPhone:userphone andBorrowArea:borrowarea andVerifyType:verifytype WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
        if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"respCodeDesc"]&&[dic objectForKey:@"userTel"]&&[dic objectForKey:@"verifyType"]&&[dic objectForKey:@"verifyCode"]){
            NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userTel"],[dic objectForKey:@"verifyType"],[dic objectForKey:@"verifyCode"]];
            //验证签名；
//            RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//            BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];

             BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
            if(isTrue){
                //验证签名成功；
                if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                    returnData(nil,dic);
                }else{
                    returnData([dic objectForKey:@"respCodeDesc"],nil);
                }
                
            }else{
                //验证签名失败；
                returnData(@"验证签名失败",nil);
            }
        }else{
            returnData(dic[@"respCodeDesc"],nil);
        }}
    }];
}

//充值明细;
- (void)userRechargeRecordWithUserId:(NSString *)userid andWithStartPage:(NSString *)startpage andWithPageSize:(NSString *)pagesize andWithRechargeStatus:(NSString *)rechargestatus WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserRechargeRecord";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",VERSION,methodStr,userid,startpage,pagesize,rechargestatus,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"startPage\":\"%@\",\"pageSize\":\"%@\",\"rechargeStatus\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,startpage,pagesize,rechargestatus,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userRechargeRecordRequestWithUserId:(NSString *)userid andWithStartPage:(NSString *)startpage andWithPageSize:(NSString *)pagesize andWithRechargeStatus:(NSString *)rechargestatus WithSuccess:(ReturnBlock)returnData{
    
    [self userRechargeRecordWithUserId:userid andWithStartPage:startpage andWithPageSize:pagesize andWithRechargeStatus:rechargestatus WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
        if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]&&[dic objectForKey:@"totalCount"]&&[dic objectForKey:@"pageCount"]&&[dic objectForKey:@"currentPage"]&&[dic objectForKey:@"rechargeStatus"]){
            NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"],[dic objectForKey:@"totalCount"],[dic objectForKey:@"pageCount"],[dic objectForKey:@"currentPage"],[dic objectForKey:@"rechargeStatus"]];
            //验证签名；
//            RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//            BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
       BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
            if(isTrue){
                //验证签名成功；
                if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                    returnData(nil,dic);
                }else{
                    returnData([dic objectForKey:@"respCodeDesc"],nil);
                }
                
            }else{
                //验证签名失败；
                returnData(@"验证签名失败",nil);
            }
        }else{
            returnData(dic[@"respCodeDesc"],nil);
        }}
    }];
}


//安全设置;

- (void)userSecuritySafeWithUserId:(NSString *)userid WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserSecuritySafe";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,PHONETYPE,signStr];
    
   
     NSLog(@"%@",sendMessage);
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userSecuritySafeRequestWithUserId:(NSString *)userid WithSuccess:(ReturnBlock)returnData{
    
    [self userSecuritySafeWithUserId:userid WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
          BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}

//修改登录密码;
- (void)userEditPasswordWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword andOldPassword:(NSString *)oldpassword WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserEditPassword";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * oldpasswordStr = [rsa rsaEncryptString:oldpassword];
//    NSString * newpasswordStr = [rsa rsaEncryptString:newpassword];
    NSString *oldpasswordStr = [DESEncryptFile md5Str:oldpassword];
    
    NSString *newpasswordStr = [DESEncryptFile md5Str:newpassword];
    
    
    
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"oldPassword\":\"%@\",\"newPassword\":\"%@\",\"sendSmsCode\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,oldpasswordStr,newpasswordStr,@"",PHONETYPE,signStr];
    //发送网络请求；
    
     NSLog(@"%@",sendMessage);
    
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userEditPasswordRequestWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword andOldPassword:(NSString *)oldpassword WithSuccess:(ReturnBlock)returnData{
    
    [self userEditPasswordWithUserId:userid andNewPassword:newpassword andOldPassword:oldpassword WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
           BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}

//修改交易密码;
- (void)userModifyPayPwWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword andOldPassword:(NSString *)oldpassword WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"hkUserModifyPayPw";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * oldpasswordStr = [rsa rsaEncryptString:oldpassword];
//    NSString * newpasswordStr = [rsa rsaEncryptString:newpassword];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString *oldpasswordStr = [DESEncryptFile md5Str:oldpassword];
    
    NSString *newpasswordStr = [DESEncryptFile md5Str:newpassword];
    
    

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];

    
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"oldPayPw\":\"%@\",\"newPayPw\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,oldpasswordStr,newpasswordStr,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userModifyPayPwRequestWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword andOldPassword:(NSString *)oldpassword WithSuccess:(ReturnBlock)returnData{
    
    [self userModifyPayPwWithUserId:userid andNewPassword:newpassword andOldPassword:oldpassword WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
               BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}

//设置交易密码;
- (void)userEditPayPwWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserEditPayPw";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * passwordStr = [rsa rsaEncryptString:newpassword];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];


    
    NSString *passwordStr = [DESEncryptFile md5Str:newpassword];
    

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];

    
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"newPayPw\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,passwordStr,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userEditPayPwRequestWithUserId:(NSString *)userid andNewPassword:(NSString *)newpassword WithSuccess:(ReturnBlock)returnData{
    
    [self userEditPayPwWithUserId:userid andNewPassword:newpassword WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
          BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


//修改手机号;
- (void)userEditTelWithUserId:(NSString *)userid andNewPhonenum:(NSString *)newphonenum WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserEditTel";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@",VERSION,methodStr,userid,newphonenum,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];


    

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];

    
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"userTel\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,newphonenum,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userEditTelRequestWithUserId:(NSString *)userid andNewPhonenum:(NSString *)newphonenum WithSuccess:(ReturnBlock)returnData{
    
    [self userEditTelWithUserId:userid andNewPhonenum:newphonenum WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]&&[dic objectForKey:@"userTel"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"],[dic objectForKey:@"userTel"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
            BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}

//充值和绑卡;

- (void)rechargeRzAndCzWithUserId:(NSString *)userid andWithMoney:(NSString *)money andWithIdCard:(NSString *)idcard andWithRealname:(NSString *)realname andWithBankCard:(NSString *)bankcard andWithOrderid:(NSString *)orderid WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"RechargeRzAndCz";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@",VERSION,methodStr,PHONETYPE,userid,orderid];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",\"money\":\"%@\",\"sfzh\":\"%@\",\"zsxm\":\"%@\",\"yhk\":\"%@\",\"ddh\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,money,idcard,realname,bankcard,orderid,PHONETYPE,signStr];
    //发送网络请求；
    
    NSLog(@"%@",sendMessage);
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)rechargeRzAndCzRequestWithUserId:(NSString *)userid andWithMoney:(NSString *)money andWithIdCard:(NSString *)idcard andWithRealname:(NSString *)realname andWithBankCard:(NSString *)bankcard andWithOrderid:(NSString *)orderid  WithSuccess:(ReturnBlock)returnData{
    
    [self rechargeRzAndCzWithUserId:userid andWithMoney:money andWithIdCard:idcard andWithRealname:realname andWithBankCard:bankcard andWithOrderid:orderid WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"ddFlag"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"ddFlag"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
             BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"144"]){
                        returnData(@"订单号重复",nil);
                    }
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


//进入用户充值;

- (void)userIntoRechargeWithUserId:(NSString *)userid WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserIntoRecharge";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userIntoRechargeRequestWithUserId:(NSString *)userid WithSuccess:(ReturnBlock)returnData{
    
    [self userIntoRechargeWithUserId:userid WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]&&[dic objectForKey:@"cardlast"]&&[dic objectForKey:@"kyye"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"],[dic objectForKey:@"cardlast"],[dic objectForKey:@"kyye"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];

                 BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


//语音验证码;

- (void)sendAudioSmsWithUserPhone:(NSString *)phonenum andWithType:(NSString *)type WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"SendAudioSms";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@",VERSION,methodStr,PHONETYPE,phonenum,type];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userTel\":\"%@\",\"verifyType\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,phonenum,type,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)sendAudioSmsRequestWithUserPhone:(NSString *)phonenum andWithType:(NSString *)type WithSuccess:(ReturnBlock)returnData{
    
    [self sendAudioSmsWithUserPhone:phonenum andWithType:type WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userTel"]&&[dic objectForKey:@"verifyType"]&&[dic objectForKey:@"verifyCode"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userTel"],[dic objectForKey:@"verifyType"],[dic objectForKey:@"verifyCode"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
             BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


//设置登录密码;
- (void)userSetPasswordWithUserPhone:(NSString *)phonenum andWithNewPassword:(NSString *)password WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserSetPassword";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,phonenum,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * passwordStr = [rsa rsaEncryptString:password];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString *passwordStr = [DESEncryptFile md5Str:password];
    
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userTel\":\"%@\",\"newPassword\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,phonenum,passwordStr,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userSetPasswordRequestWithUserPhone:(NSString *)phonenum andWithNewPassword:(NSString *)password WithSuccess:(ReturnBlock)returnData{
    
    [self userSetPasswordWithUserPhone:phonenum andWithNewPassword:password WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userTel"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userTel"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
             BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}



//意见反馈;
- (void)userFeedbackWithUserId:(NSString *)userid andWithContact:(NSString *)contact andWithContent:(NSString *)content WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"UserFeedback";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@",VERSION,methodStr,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * key =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:key];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",\"contact\":\"%@\",\"content\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,contact,content,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)userFeedbackRequestWithUserId:(NSString *)userid andWithContact:(NSString *)contact andWithContent:(NSString *)content WithSuccess:(ReturnBlock)returnData{
    
    [self userFeedbackWithUserId:userid andWithContact:contact andWithContent:content WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];

                 BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


//还款列表;
- (void)backMoneyWithUserId:(NSString *)userid WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"RefundPlan";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)backMoneyRequestWithUserId:(NSString *)userid WithSuccess:(ReturnBlock)returnData{
    
    [self backMoneyWithUserId:userid WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
          BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                NSLog(@"%@",[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]);
                NSLog(@"%@",verifyStr);
                
                
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],dic);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}

#pragma mark 继续借款
- (void)hkLoanAgainWithUserId:(NSString *)userid andWithliveCity:(NSString *)city andWithmonthMoney:(NSString *)moneymonth andWithborrowMoney:(NSString *)money andWithSex:(NSString *)sex andWithrealName:(NSString *)name andWithphoneNum:(NSString *)phonenum WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"LoanAgain";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];

    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\", \"messageType\":\"%@\",\"userId\":\"%@\",\"szcs\":\"%@\",\"shysr\":\"%@\",\"jkje\":\"%@\",\"xb\":\"%@\",\"xm\":\"%@\",\"sjh\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,city,moneymonth,money,sex,name,phonenum,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)hkLoanAgainRequestWithUserId:(NSString *)userid andWithliveCity:(NSString *)city andWithmonthMoney:(NSString *)moneymonth andWithborrowMoney:(NSString *)money andWithSex:(NSString *)sex andWithrealName:(NSString *)name andWithphoneNum:(NSString *)phonenum WithSuccess:(ReturnBlock)returnData{
    
    [self hkLoanAgainWithUserId:(NSString *)userid andWithliveCity:(NSString *)city andWithmonthMoney:(NSString *)moneymonth andWithborrowMoney:(NSString *)money andWithSex:(NSString *)sex andWithrealName:(NSString *)name andWithphoneNum:(NSString *)phonenum WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];

                 BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


#pragma  mark 还款
- (void)hkPayWithUserId:(NSString *)userid andWithPlanId:(NSString *)planid andWithPayPassword:(NSString *)paypassword WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"Pay";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@",VERSION,methodStr,userid,planid,PHONETYPE];
    //数字签名；
//    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    
    NSString *passwordStr = [DESEncryptFile md5Str:paypassword];
    
//    NSString * passwordStr = [rsa rsaEncryptString:paypassword];
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",\"refundPlanId\":\"%@\",\"payPsw\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,planid,passwordStr,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        //NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
}
- (void)hkPayRequestWithUserId:(NSString *)userid andWithPlanId:(NSString *)planid andWithPayPassword:(NSString *)paypassword WithSuccess:(ReturnBlock)returnData{
    
    [self hkPayWithUserId:userid andWithPlanId:planid andWithPayPassword:paypassword WithSuccess:^(NSDictionary *dic,NSString * errorStr) {
        if(errorStr){
            returnData(errorStr,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
//                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
//                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
          BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        returnData(nil,dic);
                    }else{
                        returnData([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    returnData(@"验证签名失败",nil);
                }
            }else{
                returnData(dic[@"respCodeDesc"],nil);
            }}
    }];
}


//- (void)hkPayRequestWithUserId:(NSString *)userid andWithPlanId:(NSString *)planid andWithPayPassword:(NSString *)paypassword WithSuccess:(ReturnBlock)returnData;

#pragma mark -- 上传地址
-(void)postLocationWithlatitude:(NSString *)latitude Withlongitude:(NSString *)longitude WithUserId:(NSString *)userid WithAddress:(NSString *)address WithSuccess:(ReturnBlock)retureBlock{
    [self locationWithlatitude:latitude Withlongitude:longitude WithUserId:userid WithAddress:address WithSuccess:^(NSDictionary *dic, NSString *errorString) {
        if(errorString){
            retureBlock(errorString,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
                //                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
                //                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
                NSLog(@"%@",[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]);
                
                BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        retureBlock(nil,dic);
                    }else{
                        retureBlock([dic objectForKey:@"respCodeDesc"],nil);
                    }
                    
                }else{
                    //验证签名失败；
                    retureBlock(@"验证签名失败",nil);
                }
            }else{
                retureBlock(dic[@"respCodeDesc"],nil);
            }}

    }];
}
-(void)locationWithlatitude:(NSString *)latitude Withlongitude:(NSString *)longitude WithUserId:(NSString *)userid WithAddress:(NSString *)address WithSuccess:(SignBlock)signData{
    
    //格式化处理数据；
    NSString * methodStr = @"SaveCustomerLocation";
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",VERSION,methodStr,userid,longitude,latitude,address,PHONETYPE];
    //数字签名；
    //    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
    //    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    
    //    NSString * passwordStr = [rsa rsaEncryptString:paypassword];
    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",\"longitude\":\"%@\",\"latitude\":\"%@\",\"address\":\"%@\",\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,longitude,latitude,address,PHONETYPE,signStr];
    NSLog(@"%@",sendMessage);
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];

}

#pragma mark -- 上传通讯录
//字典转为Json字符串
-(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)arrayToJsonStringWitharr:(NSMutableArray *)muarr{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muarr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(void)postPhoneListWitharr:(NSMutableArray *)phonelist WithUserid:(NSString *)userid WithSuccess:(ReturnBlock)retureBlock{
    [self phoneListWitharr:phonelist WithUserid:userid WithSuccess:^(NSDictionary *dic, NSString *errorString) {
        if(errorString){
            retureBlock(errorString,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
                //                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
                //                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
                NSLog(@"%@",[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]);
                BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        retureBlock(nil,dic);
                    }else{
                        retureBlock([dic objectForKey:@"respCodeDesc"],nil);
                    }
                }else{
                    //验证签名失败；
                    retureBlock(@"验证签名失败",nil);
                }
            }else{
                retureBlock(dic[@"respCodeDesc"],nil);
            }}
    }];
}
-(void)phoneListWitharr:(NSMutableArray *)phonelist WithUserid:(NSString *)userid WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"SaveTelephoneNumberRecord";
//    NSString *phonestr = [self dictionaryToJson:@{@"phonelist":phonelist}];

    NSString *phoneliststr = [self arrayToJsonStringWitharr:phonelist];
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
    //    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
    //    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    
    
    //    NSString * passwordStr = [rsa rsaEncryptString:paypassword];
//    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",\"phonelist\":%@,\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,phoneliststr,PHONETYPE,signStr];
    NSDictionary *dic = @{@"version":VERSION,@"messageType":methodStr,@"userId":userid,@"phonelist":phoneliststr,@"phoneType":PHONETYPE,@"signValue":signStr};
    
    NSString *sendMessage = [self dictionaryToJson:dic];
    
    NSLog(@"%@",sendMessage);
//    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",%@,\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,phonestr,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];

}

#pragma mark -- 获取公司说明
-(void)getCompanyIntorduceWithUserid:(NSString *)userid WithSuccess:(ReturnBlock)retureBlock{

    [self getcompanyIntroduceWithUserid:userid WithSuccess:^(NSDictionary *dic, NSString *errorString) {
        if(errorString){
            retureBlock(errorString,nil);
        }else{
            if([dic objectForKey:@"messageType"]&&[dic objectForKey:@"respCode"]&&[dic objectForKey:@"userId"]){
                NSString * verifyStr = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"messageType"],[dic objectForKey:@"respCode"],[dic objectForKey:@"userId"]];
                //验证签名；
                //                RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
                //                BOOL isTrue = [rsa rsaSHA1VerifyData:[verifyStr dataUsingEncoding:NSUTF8StringEncoding] withSignature:[NSData dataWithBase64EncodedString:[dic objectForKey:@"signValue"]]];
                NSLog(@"%@",[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]);
                BOOL isTrue = [verifyStr isEqual:[des encryptWithContent:[dic objectForKey:@"signValue"] type:kCCDecrypt key:@"cbi7hiGn"]];
                if(isTrue){
                    //验证签名成功；
                    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"]){
                        retureBlock(nil,dic);
                    }else{
                        retureBlock([dic objectForKey:@"respCodeDesc"],nil);
                    }
                }else{
                    //验证签名失败；
                    retureBlock(@"验证签名失败",nil);
                }
            }else{
                retureBlock(dic[@"respCodeDesc"],nil);
            }}

        
    }];
    
}
-(void)getcompanyIntroduceWithUserid:(NSString *)userid WithSuccess:(SignBlock)signData{
    //格式化处理数据；
    NSString * methodStr = @"GetRYHSoftwareIntroduce";
    //    NSString *phonestr = [self dictionaryToJson:@{@"phonelist":phonelist}];
    
    NSString * Message = [NSString stringWithFormat:@"%@%@%@%@",VERSION,methodStr,userid,PHONETYPE];
    //数字签名；
    //    RSAEncryptor * rsa = [[RSAEncryptor alloc] init];
    //    NSString * signStr = [rsa signTheDataSHA1WithRSA:Message];
    NSString * content =@"cbi7hiGn";
    
    NSString *signStr = [des encryptWithContent:Message type:kCCEncrypt key:content];
    

    NSDictionary *dic = @{@"version":VERSION,@"messageType":methodStr,@"userId":userid,@"phoneType":PHONETYPE,@"signValue":signStr};
    
    NSString *sendMessage = [self dictionaryToJson:dic];
    
    NSLog(@"%@",sendMessage);
    //    NSString * sendMessage = [NSString stringWithFormat:@"{\"version\":\"%@\",\"messageType\":\"%@\",\"userId\":\"%@\",%@,\"phoneType\":\"%@\",\"signValue\":\"%@\"}",VERSION,methodStr,userid,phonestr,PHONETYPE,signStr];
    //发送网络请求；
    HaiHeNetworking * net = [HaiHeNetworking sharedHaiheNet];
    
    [net sendRequestWithSendMessage:sendMessage WithSuccess:^(NSDictionary *dic,NSString *errorCode) {
        NSLog(@"接收到的数据为:%@",dic);
        signData(dic,errorCode);
    }];
    
}


@end
