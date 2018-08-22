//
//  DepartmentCell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DepartmentCell.h"
#import "AddressModel.h"
#import "UIImage+image.h"

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
    logo.image = [UIImage imageWithName:@"user-logo"];
    [self.contentView addSubview:logo];
    
    [logo makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.centerY);
    }];
    
    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageWithName:@"arrow-right-black"];
    [self.contentView addSubview:arrow];
    
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.centerY);
    }];
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    
    [_name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.right).offset(15);
        make.right.equalTo(arrow.right).offset(-15);
        make.centerY.equalTo(self.centerY);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name.left);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
}

- (void)setModel:(UserListModel *)model
{
    _model = model;

    _name.text = model.UserName;
}

@end

