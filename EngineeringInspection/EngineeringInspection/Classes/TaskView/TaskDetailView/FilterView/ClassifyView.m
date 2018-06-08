//
//  ClassifyView.m
//  EngineeringInspection
//
//  Created by wanve on 2018/5/29.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "ClassifyView.h"
#import "UIColor+color.h"

@interface ClassifyView ()

@property (nonatomic, strong) UIButton *btnAll;
@property (nonatomic, strong) UIDatePicker *pickerView;

@end

@implementation ClassifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - init

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (void)setDetailArray:(NSArray *)detailArray
{
    _detailArray = detailArray;
    CGFloat y = 10;
    CGFloat margin = 15;
    CGFloat btnH = 30;
    CGFloat x = 10;
    CGRect frame = self.frame;
    CGFloat btnW = 60;
    CGFloat labW = frame.size.width - 2*x - btnW;
    CGFloat labH = 50;
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:(CGRectMake(x, y, labW, labH))];
    [labTitle setText:_title];
    [labTitle setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:labTitle];
    
    if([_title isEqualToString:@"整改日期"])
    {
        y += labH;
        btnW = (frame.size.width - 2.0*margin - 20)/2.0;
        for(int i = 0; i < _detailArray.count; ++i)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(x, y, btnW, btnH)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:_detailArray[i] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
            [btn.layer setCornerRadius:10];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            btn.tag = i;
            [self addSubview:btn];
            [self.btnArray addObject:btn];
            
            [btn addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            x += btnW + 2.0*margin;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(FilterViewWidth/2.0 - 5, y + btnH/2.0, 10, 1)];
        line.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:line];
    }
    else
    {
        _btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAll setFrame:CGRectMake(frame.size.width - x - btnW, (labH - btnH)/2.0, btnW, btnH)];
        [_btnAll setTitle:@"全部" forState:UIControlStateNormal];
        [_btnAll.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_btnAll.layer setCornerRadius:10];
        _btnAll.selected = NO;
        [_btnAll setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:_btnAll];
        
        [_btnAll addTarget:self action:@selector(allClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        y += labH;
        btnW = (frame.size.width - 2.0*margin - 20)/3.0;
        for(int i = 0; i < _detailArray.count; ++i)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(x, y, btnW, btnH)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:_detailArray[i] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
            [btn.layer setCornerRadius:10];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            btn.selected = NO;
            //        btn.tag = i;
            [self addSubview:btn];
            [self.btnArray addObject:btn];
            
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            x += btnW + margin;
        }
    }
}

#pragma mark - clicked

- (void)allClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.isSelected)
    {
        [sender setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self selectedAll:YES];
    }
    else
    {
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self selectedAll:NO];
    }
}

- (void)btnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.isSelected)
    {
        [sender setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if([self isAllSelected])
        {
            [_btnAll setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
            [_btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnAll.selected = YES;
        }
    }
    else
    {
        [sender setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(_btnAll.isSelected)
        {
            [_btnAll setBackgroundColor:[UIColor whiteColor]];
            [_btnAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _btnAll.selected = NO;
        }
    }
}

- (void)dateClicked:(UIButton *)sender
{
    
}

#pragma mark - pravite

- (void)selectedAll:(BOOL )isAll
{
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if(isAll)
        {
            [btn setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        btn.selected = isAll;
    }];
}

- (BOOL)isAllSelected
{
    __block BOOL isAll = YES;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if(!btn.isSelected)
        {
            isAll = NO;
        }
    }];
    
    return isAll;
}

#pragma mark - lazy load

- (NSMutableArray *)btnArray
{
    if(_btnArray == nil)
    {
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (UIDatePicker *)_pickerView
{
    if(_pickerView == nil)
    {
        _pickerView = [[UIDatePicker alloc] init];
        [_pickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        [_pickerView setCalendar:[NSCalendar currentCalendar]];
        [_pickerView setDate:[NSDate date]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:1];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setDay:0];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [_pickerView setMaximumDate:maxDate];
        [_pickerView setMinimumDate:minDate];
//        [_pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
        [_pickerView addTarget:self action:@selector(datePicker:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pickerView];
    }
    
    return _pickerView;
}

#pragma mark - picker

- (void)datePicker:(UIDatePicker *)date
{
    PLog(@"date == %@", date.date);
}


@end
