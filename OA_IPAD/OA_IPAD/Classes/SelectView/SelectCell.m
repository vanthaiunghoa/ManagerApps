//
//  SelectCell.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SelectCell.h"
#import "UIImage+image.h"
#import "UIColor+color.h"
#import "Personel.h"

@interface SelectCell ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArr;
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIView *line;

@end

@implementation SelectCell

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
    CGFloat h = 40;
    CGFloat margin = 50;
    CGFloat x = SCREEN_WIDTH - margin - h;
    CGFloat btnMargin = 25;
    
    NSArray *arr = @[@"阅", @"协", @"主", @"批"];
    for(int i = 0; i < arr.count; ++i)
    {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, h, h)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, 10, h, h);
        [self.contentView addSubview:btn];
        btn.tag = i;
        [btn.layer setCornerRadius:20];
        [btn.layer setMasksToBounds:YES];
        
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        if(0 == i)
        {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:153 green:153 blue:153]] forState:UIControlStateSelected];
        }
        else if(1 == i)
        {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:91 green:194 blue:203]] forState:UIControlStateSelected];
        }
        else if(2 == i)
        {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:236 green:170 blue:92]] forState:UIControlStateSelected];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:251 green:101 blue:100]] forState:UIControlStateSelected];
        }
            
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRGB:153 green:153 blue:153] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        btn.selected = NO;
        [self.btnArr addObject:btn];
        
        x -= h + btnMargin;
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, x - margin, 60)];
    [self.contentView addSubview:lab];
    [lab setFont:[UIFont systemFontOfSize:18]];
    self.lab = lab;
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(50, 59, SCREEN_WIDTH - 100, 1)];
    [self.contentView addSubview:_line];
    [_line setBackgroundColor:LineColor];
}

- (void)btnClicked:(UIButton *)sender
{
    for(int i = 0; i < self.btnArr.count; ++i)
    {
        if(sender.tag != i)
        {
            self.btnArr[i].selected = NO;
        }
    }
    
    sender.selected = !sender.selected;
    if(sender.isSelected)
    {
        _model.selectMode = sender.tag;
    }
    else
    {
        _model.selectMode = SelectNone;
    }
    
    [_delegate updateDepartmentSelectStatus:self.indexPath];
}

- (NSMutableArray<UIButton *> *)btnArr
{
    if(_btnArr == nil)
    {
        _btnArr = [NSMutableArray array];
    }
    
    return _btnArr;
}

- (void)setModel:(Personel *)model
{
    _model = model;
    self.lab.text = model.UserName;
    
    for(int i = 0; i < self.btnArr.count; ++i)
    {
        self.btnArr[i].selected = NO;
    }
    
    if(model.selectMode != SelectNone)
    {
        self.btnArr[model.selectMode].selected = YES;
    }
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

@end
