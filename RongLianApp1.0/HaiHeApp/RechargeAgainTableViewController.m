//
//  RechargeAgainTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/29.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "RechargeAgainTableViewController.h"
#import "RechargeRecordTableViewController.h"
#import "RechargeSuccessTableViewController.h"
#import "RightImageTableViewCell.h"
#import "HaiheHeader.h"
#import "ShowMessageView.h"
#import "RegularClass.h"
#import "HaiHeNetBridge.h"
#import "RechargeSuccessTableViewController.h"
@interface RechargeAgainTableViewController ()
@property (nonatomic, retain)NSString * realnameStr;
@property (nonatomic, retain)NSString * idcardStr;
@property (nonatomic, retain)NSString * bankcardStr;
@property (nonatomic, retain)NSString * banknameStr;
@property (nonatomic, retain)NSString * keyongStr;
@property (nonatomic, retain)NSString * dangriStr;
@property (nonatomic, retain)UITextField * moneyTF;
@property (nonatomic, retain)LLPaySdk * paysdk;
@property (nonatomic, retain)NSString * bankcardlastStr;
@property (nonatomic, retain)NSString * dingdanStr;
@end

@implementation RechargeAgainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMoreDataWithUserId:_userid];
    self.navigationItem.title = @"充值";
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"充值记录" style:UIBarButtonItemStylePlain target:self action:@selector(RightBarItemBeTouched:)];
        rightItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightItem;
    
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
}

- (void)selectViewBeTap{
    if ([_moneyTF isFirstResponder]) {
        [_moneyTF resignFirstResponder];
    }
}

- (void)getMoreDataWithUserId:(NSString *)userid{
        [[HaiHeNetBridge sharedManager] userIntoRechargeRequestWithUserId:userid WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            if (!respString) {
                //
                _realnameStr = [datadic objectForKey:@"zsxm"];
                _bankcardlastStr = [datadic objectForKey:@"cardlast"];
                _idcardStr = [datadic objectForKey:@"sfzh"];
                _bankcardStr = [datadic objectForKey:@"cardAll"];
                _banknameStr = [datadic objectForKey:@"yymc"];
                _keyongStr = [datadic objectForKey:@"kyye"];
                _dangriStr = [datadic objectForKey:@"bkxe"];
                [self.tableView reloadData];
            }else{
                [[ShowMessageView shareManager] showMessage:respString];
            }
        }];
}

- (void)RightBarItemBeTouched:(id)sender{
    RechargeRecordTableViewController * rechargeRecordVC = [[RechargeRecordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    rechargeRecordVC.userid = _userid;
    [self.navigationController pushViewController:rechargeRecordVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 20;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 30;
    }else{
        return tableView.frame.size.height-200;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString * cellidenti = @"rechargeagaincell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
        }
        cell.imageView.image = [UIImage imageNamed:_banknameStr];
       // NSString * xingStr = @"************************";
        NSString * cardStr = [_bankcardStr stringByReplacingCharactersInRange:NSMakeRange(4, _bankcardStr.length-8) withString:@" ******* "];
        cell.textLabel.text = cardStr;
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        // Configure the cell...
        
        return cell;

    }else{
        static NSString * cellid = @"againcell";
        RightImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.titleTextfield.placeholder = @"充值金额(元),最低500";
        _moneyTF = cell.titleTextfield;
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView * footerV = [[UIView alloc] init];
        UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-30, 30)];
        hintL.text = [NSString stringWithFormat:@"可用余额(元):%.2f",[_keyongStr floatValue]];
        hintL.textAlignment = NSTextAlignmentLeft;
        hintL.font = [UIFont systemFontOfSize:14];
        hintL.textColor = [UIColor blackColor];
        [footerV addSubview:hintL];
        return footerV;
        
    }else{
        UIView * footerV = [[UIView alloc] init];
        UILabel * hintL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width-20, 40)];
        hintL.text = [NSString stringWithFormat:@"限额:%@",_dangriStr];
        hintL.textAlignment = NSTextAlignmentRight;
        hintL.font = [UIFont systemFontOfSize:14];
        hintL.textColor = [UIColor lightGrayColor];
        [footerV addSubview:hintL];

        UIButton * submitBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, 40, tableView.frame.size.width-20, 40);
        submitBtn.backgroundColor = nav_bgcolor;
        [submitBtn setTitle:@"确认充值" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
        submitBtn.layer.cornerRadius = 3;
        submitBtn.layer.masksToBounds = YES;
        [footerV addSubview:submitBtn];
        
        return footerV;
    }
    return 0;
}

- (void)submitButtonBeTouch:(id)sender{
    UIButton * submitBtn = (UIButton *)sender;
    
    NSString * moneyStr = [_moneyTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([moneyStr intValue]<500){
        [[ShowMessageView shareManager] showMessage:@"充值金额须大于500元"];
    }else{
                NSMutableString * suiji = [NSMutableString string];
                for (int i=0; i<6; i++) {
                    NSString * str = [NSString stringWithFormat:@"%d",arc4random() % 10];
                    [suiji appendString:str];
                        }
                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"yyyyMMddHHmmssSSS"];
                NSString *simOrder = [NSString stringWithFormat:@"%@%@",[dateFormater stringFromDate:[NSDate date]],suiji];
                _dingdanStr = simOrder;
                submitBtn.enabled = NO;
                submitBtn.backgroundColor = [UIColor lightGrayColor];
                    [[HaiHeNetBridge sharedManager] rechargeRzAndCzRequestWithUserId:_userid andWithMoney:_moneyTF.text andWithIdCard:_idcardStr andWithRealname:_realnameStr andWithBankCard:_bankcardStr andWithOrderid:simOrder WithSuccess:^(NSString *respString, NSDictionary *datadic) {
                        submitBtn.enabled = YES;
                        submitBtn.backgroundColor = nav_bgcolor;
                                if (!respString) {
                                    if ([[datadic objectForKey:@"ddFlag"]isEqualToString:@"1"]) {
                                        //开始连连支付;
        
                                        NSDictionary * payDic = [self creatPayOrderWith:datadic andWithpayOrderStr:simOrder andWithPaymoneyStr:_moneyTF.text];
                                        self.paysdk = [[LLPaySdk alloc] init];
                                        self.paysdk.sdkDelegate = self;
                                        [self.paysdk presentVerifyPaySdkInViewController:self withTraderInfo:payDic];
        
                            }else{
                                        [[ShowMessageView shareManager] showMessage:@"后台同步数据出错,请重试"];
                            }
                        }else{
                            [[ShowMessageView shareManager] showMessage:respString];
                                }
                            }];
    
    }
    
//    if ([_moneyTF.text floatValue]>=500) {
//                    //向后台传递数据;返回加密后的消息;
//                    
//        NSMutableString * suiji = [NSMutableString string];
//        for (int i=0; i<6; i++) {
//            NSString * str = [NSString stringWithFormat:@"%d",arc4random() % 10];
//            [suiji appendString:str];
//                }
//        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//        [dateFormater setDateFormat:@"yyyyMMddHHmmssSSS"];
//        NSString *simOrder = [NSString stringWithFormat:@"%@%@",[dateFormater stringFromDate:[NSDate date]],suiji];
//        _dingdanStr = simOrder;
//            [[HaiHeNetBridge sharedManager] rechargeRzAndCzRequestWithUserId:_userid andWithMoney:_moneyTF.text andWithIdCard:_idcardStr andWithRealname:_realnameStr andWithBankCard:_bankcardStr andWithOrderid:simOrder WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                submitBtn.enabled = YES;
//                [submitBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//                        if (!respString) {
//                            if ([[datadic objectForKey:@"ddFlag"]isEqualToString:@"1"]) {
//                                //开始连连支付;
//                                
//                                NSDictionary * payDic = [self creatPayOrderWith:datadic andWithpayOrderStr:simOrder andWithPaymoneyStr:_moneyTF.text];
//                                self.paysdk = [[LLPaySdk alloc] init];
//                                self.paysdk.sdkDelegate = self;
//                                [self.paysdk presentVerifyPaySdkInViewController:self withTraderInfo:payDic];
//                                
//                    }else{
//                                [[ShowMessageView shareManager] showMessage:@"后台同步数据出错,请重试"];
//                    }
//                }else{
//                    [[ShowMessageView shareManager] showMessage:respString];
//                        }
//                    }];
//        
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"充值金额格式不正确"];
//                }
}

//连连支付字典形成;
- (NSDictionary *)creatPayOrderWith:(NSDictionary *)dic andWithpayOrderStr:(NSString *)orderStr andWithPaymoneyStr:(NSString *)money{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    static NSString *kLLOidPartner = @"201603111000759671";   // 商户号
    //static NSString *kLLPartnerKey = @"201408071000001543test_20140812";   // 密钥
    NSString *signType = @"RSA";    // MD5 || RSA || HMAC
    // TODO: 请开发人员修改下面订单的所有信息，以匹配实际需求
    [param setDictionary:@{
                           @"sign_type":signType,
                           //签名方式	partner_sign_type	是	String	RSA  或者 MD5
                           @"busi_partner":@"101001",
                           //商户业务类型	busi_partner	是	String(6)	虚拟商品销售：101001
                           @"dt_order":[dic objectForKey:@"dtOrder"],
                           //商户订单时间	dt_order	是	String(14)	格式：YYYYMMDDH24MISS  14位数字，精确到秒
                           //                           @"money_order":@"0.10",
                           //交易金额	money_order	是	Number(8,2)	该笔订单的资金总额，单位为RMB-元。大于0的数字，精确到小数点后两位。 如：49.65
                           @"money_order" : _moneyTF.text,
                           
                           @"no_order":[dic objectForKey:@"ddh"],
                           //商户唯一订单号	no_order	是	String(32)	商户系统唯一订单号
                           @"name_goods":[NSString stringWithFormat:@"充值%@元",_moneyTF.text],
                           //商品名称	name_goods	否	String(40)
                           @"info_order":[dic objectForKey:@"infoOrder"],
                           //订单附加信息	info_order	否	String(255)	商户订单的备注信息
                           @"valid_order":@"10080",
                           //分钟为单位，默认为10080分钟（7天），从创建时间开始，过了此订单有效时间此笔订单就会被设置为失败状态不能再重新进行支付。
                           //                           @"shareing_data":@"201412030000035903^101001^10^分账说明1|201310102000003524^101001^11^分账说明2|201307232000003510^109001^12^分账说明3"
                           // 分账信息数据 shareing_data  否 变(1024)
                           
                           @"notify_url":@"https://223.202.60.25/recharge/rechargeBack.do",
                           //服务器异步通知地址	notify_url	是	String(64)	连连钱包支付平台在用户支付成功后通知商户服务端的地址，如：http://payhttp.xiaofubao.com/back.shtml
                           
                           //                           @"risk_item":@"{\"user_info_bind_phone\":\"13958069593\",\"user_info_dt_register\":\"20131030122130\"}",
                           //风险控制参数 否 此字段填写风控参数，采用json串的模式传入，字段名和字段内容彼此对应好
                           @"risk_item" : [self appendRiskStrigWith:dic],
                           
                           @"user_id": _userid,
                           //商户用户唯一编号 否 该用户在商户系统中的唯一编号，要求是该编号在商户系统中唯一标识该用户
                           
                           //                           @"flag_modify":@"1",
                           //修改标记 flag_modify 否 String 0-可以修改，默认为0, 1-不允许修改 与id_type,id_no,acct_name配合使用，如果该用户在商户系统已经实名认证过了，则在绑定银行卡的输入信息不能修改，否则可以修改
                           
                           @"card_no":[dic objectForKey:@"yhkYrz"],
                           //银行卡号 card_no 否 银行卡号前置，卡号可以在商户的页面输入
                           
                           @"no_agree":[dic objectForKey:@"no_agree"],
                           //签约协议号 否 String(16) 已经记录快捷银行卡的用户，商户在调用的时候可以与pay_type一块配合使用
                           }];
    //
    //    BOOL isIsVerifyPay = YES;
    //
    //    if (isIsVerifyPay) {
    //
    [param addEntriesFromDictionary:@{
                                      @"id_no":[dic objectForKey:@"sfzhYrz"],
                                      //证件号码 id_no 否 String
                                      @"acct_name":[dic objectForKey:@"zsxmYrz"],
                                      //银行账号姓名 acct_name 否 String
                                      }];
    // }
    
    param[@"oid_partner"] = kLLOidPartner;
    
    param[@"sign"] = [dic objectForKey:@"paySign"];
    return param;
}


- (NSString *)appendRiskStrigWith:(NSDictionary *)dic{
    NSMutableString * riskstr = [NSMutableString string];
    [riskstr appendFormat:@"{\"%@\":\"%@\",",@"user_info_full_name",[dic objectForKey:@"zsxmYrz"]];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"frms_ware_category",@"2010"];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_dt_register",_zhuceTime];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_id_type",@"0"];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_identify_state",@"0"];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_bind_phone",_phoneStr];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_id_no",[dic objectForKey:@"sfzhYrz"]];
    [riskstr appendFormat:@"\"%@\":\"%@\"}",@"user_info_mercht_userno",_userid];
    
    return riskstr;

}


- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                if (_fromH5) {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    [[ShowMessageView shareManager] showMessage:@"充值成功"];
                }else{
                RechargeSuccessTableViewController * successVC = [[RechargeSuccessTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                successVC.banknameStr = _banknameStr;
                successVC.bankcardStr = _bankcardlastStr;
                successVC.orderStr = _dingdanStr;
                successVC.moneyStr = _moneyTF.text;
                [self.navigationController pushViewController:successVC animated:YES];
                }
               // NSString *payBackAgreeNo = dic[@"agreementno"];
                // TODO: 协议号
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
                [self showMessageViewToUserWithMessage:msg];
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
                [self showMessageViewToUserWithMessage:msg];
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
                [self showMessageViewToUserWithMessage:msg];
            }
        }
//            [self showMessageViewToUserWithMessage:msg];
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            [self showMessageViewToUserWithMessage:msg];
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            [self showMessageViewToUserWithMessage:msg];
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            [self showMessageViewToUserWithMessage:msg];
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            [self showMessageViewToUserWithMessage:msg];
            break;
        default:
            break;
    }
    
}

- (void)showMessageViewToUserWithMessage:(NSString *)msg{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelA = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancelA];
    [self presentViewController:alertC animated:YES completion:nil];

}




@end
