//
//  RightButtonTableViewCell.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/10.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "RightButtonTableViewCell.h"
#import "HaiheHeader.h"
@implementation RightButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addSomeSubViews];
    }
    return self;
    
}

- (void)addSomeSubViews{
    _titleTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-self.frame.size.height-20, self.frame.size.height)];
    _titleTextfield.font = [UIFont systemFontOfSize:15];
    //_titleTextfield.backgroundColor = [UIColor redColor];
    [self addSubview:_titleTextfield];
    
    _timeLable = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0, 30, self.frame.size.height)];
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.font = [UIFont systemFontOfSize:14];
    _timeLable.textColor = nav_bgcolor;
    [self addSubview:_timeLable];
    
    _getcodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getcodeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-90, 0, 90, self.frame.size.height);
    //_getcodeBtn.backgroundColor = [UIColor redColor];
    [_getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];

    _getcodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getcodeBtn setTitleColor:nav_bgcolor forState:UIControlStateNormal];
    [_getcodeBtn setTitleColor:nav_bgcolor forState:UIControlStateSelected];
    _getcodeBtn.titleLabel.textColor = nav_bgcolor;
    //[_getcodeBtn addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_getcodeBtn];
    
}

//- (void)clearTextField:(UIButton *)sender{
//    _titleTextfield.text = @"";
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
