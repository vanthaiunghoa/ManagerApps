//
//  DoublePickerCell.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "DoublePickerCell.h"
#import "UIImage+image.h"
#import "UIColor+color.h"

@interface DoublePickerCell ()

@property (nonatomic, strong) UIButton *btnBegin;
@property (nonatomic, strong) UIButton *btnEnd;
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIView *line;

@end

@implementation DoublePickerCell

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
    CGFloat btnW = 120;
    CGFloat middleLabW = 40;
    CGFloat x = 20;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, labW, 60)];
    [self.contentView addSubview:lab];
    [lab setTextColor:GrayColor];
    [lab setFont:[UIFont systemFontOfSize:18]];
    self.lab = lab;
    
    UIButton *btnBegin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBegin.frame = CGRectMake(SCREEN_WIDTH - x - 2.0*btnW - middleLabW, 0, btnW, 60);
    [self.contentView addSubview:btnBegin];
    btnBegin.tag = 0;
    [btnBegin setTitle:@"未选择" forState:UIControlStateNormal];
    [btnBegin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnBegin.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.btnBegin = btnBegin;
    
    [btnBegin addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labMiddle = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - x - btnW - middleLabW, 0, middleLabW, 60)];
    [self.contentView addSubview:labMiddle];
    [labMiddle setFont:[UIFont systemFontOfSize:18]];
    [labMiddle setTextAlignment:NSTextAlignmentCenter];
    labMiddle.text = @"至";

    UIButton *btnEnd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnd.frame = CGRectMake(SCREEN_WIDTH - x - btnW, 0, btnW, 60);
    [self.contentView addSubview:btnEnd];
    [btnEnd setTitle:@"未选择" forState:UIControlStateNormal];
    [btnEnd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnEnd.tag = 1;
    [btnEnd.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.btnEnd = btnEnd;
    
    [btnEnd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//    _line = [[UIView alloc] initWithFrame:CGRectMake(x, 59, SCREEN_WIDTH - 2.0*x, 1)];
//    [self.contentView addSubview:_line];
//    [_line setBackgroundColor:LineColor];
}

- (void)btnClicked:(UIButton *)sender
{
    [_delegate didDoublePickerCellBtnClicked:sender.tag];
}

- (void)setKey:(NSString *)key
{
    _key = key;
    [self.lab setText:key];
}

- (void)setBeginTime:(NSString *)beginTime
{
    _beginTime = beginTime;
    if([beginTime isEqualToString:@""])
    {
        [self.btnBegin setTitle:@"未选择" forState:UIControlStateNormal];
        [self.btnBegin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnBegin setTitle:beginTime forState:UIControlStateNormal];
        [self.btnBegin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)setEndTime:(NSString *)endTime
{
    _endTime = endTime;
    if([endTime isEqualToString:@""])
    {
        [self.btnEnd setTitle:@"未选择" forState:UIControlStateNormal];
        [self.btnEnd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnEnd setTitle:endTime forState:UIControlStateNormal];
        [self.btnEnd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}


@end
