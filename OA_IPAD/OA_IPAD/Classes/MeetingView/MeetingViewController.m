//
//  MeetingViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MeetingViewController.h"
#import "MeetingCell.h"
#import "YYTextCell.h"
#import "UIColor+color.h"
#import "MeetingsService.h"
#import "MeetingsInfo.h"
#import "MBProgressHUD+LCL.h"
//#import "MeetingThemeViewController.h"
#import "OtherMeetingViewController.h"
#import "IssuesViewController.h"

@interface MeetingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) MeetingsInfo *dataSource;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labAddress;
@property (nonatomic, strong) UILabel *labTime;

@property (nonatomic, strong) NSMutableDictionary *attributedTextDict; //key: indexPath

@end

@implementation MeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    self.title = @"开始会议";
    
    [self initTableView];
    [self initHeaderView];
    [self addRightButton];
    [self loadData];
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - topHeight)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[MeetingCell class] forCellReuseIdentifier:NSStringFromClass([MeetingCell class])];
    [self.tableView registerClass:[YYTextCell class] forCellReuseIdentifier:NSStringFromClass([YYTextCell class])];
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat x = 20;
    CGFloat y = 10;
    CGFloat w = SCREEN_WIDTH - 2.0*x;
    
    self.labTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 80)];
    self.labTitle.numberOfLines = 0;
    [self.labTitle setTextColor:[UIColor colorWithHex:0x3D98FF]];
    [self.labTitle setFont:[UIFont systemFontOfSize:25]];
    [self.labTitle setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:self.labTitle];
    
    y += 90;
    self.labTime = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 20)];
    [self.labTime setTextColor:[UIColor colorWithRGB:136 green:136 blue:136]];
    [self.labTime setFont:[UIFont systemFontOfSize:18]];
    [self.labTime setTextAlignment:NSTextAlignmentLeft];
    [headerView addSubview:self.labTime];

//    x += 155;
//    self.labAddress = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w - 120, 20)];
//    [self.labAddress setTextColor:[UIColor colorWithRGB:136 green:136 blue:136]];
//    [self.labAddress setFont:[UIFont systemFontOfSize:18]];
//    [self.labAddress setTextAlignment:NSTextAlignmentLeft];
//    [headerView addSubview:self.labAddress];
}

- (void)addRightButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setTitle:@"其他会议" forState:0];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(otherClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark -clicked

- (void)otherClicked:(UIButton *)sender
{
    OtherMeetingViewController *vc = [[OtherMeetingViewController alloc] init];
    vc.identifier = self.dataSource.MM_SNID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - data

- (void)loadData
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"数据加载中..."];

    RACSignal *requestDetail = [[MeetingsService shared] meetingsInfoForIdentifier:self.identifier];
    @weakify(self);
    [requestDetail subscribeNext:^(MeetingsInfo *x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];

        self.dataSource = x;
        self.labTitle.text = self.dataSource.MeetName;
        NSString *str = [NSString stringWithFormat:@"%@    %@", self.dataSource.MeetDateTime, self.dataSource.MeetAddress];
        self.labTime.text = str;
//        self.labAddress.text = self.dataSource.MeetAddress;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.MeetFlows.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataSource.MeetFlows.count)
    {
        MeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeetingCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDictionary *meeting = self.dataSource.MeetFlows[indexPath.row];
        cell.flowName = meeting[@"FlowName"];
        
        return cell;
    }
    else
    {
        if(indexPath.row == self.dataSource.MeetFlows.count)
        {
            YYTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYTextCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.label.attributedText = [self strForIndexPath:indexPath];
            cell.labTitle.text = @"参会领导名单：";
            
            return cell;
        }
        else if(indexPath.row == self.dataSource.MeetFlows.count + 1)
        {
            YYTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYTextCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.label.attributedText = [self strForIndexPath:indexPath];
            cell.labTitle.text = @"列席人员名单：";
            
            return cell;
        }
        else if(indexPath.row == self.dataSource.MeetFlows.count + 2)
        {
            YYTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYTextCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.label.attributedText = [self strForIndexPath:indexPath];
            cell.labTitle.text = @"请假人员名单：";
            
            return cell;
        }
        else
        {
            YYTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYTextCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.label.attributedText = [self strForIndexPath:indexPath];
            cell.labTitle.text = @"会议记录名单：";
           
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataSource.MeetFlows.count)
    {
        return 60;
    }
    else
    {
        NSAttributedString *str = self.attributedTextDict[indexPath];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 40, CGFLOAT_MAX) text:str];
        return layout.rowCount * 40 + 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.dataSource.MeetFlows.count)
    {
        NSDictionary *internel = self.dataSource.MeetFlows[indexPath.row];
//        MeetingThemeViewController *vc = [[UIStoryboard storyboardWithName:@"Meetings" bundle:nil] instantiateViewControllerWithIdentifier:@"MeetingThemeViewController"];
        IssuesViewController *vc = [[IssuesViewController alloc] init];
        vc.meetingInfo = internel;
        vc.meetingName = self.dataSource.MeetName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - method

- (NSMutableAttributedString *)strForIndexPath:(NSIndexPath *)indexPath
{
    if (self.attributedTextDict[indexPath])
    {
        return self.attributedTextDict[indexPath];
    }
    NSInteger count = self.dataSource.MeetFlows.count;
    if (indexPath.row == count)
    {
        return [self strWithType:@"参会领导名单：" personels:self.dataSource.MeetPersonLD index:indexPath];
    } else if (indexPath.row == count + 1)
    {
        return [self strWithType:@"列席人员名单：" personels:self.dataSource.MeetPersonLX index:indexPath];
    } else if (indexPath.row == count + 2)
    {
        return [self strWithType:@"请假人员名单：" personels:self.dataSource.MeetPersonQJ index:indexPath];
    }  else if (indexPath.row == count + 3)
    {
        return [self strWithType:@"会议记录名单：" personels:self.dataSource.MeetPersonJL index:indexPath];
    }
    return nil;
}

- (NSMutableAttributedString *)strWithType:(NSString *)type personels:(NSString *)personels index:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont systemFontOfSize:18];
    NSDictionary *typeAttr = @{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:NormalColor};
    NSMutableAttributedString *str = [NSMutableAttributedString new];
    if (personels.length == 0 || [personels isEqualToString:@"无"])
    {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"无" attributes:typeAttr]];
    }
    else
    {
        NSArray *componets = [personels componentsSeparatedByString:@"、"];
        for (NSString *name in componets)
        {
            NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:name];
            [tagText yy_insertString:@"   " atIndex:0];
            [tagText yy_appendString:@"   "];
            tagText.yy_font = font;
            tagText.yy_color = [UIColor colorWithHex:0x3D98FF];
            [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
            
            YYTextBorder *border = [YYTextBorder new];
            border.strokeWidth = 1;
            border.strokeColor = [UIColor colorWithHex:0x3D98FF];
            border.fillColor = [UIColor whiteColor];
            border.cornerRadius = 5; // a huge value
            border.lineJoin = kCGLineJoinBevel;
            
            border.insets = UIEdgeInsetsMake(-3, -5, -3, -5);
            [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:name]];
            
            [str appendAttributedString:tagText];
        }
    }
    str.yy_lineSpacing = 15;
    str.yy_lineBreakMode = NSLineBreakByWordWrapping;
    self.attributedTextDict[indexPath] = str;
    return str;
}

#pragma mark - lazy load

- (NSMutableDictionary *)attributedTextDict
{
    if (!_attributedTextDict)
    {
        _attributedTextDict = [NSMutableDictionary dictionary];
    }
    return _attributedTextDict;
}
@end
