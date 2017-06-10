//
//  Shenhe_Progress_Cell.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/9.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "Shenhe_Progress_Cell.h"

@interface Shenhe_Progress_Cell ()

@property (weak, nonatomic) IBOutlet UIImageView *chushen_image;

@property (weak, nonatomic) IBOutlet UIImageView *zhongshen_image;

@property (weak, nonatomic) IBOutlet UIImageView *qianyue_image;
@property (weak, nonatomic) IBOutlet UIImageView *fangkuan_image;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chushenToZhongshen_const;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fangkuanToQianyue_const;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiantou_chushen_const;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiantou_fangkuan;
@property (weak, nonatomic) IBOutlet UILabel *Shenqing_Time_Label;
@property (weak, nonatomic) IBOutlet UILabel *Shenqing_jine_label;

@end

@implementation Shenhe_Progress_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat Anniu_Gap = (SCREEN_WIDTH - 40 - 4*47)/3;
    CGFloat jiantou_Gap;
    self.chushenToZhongshen_const.constant = Anniu_Gap;
    self.fangkuanToQianyue_const.constant = Anniu_Gap;
    if (SCREEN_HEIGHT > IPHONE6 ) {
        jiantou_Gap = 10;
        
    }else if(SCREEN_HEIGHT <= IPHONE6 && SCREEN_HEIGHT > IPHONE5s ){
        jiantou_Gap = 8;
    }else{
        
        jiantou_Gap = 5;
    }
    self.jiantou_chushen_const.constant = jiantou_Gap;
    self.jiantou_fangkuan.constant = jiantou_Gap;
    
    // Initialization code
}
// 0  灰色 1 绿色   2 红色
-(void)setShenheModel:(Shenhe_Model *)shenheModel{
    _shenheModel = shenheModel;
    switch ([shenheModel.one integerValue]) {
        case 0:
            self.chushen_image.image = IMG(@"初审-灰");
            break;
        case 1:
            self.chushen_image.image = IMG(@"初审-绿");
            break;
        case 2:
            self.chushen_image.image = IMG(@"初审-红");
            break;
        default:
             self.chushen_image.image = IMG(@"初审-灰");
            break;
    }
    switch ([shenheModel.two integerValue]) {
        case 0:
            self.zhongshen_image.image = IMG(@"终审-灰");
            break;
        case 1:
            self.zhongshen_image.image = IMG(@"终审-绿");
            break;
        case 2:
            self.zhongshen_image.image = IMG(@"终审-红");
            break;
        default:
             self.zhongshen_image.image = IMG(@"终审-灰");
            break;
    }
    switch ([shenheModel.three integerValue]) {
        case 0:
            self.qianyue_image.image = IMG(@"签约-灰");
            break;
        case 1:
            self.qianyue_image.image = IMG(@"签约-绿");
            break;
        case 2:
            self.qianyue_image.image = IMG(@"签约-红");
            break;
        default:
            self.qianyue_image.image = IMG(@"签约-灰");
            break;
    }
    switch ([shenheModel.four integerValue]) {
        case 0:
            self.fangkuan_image.image = IMG(@"放款-灰");
            break;
        case 1:
            self.fangkuan_image.image = IMG(@"放款-绿");
            break;
        case 2:
            self.fangkuan_image.image = IMG(@"放款-红");
            break;
        default:
            self.fangkuan_image.image = IMG(@"放款-灰");
            break;
    }
    self.Shenqing_Time_Label.text = [NSString stringWithFormat:@"申请时间: %@",shenheModel.ApplyDate];
    self.Shenqing_jine_label.text = [NSString stringWithFormat:@"申请金额: %@",shenheModel.money];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
