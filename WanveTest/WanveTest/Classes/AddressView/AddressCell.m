//
//  AddressCell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "AddressCell.h"
#import "AddressModel.h"

@implementation AddressCell
{
    UILabel  *_department;
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
    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"arrow-right-black"];
    [self.contentView addSubview:arrow];
    
    [arrow makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-10);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.centerY);
    }];
    
    _department = [UILabel new];
    [self.contentView addSubview:_department];

    [_department makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.right.equalTo(arrow.left).offset(-10);
        make.centerY.equalTo(self.centerY);
    }];

    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(15);
        make.right.equalTo(self.right).offset(0);
        make.bottom.equalTo(self.bottom).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
}

- (void)setModel:(AddressModel *)model
{
    _model = model;

    _department.text = model.KSName;
}

@end

