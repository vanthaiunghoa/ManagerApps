//
//  IssuesViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/7.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "IssuesViewController.h"
#import "MeetingsService.h"
#import "MeetingAttatchFile.h"
#import "MeetingTheme.h"
#import "FilePreViewController.h"
#import "MeetingPreviewViewModel.h"
#import "FileCell.h"
#import "IssuesCell.h"

@interface IssuesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MeetingTheme *theme;
@property (nonatomic, strong) NSArray *attatchFiles;

@end

@implementation IssuesViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ ♻️", NSStringFromClass(self.class));
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"议题";
    self.view.backgroundColor = ViewColor;
    
    [self initTableView];
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
    
    [self.tableView registerClass:[FileCell class] forCellReuseIdentifier:NSStringFromClass([FileCell class])];
    [self.tableView registerClass:[IssuesCell class] forCellReuseIdentifier:NSStringFromClass([IssuesCell class])];
}

#pragma mark - data flow

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    @weakify(self);
    [[[MeetingsService shared] meetingThemeInfosForMeetingID:self.meetingInfo[@"MM_SNID"] themeID:self.meetingInfo[@"MF_SNID"]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
        self.theme = x;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return 0.01;
    }
    else
    {
        if(self.attatchFiles.count)
        {
            return TableViewHeaderHeight;
        }
        else
        {
            return 0.01;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        MeetingAttatchFile *file = self.attatchFiles[indexPath.row];
        FilePreViewController *pre = [[FilePreViewController alloc] init];
        
        pre.isMeeting = true;
        pre.themeID = self.theme.MF_SNID;
        pre.maxLength = [file.fileLength integerValue];
        pre.fileModel = file;
        
        MeetingPreviewViewModel *vm = [MeetingPreviewViewModel new];
        pre.viewModel = vm;
        vm.recordIdentifier =  self.theme.MF_SNID;
        
        [self.navigationController pushViewController:pre animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return self.attatchFiles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        IssuesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IssuesCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0)
        {
            cell.flowName = self.meetingName;
            cell.titleName = @"会议：";
            cell.isHiddenLine = NO;
        }
        else if (indexPath.row == 1)
        {
            cell.flowName = self.meetingInfo[@"FlowName"];
            cell.titleName = @"议题：";
            cell.isHiddenLine = NO;
        }
        else
        {
            cell.flowName = self.meetingInfo[@"ZBKS"];
            cell.titleName = @"主办科室：";
            cell.isHiddenLine = YES;
        }

        return cell;
    }
    else
    {
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FileCell class])];
        MeetingAttatchFile *file = self.attatchFiles[indexPath.row];
        cell.flowName = file.Name;
        
        if(indexPath.row == self.attatchFiles.count - 1)
        {
            cell.isHiddenLine = YES;
        }
        else
        {
            cell.isHiddenLine = NO;
        }
        
        return cell;
    }
}

#pragma mark - getters and setters

- (NSArray *)attatchFiles
{
    return self.theme.QWList;
}

@end
