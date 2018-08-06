//
//  SelectHeaderView.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SelectHeaderView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "Organization.h"

@implementation SelectHeaderView
{
    UILabel *_labName;
    UIImageView *_expand;
    UIButton *_btnRead;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor colorWithRGB:241 green:248 blue:252];
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat margin = 20;

    _labName = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - 90, 60)];
    [self.contentView addSubview:_labName];
    [_labName setFont:[UIFont systemFontOfSize:20]];
    
    _expand = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - margin - 20, 20, 20, 20)];
    [self.contentView addSubview:_expand];
    _expand.image = [UIImage imageNamed:@"unexpand"];

    _btnRead = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRead.frame = CGRectMake(SCREEN_WIDTH - 50 - 40, 10, 40, 40);
    [self.contentView addSubview:_btnRead];
    [_btnRead.layer setCornerRadius:20];
    [_btnRead.layer setMasksToBounds:YES];
    
    [_btnRead setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:241 green:248 blue:252]] forState:UIControlStateNormal];
    [_btnRead setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:153 green:153 blue:153]] forState:UIControlStateSelected];
    
    [_btnRead setTitle:@"阅" forState:UIControlStateNormal];
    [_btnRead setTitleColor:[UIColor colorWithRGB:153 green:153 blue:153] forState:UIControlStateNormal];
    [_btnRead setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_btnRead.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_btnRead addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    [self.contentView addSubview:line];
    [line setBackgroundColor:LineColor];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:tap];
}

#pragma mark - clicked

- (void)expandTap:(UITapGestureRecognizer *)tap
{
    _model.isExpand = !_model.isExpand;
    if(_model.isExpand)
    {
        _expand.image = [UIImage imageNamed:@"expand"];
    }
    else
    {
        _expand.image = [UIImage imageNamed:@"unexpand"];
    }
    
    [_delegate didSelectIndexPath:_indexPath];
}

- (void)btnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _model.isSelect = sender.selected;
    
    [_delegate didSelectRead:_indexPath];
}

#pragma mark - setData

- (void)setModel:(Organization *)model
{
    _model = model;
    _labName.text = model.KSName;
    
    if(model.isExpand)
    {
        _expand.image = [UIImage imageNamed:@"expand"];
    }
    else
    {
        _expand.image = [UIImage imageNamed:@"unexpand"];
    }
    
    _btnRead.selected = model.isSelect;
}


@end
