//
//  SinglePickerCell.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SinglePickerCell.h"
#import "UIImage+image.h"
#import "UIColor+color.h"

@interface SinglePickerCell ()

@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *line;

@end

@implementation SinglePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat labW = 150;
    CGFloat x = 20;

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, labW, 60)];
    [self.contentView addSubview:lab];
    [lab setFont:[UIFont systemFontOfSize:18]];
    [lab setTextColor:GrayColor];
    self.lab = lab;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x + labW, 0, SCREEN_WIDTH - 2.0*x - labW, 60);
    [self.contentView addSubview:btn];
    [btn setTitle:@"未选择" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.btn = btn;
    
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(x, 59, SCREEN_WIDTH - 2.0*x, 1)];
    [self.contentView addSubview:_line];
    [_line setBackgroundColor:LineColor];
}

- (void)btnClicked:(UIButton *)sender
{
    [_delegate didSinglePickerCellBtnClicked:_key];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    
    if([value isEqualToString:@""] || [value isEqualToString:@"不选择"])
    {
        [self.btn setTitle:@"未选择" forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btn setTitle:value forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)setKey:(NSString *)key
{
    _key = key;
    self.lab.text = key;
}


@end
