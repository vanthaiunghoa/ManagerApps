//
//  ReceiveRecordViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveRecordViewController.h"
#import "UIColor+color.h"
#import "ReceiveFileHandleViewModel.h"
#import "RecordCell.h"
#import "RecordHeaderView.h"
#import "MBProgressHUD+LCL.h"
#import "ModelManager.h"

@interface ReceiveRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ReceiveFileHandleViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray *records;
@property (strong, nonatomic) UILabel *labTips;

@end

@implementation ReceiveRecordViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecords) name:@"ReloadReceiveHandlerRecord" object:nil];
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
    
    [self.tableView registerClass:[RecordHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([RecordHeaderView class])];
    [self.tableView registerClass:[RecordCell class] forCellReuseIdentifier:NSStringFromClass([RecordCell class])];
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
    self.records = [NSMutableArray arrayWithCapacity:6];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;

    @weakify(self);
    [[self.viewModel hanldedRecords] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];

        if ([x count])
        {
            self.labTips.hidden = YES;
            
            [self.records addObject:x];
            NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
            for (NSInteger i = 3; i < self.records.count; i++) {
                [set addIndex:i];
            }
            [self.tableView reloadData];
        }
        else
        {
            self.labTips.hidden = NO;
        }
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        self.labTips.hidden = NO;
    } completed:^{
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载完成"];
        
        if(self.records.count)
        {
            self.labTips.hidden = YES;
        }
        else
        {
            self.labTips.hidden = NO;
        }
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.records.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RecordHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([RecordHeaderView class])];
    header.model = [[self.records objectAtIndex:(section)] firstObject];
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *recordsOfSection = [self.records objectAtIndex:section];
    return recordsOfSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecordCell class])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSArray *recordList = [self.records objectAtIndex:(indexPath.section)];
    cell.model = recordList[indexPath.row];
    
    if(indexPath.row == recordList.count - 1)
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
    Class currentClass = [RecordCell class];
    NSArray *recordList = [self.records objectAtIndex:(indexPath.section)];
    ReceiveFileHandleRecord *model = recordList[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
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

- (ReceiveFileHandleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [ReceiveFileHandleViewModel new];
        _viewModel.mainGUID = [ModelManager sharedModelManager].model.MGUID;
        _viewModel.whereGUID = [ModelManager sharedModelManager].model.WhereGUID;
    }
    return _viewModel;
}


@end
