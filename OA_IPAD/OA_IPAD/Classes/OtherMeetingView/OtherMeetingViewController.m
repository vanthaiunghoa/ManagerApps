//
//  OtherMeetingViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "OtherMeetingViewController.h"
#import "OtherMeetingCell.h"
#import "UIColor+color.h"
#import "MeetingsService.h"
#import "MeetingsInfo.h"
#import "MeetingViewController.h"

@interface OtherMeetingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *otherMeetings;

@end

@implementation OtherMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    self.title = @"其他会议";
    
    [self initTableView];
    [self loadOthers];
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
    
    [self.tableView registerClass:[OtherMeetingCell class] forCellReuseIdentifier:NSStringFromClass([OtherMeetingCell class])];
}

#pragma mark - data

- (void)loadOthers
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"数据加载中..."];

    @weakify(self);
    [[[MeetingsService shared] otherMeetingsForMeetingIdentifier:self.identifier] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        if([x count])
        {
            self.otherMeetings = x;
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"暂无其他会议"];
        }
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.otherMeetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherMeetingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OtherMeetingCell class])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    MeetingsInfo *info = self.otherMeetings[indexPath.row];
    cell.flowName = info.MeetName;
    
    if(indexPath.row == self.otherMeetings.count - 1)
    {
        cell.isHiddenLine = YES;
    }
    else
    {
        cell.isHiddenLine = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingsInfo *other = self.otherMeetings[indexPath.row];
    MeetingViewController *vc = [[MeetingViewController alloc] init];
    vc.identifier = other.MM_SNID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
