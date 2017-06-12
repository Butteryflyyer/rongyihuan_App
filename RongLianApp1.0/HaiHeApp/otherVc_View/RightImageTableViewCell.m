//
//  RightImageTableViewCell.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/10.
//  Copyright © 2015年 马广召. All rights reserved.
//

#import "RightImageTableViewCell.h"

@interface RightImageTableViewCell()

@property (nonatomic, retain)UIButton * deleteBtn;

@end

@implementation RightImageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addSomeSubViews];
    }
    return self;

}

- (void)addSomeSubViews{
    _titleTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-self.frame.size.height, self.frame.size.height)];
    _titleTextfield.font = [UIFont systemFontOfSize:15];
    _titleTextfield.delegate = self;
    //_titleTextfield.backgroundColor = [UIColor redColor];
    [self addSubview:_titleTextfield];

    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn = deleteBtn;
    deleteBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-self.frame.size.height-10, 0, self.frame.size.height, self.frame.size.height);
    //deleteBtn.imageView.backgroundColor = [UIColor lightGrayColor];
    deleteBtn.hidden = YES;
    [deleteBtn setImage:[UIImage imageNamed:@"deletebtn"] forState:UIControlStateNormal];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [deleteBtn addTarget:self action:@selector(clearTextField:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location>0) {
        _deleteBtn.hidden = NO;
    }else{
        _deleteBtn.hidden = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)clearTextField:(UIButton *)sender{
    _titleTextfield.text = @"";
    sender.hidden = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
