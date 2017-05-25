//
//  RootTableViewCell.m
//  HaiHeApp
//
//  Created by 马广召 on 16/3/3.
//  Copyright © 2016年 马广召. All rights reserved.
//

#define W ([UIScreen mainScreen].bounds.size.width)

#import "RootTableViewCell.h"
#import "HaiheHeader.h"

@interface RootTableViewCell()
@property (nonatomic, retain)UILabel * qishuLabel;
@end

@implementation RootTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addSomeSubViews];
    }
    return self;
}


- (void)addSomeSubViews{
    
    
    UILabel * qishutitleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 60, 25)];
    qishutitleL.text = @"期数";
    qishutitleL.textAlignment = NSTextAlignmentCenter;
    qishutitleL.font = [UIFont systemFontOfSize:13];
    //qishutitleL.backgroundColor = [UIColor redColor];
    [self addSubview:qishutitleL];
    UILabel * qishuL = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 60, 25)];
    //qishuL.text = @"1";
    _qishuLabel = qishuL;
    qishuL.textAlignment = NSTextAlignmentCenter;
    qishuL.textColor = [UIColor lightGrayColor];
    qishuL.font = [UIFont systemFontOfSize:13];
    //qishuL.backgroundColor = [UIColor greenColor];
    [self addSubview:qishuL];
    
    UIView * shulineL = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 0.5, 150)];
    shulineL.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:shulineL];
    
    UIView * henglineL = [[UIView alloc] initWithFrame:CGRectMake(60, 45,W-60, 0.5)];
    henglineL.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:henglineL];
    
    //列表项
    
    for (int i=0; i<2; i++) {
        UILabel * topL = [[UILabel alloc] initWithFrame:CGRectMake(70+(W-80)/2*i, 0, 200, 45)];
        //topL.text = @"回款日  2015-09-10";
        topL.tag = 1000+i;
        topL.font = [UIFont systemFontOfSize:13];
        topL.textAlignment = NSTextAlignmentRight;
        if (i==0) {
            topL.textAlignment = NSTextAlignmentLeft;
        }
        [self addSubview:topL];
    }
    
    for (int i=0; i<2; i++) {
        for (int j=0; j<2; j++) {
            UILabel * bottomL = [[UILabel alloc] initWithFrame:CGRectMake(70+(W-80)/2*j, 50+25*i, (W-80)/2, 25)];
            bottomL.tag = 2000+i*2+j*1;
            //bottomL.text = @"回款日  2015-09-10";
            bottomL.font = [UIFont systemFontOfSize:13];
            bottomL.textAlignment = NSTextAlignmentRight;
            if (j==0) {
                bottomL.textAlignment = NSTextAlignmentLeft;
            }
            [self addSubview:bottomL];
        }
    }
    RedPacketButton * button = [RedPacketButton buttonWithType:UIButtonTypeCustom];
    _button = button;
    button.frame = CGRectMake(90, 105, W-120, 35);
    //button.backgroundColor = [UIColor redColor];
    [button setTitle:@"还款" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.imageView.hidden = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    //[button addTarget:self action:@selector(buttonBeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

//- (void)buttonBeTouch:(RedPacketButton *)sender{
//    [[ShowMessageView shareManager] showMessage:sender.descriptionStr];
//}

- (void)setListObj:(BackMoneyObj *)listObj{
//    _qishuLabel.text = listObj.qs;
//    _button.descriptionStr = listObj.proid;
//    _button.moneyStr = listObj.yhze;
    _button.enabled = YES;
    
    int ztcode = [listObj.ztcode intValue];
    
    for (int i=0; i<2; i++) {
        UILabel * topl = (UILabel *)[self viewWithTag:1000+i];
        if (i==0) {
            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还款日: %@",listObj.hkrq]];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4, str1.length-4)];
            topl.attributedText = str1;
            //topl.text = [NSString stringWithFormat:@"还款日:%@",listObj.hkrq];
        }else if (i==1){
//            NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"状态: %@",listObj.zt]];
//            if (ztcode==3){
//            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
//            [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(3, str1.length-3)];
//            topl.attributedText = str1;
//            }else{
//                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 2)];
//                [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, str1.length-3)];
//                topl.attributedText = str1;
//            }
            //topl.text = [NSString stringWithFormat:@"状态:%@",listObj.zt];
        }
    }
    
    for (int j=0; j<4; j++) {
        UILabel * topl = (UILabel *)[self viewWithTag:2000+j];
        topl.textColor = [UIColor lightGrayColor];
        if (j==0) {
            topl.text = [NSString stringWithFormat:@"本金: %@",listObj.bj];
        }else if (j==1){
            topl.text = [NSString stringWithFormat:@"服务费用: %@",listObj.fwf];
        }else if (j==2){
            topl.text = [NSString stringWithFormat:@"其他费用: %@",listObj.qtfy];
        }else if (j==3){
            topl.text = [NSString stringWithFormat:@"应还总额: %@",listObj.yhze];
            topl.textColor = [UIColor blackColor];
        }
    }
    //还款按钮;
//    int ztcode = [listObj.ztcode intValue];
    switch (ztcode) {
        case 0:{
            [_button setTitle:@"逾期" forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _button.backgroundColor = [UIColor lightGrayColor];
            _button.imageView.hidden = YES;
            _button.enabled = NO;
        }
            break;
        case 3:{
//            [_button setTitle:@"已还款" forState:UIControlStateNormal];
//            [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            _button.backgroundColor = [UIColor lightGrayColor];
//            _button.imageView.hidden = YES;
//            _button.enabled = NO;
        }
            break;
            
        default:
        {
            [_button setTitle:@"还款" forState:UIControlStateNormal];
            [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _button.layer.borderColor = [UIColor redColor].CGColor;
            _button.backgroundColor = [UIColor clearColor];
            _button.imageView.hidden = YES;
            _button.enabled = YES;
            
        }

            break;
    }
    
//    if ([listObj.zt isEqualToString:@"已还款"]) {
//        [_button setTitle:@"已还款" forState:UIControlStateNormal];
//        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////        _button.layer.cornerRadius = 3;
////        _button.layer.masksToBounds = YES;
////        _button.layer.borderWidth = 1;
//        _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _button.backgroundColor = [UIColor lightGrayColor];
//        _button.imageView.hidden = YES;
//        _button.enabled = NO;
//
//    }else{
//        [_button setTitle:@"还款" forState:UIControlStateNormal];
//        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        //        _button.layer.cornerRadius = 3;
//        //        _button.layer.masksToBounds = YES;
//        //        _button.layer.borderWidth = 1;
//        _button.layer.borderColor = [UIColor redColor].CGColor;
//        _button.backgroundColor = [UIColor clearColor];
//        _button.imageView.hidden = YES;
//        _button.enabled = YES;
//
//    }
    
}

@end
