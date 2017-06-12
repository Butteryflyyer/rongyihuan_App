//
//  FourLabelsTableViewCell.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/12.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "FourLabelsTableViewCell.h"
#define W ([UIScreen mainScreen].bounds.size.width)
@implementation FourLabelsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addSomeSubViews];
    }
    return self;
}

- (void)addSomeSubViews{
        for (int i=0; i<4; i++) {
            UILabel * dateL = [[UILabel alloc] initWithFrame:CGRectMake(W/4*i, 0, W/4, 80)];
            dateL.tag = 1000+i;
            //dateL.text = @"2015-11-11 12:12:12";
            dateL.numberOfLines = 2;
            dateL.font = [UIFont systemFontOfSize:12];
            dateL.textAlignment = NSTextAlignmentCenter;
            dateL.textColor = [UIColor lightGrayColor];
            [self addSubview:dateL];
        }
}

- (void)setRechargeobject:(RechargeObj *)rechargeobject{
    
    for (int i=0; i<4; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:1000+i];
        if(i==0){
            label.text = rechargeobject.txTime;
        }else if (i==1){
            label.text = rechargeobject.czje;
        }else if (i==2){
            
            if ([UIScreen mainScreen].bounds.size.height<667) {
                
                label.font = [UIFont systemFontOfSize:11];
            }else if ([UIScreen mainScreen].bounds.size.height>667){
                
            }
            label.text = rechargeobject.liushuihao;
        }else if (i==3){
            label.text = rechargeobject.czjg;
        }else{
            
        }
    }
}

//- (void)setFunddetaiobject:(FundDetailObj *)funddetaiobject{
//    
//    for (int i=0; i<4; i++) {
//        UILabel * label = (UILabel *)[self viewWithTag:1000+i];
//        if(i==0){
//            label.text = funddetaiobject.shijian;
//        }else if (i==1){
//            label.text = funddetaiobject.leixing;
//        }else if (i==2){
//            if ([[funddetaiobject.zijin substringToIndex:1] isEqualToString:@"+"]) {
//                //label.textColor = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1];
//                label.textColor = [UIColor colorWithRed:62/255.0 green:163/255.0 blue:254/255.0 alpha:1];
//            }else{
//                label.textColor = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1];
//            }
//
//            label.text = funddetaiobject.zijin;
//        }else if (i==3){
//            label.text = funddetaiobject.zhye;
//        }else{
//        
//        }
//    }
//}

//- (void)setWithdrawrecordobject:(WithDrawRecordObj *)withdrawrecordobject{
//    for (int i=0; i<4; i++) {
//        UILabel * label = (UILabel *)[self viewWithTag:1000+i];
//        if(i==0){
//            label.text = withdrawrecordobject.txTime;
//        }else if (i==1){
//            label.text = withdrawrecordobject.txje;
//        }else if (i==2){
//            label.text = withdrawrecordobject.txzt;
//        }else if (i==3){
//            label.text = withdrawrecordobject.bankNo;
//        }else{
//            
//        }
//    }
//
//}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
