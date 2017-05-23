//
//  RechargeSuccessTableViewCell.m
//  HaiHeApp
//
//  Created by 马广召 on 15/11/4.
//  Copyright © 2015年 马广召. All rights reserved.
//
#define W ([UIScreen mainScreen].bounds.size.width)
#import "RechargeSuccessTableViewCell.h"

@implementation RechargeSuccessTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSomeSubViews];
    }
    return  self;
}

- (void)addSomeSubViews{
    _titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, W/2-10, self.frame.size.height/2)];
    _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height/2, W/2-10, self.frame.size.height/2)];
    _titleLabel1.textAlignment = NSTextAlignmentLeft;
    _titleLabel1.font = [UIFont systemFontOfSize:14];
    _titleLabel2.textAlignment = NSTextAlignmentLeft;
    _titleLabel2.font = [UIFont systemFontOfSize:14];
   // _titleLabel1.backgroundColor = [UIColor redColor];
    _detailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(W/2, 0, W/2-10, self.frame.size.height/2)];
    _detailLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(W/2, self.frame.size.height/2, W/2-10, self.frame.size.height/2)];
    _detailLabel1.textAlignment = NSTextAlignmentRight;
    _detailLabel1.font = [UIFont systemFontOfSize:14];
    _detailLabel2.textAlignment = NSTextAlignmentRight;
    _detailLabel2.font = [UIFont systemFontOfSize:14];
    //_detailLabel1.backgroundColor = [UIColor redColor];
    [self addSubview:_titleLabel1];
    [self addSubview:_titleLabel2];
    [self addSubview:_detailLabel1];
    [self addSubview:_detailLabel2];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
