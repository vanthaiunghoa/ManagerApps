//
//  ReceiveRetrievalRecordViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveRetrievalRecordViewController.h"
#import "UIColor+color.h"
#import "ReceiveFileHandleViewModel.h"
#import "RecordCell.h"
#import "RecordHeaderView.h"
#import "MBProgressHUD+LCL.h"
#import "ModelManager.h"
#import "ReceiveFileType.h"
#import "ReceiveFileHandleRecord.h"
#import "RecordModel.h"

@interface ReceiveRetrievalRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ReceiveFileHandleViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray *records;

@end

@implementation ReceiveRetrievalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    
    [self initTableView];
    [self loadRecords];
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

#pragma mark - data

- (void)loadRecords
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;

    // 办理记录有多条数据；发送了5个左右请求；每次请求都会返回next
    @weakify(self);
    [[self.viewModel hanldedRecords] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
        
        if(self.records.count == 0)
        {
            for(ReceiveFileType *type in self.viewModel.recordType)
            {
                RecordModel *model = [RecordModel new];
                model.title = type.FlowName;
                model.records = [NSArray array];
                
                [self.records addObject:model];
            }
        }
        
        if([x count])
        {
            ReceiveFileHandleRecord *record = [x firstObject];
            for(int i = 0; i < self.records.count; ++i)
            {
                RecordModel *model = self.records[i];
                if([record.BLType isEqualToString:model.title])
                {
                    model.records = x;
                    self.records[i] = model;
                    break;
                }
            }
        }
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    } completed:^{
        @strongify(self)
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载完成"];
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
    header.model = self.records[section];
    return header;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RecordModel *model = self.records[section];
    return model.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecordCell class])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    RecordModel *model = self.records[indexPath.section];
    cell.model = model.records[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    if(indexPath.row == model.records.count - 1)
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
    RecordModel *recordModel = self.records[indexPath.section];
    ReceiveFileHandleRecord *model = recordModel.records[indexPath.row];
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
        _viewModel.mainGUID = [ModelManager sharedModelManager].mainIdentifier;
    }
    return _viewModel;
}

- (NSMutableArray *)records
{
    if(_records == nil)
    {
        _records = [NSMutableArray array];
    }
    
    return _records;
}


@end
