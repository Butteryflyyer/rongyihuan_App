//
//  FeedBackViewController.m
//  HaiHeApp
//
//  Created by 马广召 on 15/9/24.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "FeedBackViewController.h"
#import "HaiHeNetBridge.h"
#import "ShowMessageView.h"
#import "UserLoginStatus.h"
#import "HaiheHeader.h"

@interface FeedBackViewController ()
@property (nonatomic,retain)UILabel * placeholderLabel;
@property (nonatomic, retain)UITextField * contrctTF;
@property (nonatomic, retain)UITextView * contentV;
@property (nonatomic, retain)NSArray * titleArr;
@property (nonatomic, retain)UITextField * textfield1;
@property (nonatomic, retain)UITextField * textfield2;
@property (nonatomic, retain)UITextField * textfield3;
@property (nonatomic, retain)UITextField * textfield4;
@property (nonatomic, retain)UITextField * textfield5;
@property (nonatomic, retain)UITextField * textfield6;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"再次借款";
    _titleArr = @[@"所在城市:",@"税后月收入(元):",@"借款金额(元):",@"您的性别:",@"您的姓名:",@"手机号码:"];
    UITapGestureRecognizer * lefttopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewBeTap)];
    //lefttopTap.delegate = self;
    [lefttopTap setNumberOfTapsRequired:1];
    [lefttopTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:lefttopTap];
    
     [self addSubViews];
    // Do any additional setup after loading the view.
}

- (void)selectViewBeTap{
    if ([_textfield1 isFirstResponder]) {
        [_textfield1 resignFirstResponder];
    }
    if ([_textfield2 isFirstResponder]) {
        [_textfield2 resignFirstResponder];
    }
    if ([_textfield3 isFirstResponder]) {
        [_textfield3 resignFirstResponder];
    }
    if ([_textfield4 isFirstResponder]) {
        [_textfield4 resignFirstResponder];
    }
    if ([_textfield5 isFirstResponder]) {
        [_textfield5 resignFirstResponder];
    }
    if ([_textfield6 isFirstResponder]) {
        [_textfield6 resignFirstResponder];
    }
}

- (void)addSubViews{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i=0; i<6; i++) {
        UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 50*i, self.view.frame.size.width/3, 50)];
        titleL.text = _titleArr[i];
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.textColor = [UIColor lightGrayColor];
        [bgView addSubview:titleL];
        if (i<5) {
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 50*(i+1), self.view.frame.size.width-20, 0.5)];
        lineV.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:lineV];
        }
    }
    
    for (int i=0; i<6; i++) {
        UITextField * dataTF = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3+10, 50*i, self.view.frame.size.width/3*2-20, 50)];
        dataTF.font = [UIFont systemFontOfSize:15];
        dataTF.textAlignment = NSTextAlignmentRight;
        dataTF.textColor = [UIColor blackColor];
        
        switch (i) {
            case 0:
                _textfield1 = dataTF;
                break;
            case 1:
                _textfield2 = dataTF;
                break;
            case 2:
                _textfield3 = dataTF;
                break;
            case 3:
                _textfield4 = dataTF;
                dataTF.placeholder = @"男或女";
                break;
            case 4:
                _textfield5 = dataTF;
                break;
            case 5:
                _textfield6 = dataTF;
                break;
                
            default:
                break;
        }
        [bgView addSubview:dataTF];
    }
    
    UIButton * submintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submintBtn.frame = CGRectMake(10, 380, self.view.frame.size.width-20, 40);
    [submintBtn setTitle:@"提交" forState:UIControlStateNormal];
    submintBtn.layer.cornerRadius = 3;
    submintBtn.layer.masksToBounds = YES;
    [submintBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submintBtn.backgroundColor = nav_bgcolor;
    [submintBtn addTarget:self action:@selector(submitButtonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submintBtn];
}

- (void)submitButtonBeTouch:(id)sender{
    NSString * userid = [UserLoginStatus shareManager].userid;
    //NSArray * tishiArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    NSString * sexnum = @"0";
    if ([[_textfield4.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"女"]) {
        sexnum = @"1";
    }
    
    if (!userid) {
        [[ShowMessageView shareManager] showMessage:@"登录信息出错,请重新登陆"];
    }else if (_textfield1.text.length==0){
        [[ShowMessageView shareManager] showMessage:@"所在城市不能为空"];
    }else if (_textfield2.text.length==0){
        [[ShowMessageView shareManager] showMessage:@"税后收入不能为空"];
    }else if (_textfield3.text.length==0){
        [[ShowMessageView shareManager] showMessage:@"借款金额不能为空"];
    }else if (_textfield4.text.length==0){
        [[ShowMessageView shareManager] showMessage:@"请填写性别"];
    }else if (_textfield5.text.length==0){
        [[ShowMessageView shareManager] showMessage:@"请输入您的真实姓名"];
    }else if (_textfield6.text.length==0){
        [[ShowMessageView shareManager] showMessage:@"手机号不能为空"];
    }else{
    [[HaiHeNetBridge sharedManager] hkLoanAgainRequestWithUserId:userid andWithliveCity:_textfield1.text andWithmonthMoney:_textfield2.text andWithborrowMoney:_textfield3.text andWithSex:sexnum andWithrealName:_textfield5.text andWithphoneNum:_textfield6.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
            if (!respString) {
                UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功，进入人工审核" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelA = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                [alertC addAction:cancelA];
                [self presentViewController:alertC animated:YES completion:nil];

            }else{
                [[ShowMessageView shareManager] showMessage:respString];
            }

    }];
    }
    
    
    
    
    
    
 //    if (!_contrctTF.text.length==0){
//    if (!_contentV.text.length==0) {
//            [[HaiHeNetBridge sharedManager] userFeedbackRequestWithUserId:userid andWithContact:_contrctTF.text andWithContent:_contentV.text WithSuccess:^(NSString *respString, NSDictionary *datadic) {
//                if (!respString) {
//                    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功，进入人工审核" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction * cancelA = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        [self.navigationController popToRootViewControllerAnimated:YES];
//                    }];
//                    [alertC addAction:cancelA];
//                    [self presentViewController:alertC animated:YES completion:nil];
//                    
//                }else{
//                    [[ShowMessageView shareManager] showMessage:respString];
//                }
//            }];
//        }else{
//            [[ShowMessageView shareManager] showMessage:@"借款金额不能为空"];
//        }
//    }else{
//         [[ShowMessageView shareManager] showMessage:@"借款理由不能为空"];
//    }


}

- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length==0){
        _placeholderLabel.hidden = NO;
        
    }else{
        _placeholderLabel.hidden = YES;
        // textView.textColor = [UIColor blackColor];
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
