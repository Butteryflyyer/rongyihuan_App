//
//  HuankuanList_Cell.m
//  HaiHeApp
//
//  Created by 信昊 on 17/5/25.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "HuankuanList_Cell.h"

@interface HuankuanList_Cell ()
@property (weak, nonatomic) IBOutlet UILabel *Qishu_Count;
@property (weak, nonatomic) IBOutlet UILabel *HuanKuan_Day;
@property (weak, nonatomic) IBOutlet UILabel *BenJin_count;

@property (weak, nonatomic) IBOutlet UILabel *QitaMoney_Count;
@property (weak, nonatomic) IBOutlet UILabel *Fuwu_Count;
@property (weak, nonatomic) IBOutlet UILabel *YiyongAll_count;
@end

@implementation HuankuanList_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//if (j==0) {
//    topl.text = [NSString stringWithFormat:@"本金: %@",listObj.bj];
//}else if (j==1){
//    topl.text = [NSString stringWithFormat:@"服务费用: %@",listObj.fwf];
//}else if (j==2){
//    topl.text = [NSString stringWithFormat:@"其他费用: %@",listObj.qtfy];
//}else if (j==3){
//    topl.text = [NSString stringWithFormat:@"应还总额: %@",listObj.yhze];
//    topl.textColor = [UIColor blackColor];
//}

-(void)setListObj:(BackMoneyObj *)listObj{
    _listObj = listObj;
    
    self.BenJin_count.text = [NSString stringWithFormat:@"%@",listObj.bj];
    self.QitaMoney_Count.text =[NSString stringWithFormat:@"%@",listObj.qtfy] ;
    self.Fuwu_Count.text = [NSString stringWithFormat:@"%@",listObj.fwf];
    self.YiyongAll_count.text = [NSString stringWithFormat:@"%@",listObj.yhze];
    self.HuanKuan_Day.text =[NSString stringWithFormat:@"%@",listObj.hkrq];
//   self.Qishu_Count.text = [NSString stringWithFormat:@"期数:%@",listObj.qs];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"期数: %@",listObj.qs]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4, str1.length-4)];
    self.Qishu_Count.attributedText = str1;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
