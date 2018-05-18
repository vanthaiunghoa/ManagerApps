//
//  DepartmentCell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DepartmentCell.h"
#import "AddressModel.h"

@implementation DepartmentCell
{
    UILabel  *_name;
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
    UIImageView *logo = [UIImageView new];
    logo.image = [UIImage imageNamed:@"user-logo"];
    [self.contentView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"arrow-right-black"];
    [self.contentView addSubview:arrow];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(15);
        make.right.equalTo(arrow.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name.mas_left);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
}

- (void)setModel:(UserListModel *)model
{
    _model = model;

    _name.text = model.UserName;
}

@end

