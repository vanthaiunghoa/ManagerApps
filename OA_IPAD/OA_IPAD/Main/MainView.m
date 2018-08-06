//
//  MainView.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/5.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MainView.h"
#import "UIColor+color.h"

@interface MainView()

@property (nonatomic, strong) UILabel *labHello;
@property (nonatomic, strong) UILabel *labName;

@end

@implementation MainView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bkg = [UIImageView new];
        bkg.image = [UIImage imageNamed:@"main-bkg"]; // 大图耗内存
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"main-bkg"];
//    bkg.image = [UIImage imageWithContentsOfFile:path];
    [self addSubview:bkg];
    [bkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@285);
    }];
    
    UIButton *setup = [UIButton buttonWithType:UIButtonTypeCustom];
    [setup setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
//    [setup setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self addSubview:setup];
    [setup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-23);
        make.top.equalTo(self.mas_top).offset(44);
        make.width.height.equalTo(@32);
    }];

    [setup addTarget:self action:@selector(logoutClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *user = [UIImageView new];
    user.image = [UIImage imageNamed:@"logo-user"]; // 大图耗内存
    [bkg addSubview:user];
    [user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bkg.mas_left).offset(24);
        make.width.height.equalTo(@122);
        make.bottom.equalTo(bkg.mas_bottom).offset(-62);
    }];
    
    UILabel *labHello = [UILabel new];
//    [labHello setText:@"您好！"];
    [labHello setTextColor:[UIColor whiteColor]];
    [labHello setFont:[UIFont systemFontOfSize:44]];
    [bkg addSubview:labHello];
    [labHello mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(user.mas_right).offset(18);
        make.right.equalTo(bkg.mas_right).offset(-24);
        make.top.equalTo(user.mas_top);
        make.height.equalTo(@61);
    }];
    self.labHello = labHello;
    
    UILabel *labName = [UILabel new];
//    [labName setText:@"您好啊啊啊啊！"];
    [labName setTextColor:[UIColor whiteColor]];
    [labName setFont:[UIFont systemFontOfSize:44]];
    [bkg addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labHello.mas_left);
        make.right.equalTo(labHello.mas_right);
        make.bottom.equalTo(user.mas_bottom);
        make.height.equalTo(@61);
    }];
    
    self.labName = labName;

    CGFloat btnH = 260;
    CGFloat btnW = 130;
    CGFloat marginL = 74;
    CGFloat margin = (SCREEN_WIDTH - btnW*3 - marginL*2)/2.0;
    NSArray *titles = @[@"办理", @"检索"];
    
    CGFloat marginViewH = 80;
    CGFloat y = 285;
    for(int i = 0; i < titles.count; ++i)
    {
        UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, marginViewH)];
        [marginView setBackgroundColor:[UIColor colorWithRGB:246 green:246 blue:246]];
        [self addSubview:marginView];
        
        UIImageView *imageView = [UIImageView new];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i+7]]];
        [marginView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(marginView.mas_left).offset(23);
            make.centerY.equalTo(marginView.mas_centerY);
            make.width.equalTo(@7);
            make.height.equalTo(@31);
        }];
        
        UILabel *lab = [UILabel new];
        [lab setText:titles[i]];
        [lab setTextColor:[UIColor colorWithRGB:48 green:48 blue:48]];
        [lab setFont:[UIFont systemFontOfSize:34]];
        [marginView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(15);
            make.right.equalTo(marginView.mas_right).offset(-80);
            make.centerY.equalTo(marginView.mas_centerY);
            make.height.equalTo(@31);
        }];

        y += marginViewH + btnH;
    }
    
    NSArray *items = @[@"收文办理", @"发文办理", @"开始会议", @"收文检索", @"发文检索"];
    
    CGFloat x = 0;
    y = 285 + 80;
    for(int i = 0; i < items.count; ++i)
    {
        if(0 == i || 3 == i)
        {
            x = marginL;
        }
        else if(1 == i || 4 == i)
        {
            x = marginL + btnW + margin;
        }
        else
        {
            x = SCREEN_WIDTH - marginL - btnW;
        }
        
        if(i%3 == 0 && i != 0)
        {
            y += btnH + marginViewH;
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, btnW, btnH)];
        btn.tag = i;
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(indexClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [UIImageView new];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
        [btn addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_top).offset(43);
            make.centerX.equalTo(btn.mas_centerX);
            make.width.height.equalTo(@114);
        }];
        
        UILabel *lab = [UILabel new];
        [lab setText:items[i]];
        [lab setTextColor:[UIColor colorWithRGB:48 green:48 blue:48]];
        [lab setFont:[UIFont systemFontOfSize:30]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [btn addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(28);
            make.left.right.equalTo(btn);
            make.bottom.equalTo(btn.mas_bottom).offset(-42);
        }];
    }
    
    return self;
}

- (void)reloadData:(NSString *)name
{
    [self.labName setText:name];
}

- (void)reloadHello
{
    [self.labHello setText:[self getTheTimeBucket]];
}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];

    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

//获取时间段
-(NSString *)getTheTimeBucket
{
    //    NSDate * currentDate = [self getNowDateFromatAnDate:[NSDate date]];
    
    NSDate * currentDate = [NSDate date];
    if ([currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedAscending)
    {
        return @"早上好！";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedAscending)
        
    {
        return @"上午好！";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedAscending)
        
    {
        return @"中午好！";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:18]] == NSOrderedAscending)
        
    {
        return @"下午好！";
    }
    else
    {
        return @"晚上好！";
    }
}

//考虑时区，获取准备的系统时间方法
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

#pragma mark - clicked

- (void)logoutClicked:(UIButton *)sender
{
    [_delegate didClickLogout];
}

- (void)indexClicked:(UIButton *)sender
{
    [_delegate didClickIndex:(int)sender.tag];
}

@end
