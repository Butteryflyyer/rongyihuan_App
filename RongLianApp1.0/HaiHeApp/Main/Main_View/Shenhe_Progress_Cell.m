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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
