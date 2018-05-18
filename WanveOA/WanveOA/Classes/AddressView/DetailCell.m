//
//  DetailCell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DetailCell.h"
#import "AddressModel.h"

@implementation DetailCell
{
    UILabel  *_number;
    UILabel  *_type;
    UIButton *_message;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIButton *call = [UIButton buttonWithType:UIButtonTypeCustom];
    [call setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [call addTarget:self action:@selector(callClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:call];
    
    [call mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@44);
    }];
    
    _number = [UILabel new];
    [self.contentView addSubview:_number];
    _number.font = [UIFont systemFontOfSize:17];

    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(call.mas_right).offset(10);
        make.top.equalTo(self).offset(0);
        make.height.equalTo(@32);
    }];
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.textColor = [UIColor lightGrayColor];
    _type.font = [UIFont systemFontOfSize:10];
    
    [_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(call.mas_right).offset(15);
        make.top.equalTo(_number.mas_bottom).offset(0);
        make.height.equalTo(@20);
    }];
    
    _message = [UIButton buttonWithType:UIButtonTypeCustom];
    [_message setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_message addTarget:self action:@selector(messageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_message];
    
    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@44);
    }];

    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(64);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
}

- (void)setModel:(AddressDetailModel *)model
{
    _model = model;

    _number.text = model.number;
    _type.text = model.type;
    
//    if(model.type isEqualToString:@"座机")
}

#pragma mark - clicked

- (void)callClicked:(UIButton *)sender
{
    [_delegate call:_model];
}

- (void)messageClicked:(UIButton *)sender
{
    [_delegate sendMessage:_model];
}

@end

