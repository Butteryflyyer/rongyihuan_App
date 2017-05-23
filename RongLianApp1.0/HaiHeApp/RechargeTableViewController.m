//
//  RechargeTableViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/10.
//  Copyright © 2015年 马广召. All rights reserved.
//
#import "HaiheHeader.h"
#import "RechargeTableViewController.h"
#import "RightImageTableViewCell.h"
#import "RechargeRecordTableViewController.h"
#import "ShowMessageView.h"
#import "HaiHeNetBridge.h"
#import "RechargeSuccessTableViewController.h"

#import "ShowWebView.h"

@interface RechargeTableViewController ()
@property (nonatomic ,retain)NSArray * placeholderArr;
@property (nonatomic, retain)UITextField * realnameTF;
@property (nonatomic, retain)UITextField * idcardTF;
@property (nonatomic, retain)UITextField * bankcard;
@property (nonatomic, retain)UITextField * moneyTF;
@property (nonatomic, retain)LLPaySdk * paysdk;
@property (nonatomic, retain)UIButton * submitBtn;

@property (nonatomic, retain)NSString * dingdanStr;
//@property (nonatomic, retain)NSString * cardlastStr;
//@property (nonatomic, retain)NSString * banknameStr;

@end

@implementation RechargeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    _placeholderArr = @[@"您的真实姓名",@"您的身份证号",@"银行卡号",@"充值金额(最低500元)"];
    
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
    if ([_realnameTF isFirstResponder]) {
        [_realnameTF resignFirstResponder];
    }
    if ([_idcardTF isFirstResponder]) {
        [_idcardTF resignFirstResponder];
    }

    if ([_bankcard isFirstResponder]) {
        [_bankcard resignFirstResponder];
    }

    if ([_moneyTF isFirstResponder]) {
        [_moneyTF resignFirstResponder];
    }
}

- (void)RightBarItemBeTouched:(id)sender{
    RechargeRecordTableViewController * rechargeRecordVC = [[RechargeRecordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    rechargeRecordVC.userid = _userid;
    [self.navigationController pushViewController:rechargeRecordVC animated:YES];
    
}


//- (void)RightBarItemBeTouched:(id)sender{
//    RechargeRecordTableViewController * rechargeRecordVC = [[RechargeRecordTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:rechargeRecordVC animated:YES];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 4;
}


- (RightImageTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellidentifier = @"rechargecell";
    RightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if(!cell){
        cell = [[RightImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    
    }
    cell.titleTextfield.placeholder = _placeholderArr[indexPath.row];
    cell.titleTextfield.font = [UIFont systemFontOfSize:14];
    switch (indexPath.row) {
        case 0:{
            _realnameTF = cell.titleTextfield;
        }
            break;
        case 1:{
            _idcardTF = cell.titleTextfield;
            _idcardTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
            break;
        case 2:{
            _bankcard = cell.titleTextfield;
            _bankcard.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 3:{
            _moneyTF = cell.titleTextfield;
            _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        }
            break;
            
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 300;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
    footV.backgroundColor = [UIColor clearColor];
    
    UIButton * duigouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duigouBtn.frame = CGRectMake(tableView.frame.size.width-200, 5, 30, 30);
   // duigouBtn.backgroundColor = [UIColor redColor];
    [duigouBtn setImage:[UIImage imageNamed:@"xuankuang"] forState:UIControlStateNormal];
    [duigouBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    duigouBtn.selected = YES;
    [duigouBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [duigouBtn addTarget:self action:@selector(duigouButtonBeTouch:) forControlEvents:UIControlEventTouchDown];
    [footV addSubview:duigouBtn];
    
    UILabel * xieyiL = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-170, 0, 90, 40)];
    //xieyiL.backgroundColor = [UIColor orangeColor];
    xieyiL.text = @"我已阅读并同意";
    xieyiL.font = [UIFont systemFontOfSize:12];
    xieyiL.textAlignment = NSTextAlignmentRight;
    [footV addSubview:xieyiL];
    
    UIButton * xieyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiBtn.frame = CGRectMake(tableView.frame.size.width-80, 0, 80, 40);
    xieyiBtn.backgroundColor = [UIColor clearColor];
    [xieyiBtn setTitle:@"快捷支付说明" forState:UIControlStateNormal];
    [xieyiBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
    xieyiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [xieyiBtn addTarget:self action:@selector(xieyiButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:xieyiBtn];
    
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn = submitBtn;
    submitBtn.frame = CGRectMake(20, 50, footV.frame.size.width-40, 44);
    [submitBtn setTitle:@"绑定并支付" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    submitBtn.titleLabel.textColor = [UIColor whiteColor];
    submitBtn.backgroundColor = nav_bgcolor;
    //submitBtn.enabled = NO;
    [submitBtn addTarget:self action:@selector(submitButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 3;
    submitBtn.layer.masksToBounds = YES;
    [footV addSubview:submitBtn];
    
//    UIWebView * webV = [[UIWebView alloc] initWithFrame:CGRectMake(10, 100, footV.frame.size.width-20, 280)];
//    webV.backgroundColor = [UIColor redColor];
//    
//    [footV addSubview:webV];
    UILabel * tishiL = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
    tishiL.text = @"温馨提示:";
    tishiL.textAlignment = NSTextAlignmentLeft;
    tishiL.font = [UIFont systemFontOfSize:15];
    tishiL.backgroundColor = [UIColor clearColor];
    tishiL.textColor = [UIColor lightGrayColor];
    [footV addSubview:tishiL];
    
    UITextView * textV = [[UITextView alloc] initWithFrame:CGRectMake(10, 140, footV.frame.size.width-20, 300)];
    textV.text = @"1.您绑定的银行卡用于充值和提现，不能绑定信用卡。\n2.请确保您的卡已开通快捷支付，未开通请咨询银行客服办理。\n3.邮储银行、招商银行快捷支付限额较低，建议您优先绑定其他银行的储蓄卡。\n4.每天22:00-24:00建设银行会进行系统日切，该时段将无法进行充值交易，请您错时交易，由此给您带来不便敬请谅解。";
    textV.editable = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textV.attributedText = [[NSAttributedString alloc] initWithString:textV.text attributes:attributes];

    textV.textColor = [UIColor lightGrayColor];
    textV.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [footV addSubview:textV];
    
    return footV;

}

//协议按钮;
- (void)xieyiButtonBeTouch:(id)sender{
    [[ShowWebView shareManager] showMessage];

}
//勾选协议按钮;
- (void)duigouButtonBeTouch:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        _submitBtn.enabled = NO;
        _submitBtn.backgroundColor = [UIColor lightGrayColor];
    }else{
    sender.selected = YES;
    //[sender setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
        _submitBtn.enabled = YES;
        _submitBtn.backgroundColor = nav_bgcolor;
    }
}


- (void)submitButtonBeTouch:(id)sender{
    UIButton * submitBtn = (UIButton *)sender;
    
    NSString * realnameStr = [_realnameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * idcardStr = [_idcardTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * bankcardStr = [_bankcard.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * moneyStr = [_moneyTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([realnameStr isEqualToString:@""]) {
        [[ShowMessageView shareManager] showMessage:@"姓名不能为空"];
    }else if ([idcardStr isEqualToString:@""]){
        [[ShowMessageView shareManager] showMessage:@"身份证号不能为空"];
    }else if ([bankcardStr isEqualToString:@""]){
        [[ShowMessageView shareManager] showMessage:@"银行卡不能为空"];
    }else if ([moneyStr intValue]<500){
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
            [[HaiHeNetBridge sharedManager] rechargeRzAndCzRequestWithUserId:_userid andWithMoney:_moneyTF.text andWithIdCard:_idcardTF.text andWithRealname:_realnameTF.text andWithBankCard:_bankcard.text andWithOrderid:simOrder WithSuccess:^(NSString *respString, NSDictionary *datadic) {
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
    
//    if (![_realnameTF.text isEqualToString:@""]) {
//        if (![_idcardTF.text isEqualToString:@""]) {
//            if (![_bankcard.text isEqualToString:@""]) {
//                if ([_moneyTF.text floatValue]>=500) {
//                    //向后台传递数据;返回加密后的消息;
//                    
//                    NSMutableString * suiji = [NSMutableString string];
//                    for (int i=0; i<6; i++) {
//                        NSString * str = [NSString stringWithFormat:@"%d",arc4random() % 10];
//                        [suiji appendString:str];
//                    }
//                    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//                    [dateFormater setDateFormat:@"yyyyMMddHHmmssSSS"];
//                    NSString *simOrder = [NSString stringWithFormat:@"%@%@",[dateFormater stringFromDate:[NSDate date]],suiji];
//                    _dingdanStr = simOrder;
//                    [[HaiHeNetBridge sharedManager] rechargeRzAndCzRequestWithUserId:_userid andWithMoney:_moneyTF.text andWithIdCard:_idcardTF.text andWithRealname:_realnameTF.text andWithBankCard:_bankcard.text andWithOrderid:simOrder WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                        submitBtn.enabled = YES;
//                        [submitBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
//                        if (!respString) {
//                            if ([[datadic objectForKey:@"ddFlag"]isEqualToString:@"1"]) {
//                                //开始连连支付;
//                                NSDictionary * payDic = [self creatPayOrderWith:datadic andWithpayOrderStr:simOrder andWithPaymoneyStr:_moneyTF.text];
//                                self.paysdk = [[LLPaySdk alloc] init];
//                                self.paysdk.sdkDelegate = self;
//                                [self.paysdk presentVerifyPaySdkInViewController:self withTraderInfo:payDic];
//                                
//                     //马广召
//                            }else{
//                                [[ShowMessageView shareManager] showMessage:@"后台同步数据出错,请重试"];
//                            }
//                        }else{
//                            [[ShowMessageView shareManager] showMessage:respString];
//                        }
//                    }];
//                }else{
//                    [[ShowMessageView shareManager] showMessage:@"充值金额格式不正确"];
//                }
//
//            }else{
//                [[ShowMessageView shareManager] showMessage:@"银行卡号格式不正确"];
//            }
//
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"身份证号格式不正确"];
//        }
//
//    }else{
//        [[ShowMessageView shareManager] showMessage:@"真实姓名格式不正确"];
//    }

}

//连连支付数据形成;
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
                           @"risk_item" : [self appendRiskStrig],
                           
                           @"user_id": _userid,
                           //商户用户唯一编号 否 该用户在商户系统中的唯一编号，要求是该编号在商户系统中唯一标识该用户
                           
                           //                           @"flag_modify":@"1",
                           //修改标记 flag_modify 否 String 0-可以修改，默认为0, 1-不允许修改 与id_type,id_no,acct_name配合使用，如果该用户在商户系统已经实名认证过了，则在绑定银行卡的输入信息不能修改，否则可以修改
                           
                           @"card_no":_bankcard.text,
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
                                      @"id_no":_idcardTF.text,
                                      //证件号码 id_no 否 String
                                      @"acct_name":_realnameTF.text,
                                      //银行账号姓名 acct_name 否 String
                                      }];
    // }
    
    param[@"oid_partner"] = kLLOidPartner;
    
    param[@"sign"] = [dic objectForKey:@"paySign"];

    return param;
}

- (NSString *)appendRiskStrig{
    NSMutableString * riskstr = [NSMutableString string];
    [riskstr appendFormat:@"{\"%@\":\"%@\",",@"user_info_full_name",_realnameTF.text];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"frms_ware_category",@"2010"];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_dt_register",_zhuceTime];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_id_type",@"0"];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_identify_state",@"0"];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_bind_phone",_phoneStr];
    [riskstr appendFormat:@"\"%@\":\"%@\",",@"user_info_id_no",_idcardTF.text];
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
                successVC.banknameStr = @"";
                successVC.bankcardStr = [_bankcard.text substringFromIndex:_bankcard.text.length-3];
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
