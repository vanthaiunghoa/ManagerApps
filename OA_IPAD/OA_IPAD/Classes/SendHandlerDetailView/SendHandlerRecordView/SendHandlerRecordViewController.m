//
//  SendHandlerRecordViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendHandlerRecordViewController.h"
#import "UIColor+color.h"
#import "SendFileHandleViewModel.h"
#import "SendRecordCell.h"
#import "SendRecordHeaderView.h"
#import "MBProgressHUD+LCL.h"
#import "ModelManager.h"
#import "SendFileService.h"
#import "ModelManager.h"

@interface SendHandlerRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SendFileHandleViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray *records;
@property (strong, nonatomic) UILabel *labTips;

@end

@implementation SendHandlerRecordViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    
    [self initTableView];
    [self initTips];
    [self loadRecords];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecords) name:@"ReloadSendHandlerRecord" object:nil];
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - topHeight - 55) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[SendRecordHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SendRecordHeaderView class])];
    [self.tableView registerClass:[SendRecordCell class] forCellReuseIdentifier:NSStringFromClass([SendRecordCell class])];
}

- (void)initTips
{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 50)];
    [self.view addSubview:lab];
    lab.hidden = YES;
    self.labTips = lab;
    [lab setText:@"暂无记录"];
    [lab setFont:[UIFont systemFontOfSize:20]];
    [lab setTextColor:GrayColor];
    [lab setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - data

- (void)loadRecords
{
    RACSignal *requestRecords = [[SendFileService shared] handleFileRecordsForIdentifier:[ModelManager sharedModelManager].mainIdentifier];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;

    @weakify(self);
    [requestRecords subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;

        self.records = x;
        if(self.records.count)
        {
            self.labTips.hidden = YES;
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"暂无记录"];
            self.labTips.hidden = NO;
        }
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendRecordCell class])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.records[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [SendRecordCell class];
    SendFileRecord *model = self.records[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - method

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma mark - lazy load

- (SendFileHandleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SendFileHandleViewModel new];
        _viewModel.identifier = [ModelManager sharedModelManager].mainIdentifier;
        _viewModel.recordIdentifier = [ModelManager sharedModelManager].recordIdentfier;
    }
    return _viewModel;
}


@end
