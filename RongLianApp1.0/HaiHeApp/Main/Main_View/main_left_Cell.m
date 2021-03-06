//
//  main_left_Cell.m
//  HaiHeApp
//
//  Created by 信昊 on 17/6/8.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import "main_left_Cell.h"

@interface main_left_Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *left_Image;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@end

@implementation main_left_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIndexPath:(NSIndexPath *)IndexPath{
    _IndexPath = IndexPath;
    
    if (IndexPath.section == 0) {
        self.TitleLabel.text = @"审批进度";
        self.left_Image.image = [UIImage imageNamed:@"侧滑_进度"];
    }
    if (IndexPath.section == 1) {
        self.TitleLabel.text = @"还款计划";
        self.left_Image.image = [UIImage imageNamed:@"侧滑_计划"];
    }
    if (IndexPath.section == 2) {
        self.TitleLabel.text = @"设置";
        self.left_Image.image = [UIImage imageNamed:@"侧滑_设置"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
