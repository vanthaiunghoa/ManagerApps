//
//  ReceiveDistributeViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveDistributeViewController.h"
#import "UIColor+color.h"
#import "DistributeCell.h"
#import "DistributeOperatorCell.h"
#import "RequestManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "ModelManager.h"
#import "ReceiveFileHandleRecord.h"
#import <MJExtension/MJExtension.h>

@interface ReceiveDistributeViewController ()<UITableViewDelegate, UITableViewDataSource, DistributeOperatorCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *records;
@property (strong, nonatomic) NSMutableArray *selectModels;
@property (strong, nonatomic) UILabel *labTips;

@end

@implementation ReceiveDistributeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ReloadReceiveDistributeRecord" object:nil];
    
    [self initHeaderView];
    [self initTableView];
    [self initTips];
    [self loadData];
}

- (void)initHeaderView
{
    CGFloat btnW = 70;
    CGFloat x = SCREEN_WIDTH - 20 - btnW;
    
    NSArray *arr = @[@"删除", @"清空", @"全选"];
    NSArray *titleColor = @[[UIColor whiteColor], [UIColor colorWithRGB:51 green:51 blue:51], [UIColor colorWithRGB:51 green:51 blue:51]];
    NSArray *bkgColor = @[[UIColor colorWithRGB:241 green:85 blue:83], [UIColor whiteColor], [UIColor whiteColor]];
    for(int i = 0; i < arr.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(x, 15, btnW, 40);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5];
        [btn setTitleColor:titleColor[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.backgroundColor = bkgColor[i];
        btn.tag = i;
        
        x -= btnW + 20;

        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - topHeight - 55 - 70)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[DistributeCell class] forCellReuseIdentifier:NSStringFromClass([DistributeCell class])];
    [self.tableView registerClass:[DistributeOperatorCell class] forCellReuseIdentifier:NSStringFromClass([DistributeOperatorCell class])];
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

#pragma mark - clicked

- (void)btnClicked:(UIButton *)sender
{
    // 删除
    if(sender.tag == 0)
    {
        if(self.selectModels.count == 0)
        {
            [SVProgressHUD showInfoWithStatus:@"没有选中记录"];
            return;
        }
        
        NSMutableString *ids = [[NSMutableString alloc] init];
        for (ReceiveFileHandleRecord *p in self.selectModels)
        {
            [ids appendString:p.WhereGUID];
            [ids appendString:@";"];
        }
        
        [SVProgressHUD showWithStatus:@"删除中..."];
        self.view.userInteractionEnabled = NO;
        
        @weakify(self);
        [[RequestManager shared] requestWithAction:@"DelSWHandleSend" appendingURL:@"Handlers/SWMan/SWHandler.ashx" parameters:@{@"Where_GUIDs": ids} callback:^(BOOL success, id data, NSError *error) {
            @strongify(self);
            self.view.userInteractionEnabled = YES;
            
            if (success)
            {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                
                NSMutableArray *lefts = [NSMutableArray arrayWithArray:self.records];
                [lefts removeObjectsInArray:self.selectModels];
                self.records = lefts;
                [self.selectModels removeAllObjects];
                [self.tableView reloadData];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadReceiveHandlerRecord" object:nil];
                if(self.records.count == 0)
                {
                    self.labTips.hidden = NO;
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];
    }
    else if(sender.tag == 1) // 清空
    {
        for(ReceiveFileHandleRecord *model in self.records)
        {
            model.isSelect = NO;
        }
        
        [self.selectModels removeAllObjects];
        [self.tableView reloadData];
    }
    else // 全选
    {
        for(ReceiveFileHandleRecord *model in self.records)
        {
            model.isSelect = YES;
            [self.selectModels addObject:model];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - DistributeOperatorCellDelegate

- (void)selectedModel:(ReceiveFileHandleRecord *)model
{
    if(model.isSelect)
    {
        [self.selectModels addObject:model];
    }
    else
    {
        [self.selectModels removeObject:model];
    }
}

#pragma mark - data

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    
    @weakify(self);
    [[RequestManager shared] requestWithAction:@"GetSWSendHandle" appendingURL:@"Handlers/SWMan/SWHandler.ashx" parameters:@{@"Where_GUID": [ModelManager sharedModelManager].model.WhereGUID} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        
        if (success)
        {
            self.labTips.hidden = YES;
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            self.records = [ReceiveFileHandleRecord mj_objectArrayWithKeyValuesArray:data[@"Datas"]];
            
            [self.tableView reloadData];
            
            if(self.records.count == 0)
            {
                self.labTips.hidden = NO;
            }
        }
        else
        {
            self.labTips.hidden = NO;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveFileHandleRecord *model = self.records[indexPath.row];
    if([model.BLStatus isEqualToString:@"办理中"] || [model.BLStatus isEqualToString:@"办完"])
    {
        DistributeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DistributeCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = model;
        
        if(indexPath.row == self.records.count - 1)
        {
            cell.isHiddenLine = YES;
        }
        else
        {
            cell.isHiddenLine = NO;
        }
        
        return cell;
    }
    else
    {
        DistributeOperatorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DistributeOperatorCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        cell.model = model;
        
        if(indexPath.row == self.records.count - 1)
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - lazy load

- (NSMutableArray *)selectModels
{
    if(_selectModels == nil)
    {
        _selectModels = [NSMutableArray array];
    }
    
    return _selectModels;
}


@end
