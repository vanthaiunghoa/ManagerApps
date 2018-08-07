//
//  SendHandlerContentViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendHandlerContentViewController.h"
#import "SendFileHandleViewModel.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "SendFileAttatchFileInfo.h"
#import "MBProgressHUD+LCL.h"
#import "FilePreViewController.h"
#import "FilePreviewViewModel.h"
#import "DetailModel.h"
#import "SendAttachmentCell.h"
#import "DetailCell.h"
#import "ModelManager.h"
#import "HeaderView.h"
#import "SendFileDetail.h"
#import "SuggestCell.h"
#import "RequestManager.h"
#import "ShortWordModel.h"
#import <MJExtension/MJExtension.h>
#import "XLsn0wPickerSingler.h"

@interface SendHandlerContentViewController () <UITableViewDelegate, UITableViewDataSource, SuggestCellDelegate, XLsn0wPickerSinglerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SendFileHandleViewModel *viewModel;
@property (strong, nonatomic) NSArray *attatchFiles;
@property (strong, nonatomic) NSMutableArray *detailModelArr;
@property (strong, nonatomic) NSMutableArray *titleArr;
@property (nonatomic, strong) SendFileDetail *dataObject;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) SuggestCell *suggestCell;
@property (strong, nonatomic) NSMutableArray<NSString *> *usualArr;

@end

@implementation SendHandlerContentViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    
    [self initTableView];
    [self initBottomView];
    [self loadData];
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - topHeight - 55 - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[HeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HeaderView class])];
    [self.tableView registerClass:[SendAttachmentCell class] forCellReuseIdentifier:NSStringFromClass([SendAttachmentCell class])];
    [self.tableView registerClass:[SuggestCell class] forCellReuseIdentifier:NSStringFromClass([SuggestCell class])];
    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:NSStringFromClass([DetailCell class])];
}

- (void)initBottomView
{
    float x = 0;
    float w = SCREEN_WIDTH / 2.0;
    
    NSArray *titles = @[@"保存意见", @"办完退出"];
    
    for(int i = 0; i < titles.count; ++i)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, self.tableView.frame.origin.y + self.tableView.frame.size.height, w, 64)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:22];
        btn.tag = i;
        if(0 == i)
        {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x3D98FF]] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:241 green:86 blue:84]] forState:UIControlStateNormal];
        }
        [self.view addSubview:btn];
        x += w;
        
        [btn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - clicked

- (void)bottomClicked:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认提交意见？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        
        self.viewModel.advice = [self.suggestCell getText];
        RACSignal *response = [self.viewModel saveAdvice];
        [SVProgressHUD showWithStatus:@"提交中..."];
        self.view.userInteractionEnabled = NO;
        
        @weakify(self);
        [response subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            self.view.userInteractionEnabled = YES;
            if(sender.tag == 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadSendHandlerRecord" object:nil];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSError * _Nullable error) {
            @strongify(self);
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - data

- (void)loadData
{
    RACSignal *response = [self.viewModel fileHandleData];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    
    @weakify(self);
    [response subscribeNext:^(RACTuple *x)
     {
         @strongify(self);
         self.view.userInteractionEnabled = YES;
         [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
         
         if (self)
         {
             self.dataObject = [x first];
             self.attatchFiles = [x second];
             self.records = [x third];
             [self initModels];
             [self.tableView reloadData];
             [self initSuggestCell];
         }
     }error:^(NSError * _Nullable error)
     {
         @strongify(self);
         self.view.userInteractionEnabled = YES;
         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
     }];
}

- (void)loadUsualData
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    
    @weakify(self);
    [[RequestManager shared] requestWithAction:@"GetShortWord" appendingURL:@"Handlers/DMS_FileMan_Handler.ashx" parameters:@{@"Handle": @"发文"} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        
        if (success)
        {
            [SVProgressHUD dismiss];
            NSArray *tmp = [ShortWordModel mj_objectArrayWithKeyValuesArray:data[@"Datas"]];
            if(tmp.count)
            {
                for(ShortWordModel *p in tmp)
                {
                    [self.usualArr addObject:p.ShortWord];
                }
                
                XLsn0wPickerSingler *singler = [[XLsn0wPickerSingler alloc] initWithArrayData:self.usualArr unitTitle:@"" xlsn0wDelegate:self];
                [singler show];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"暂无常用短语"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

#pragma mark - SuggestCellDelegate

-(void)handlerStatus:(BOOL)isDone
{
    _viewModel.handled = isDone;
}

- (void)didClickedUsual
{
    if(self.usualArr.count == 0)
    {
        [self loadUsualData];
    }
    else
    {
        XLsn0wPickerSingler *singler = [[XLsn0wPickerSingler alloc] initWithArrayData:self.usualArr unitTitle:@"" xlsn0wDelegate:self];
        [singler show];
    }
}

#pragma mark - XLsn0wPickerSinglerDelegate

- (void)pickerSingler:(XLsn0wPickerSingler *)pickerSingler selectedTitle:(NSString *)selectedTitle selectedRow:(NSInteger)selectedRow
{
    NSString *suggest = [NSString stringWithFormat:@"%@%@", [_suggestCell getText], selectedTitle];
    
    [_suggestCell setText:suggest];
}


#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else if(section == 1)
    {
        if(self.attatchFiles.count == 0)
        {
            return nil;
        }
        
        HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HeaderView class])];
        header.model = self.titleArr[section];
        return header;
    }
    else
    {
        HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HeaderView class])];
        header.model = self.titleArr[section];
        return header;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.detailModelArr.count;
    }
    else if(section == 1)
    {
        return self.attatchFiles.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = self.detailModelArr[indexPath.row];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        SendAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendAttachmentCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = self.attatchFiles[indexPath.row];
        
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
    else
    {
        if(_suggestCell == nil)
        {
            _suggestCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SuggestCell class])];
            _suggestCell.delegate = self;
            [_suggestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        return _suggestCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2)
    {
        return 250;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return TableViewHeaderHeight;
    }
    else if(section == 1)
    {
        if(self.attatchFiles.count == 0)
        {
            return 0.01;
        }
        return 65;
    }
    else
    {
        return 65;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        
    }
    else if(indexPath.section == 1)
    {
        SendFileAttatchFileInfo *file = self.attatchFiles[indexPath.row];
        [self openAttatchFile:file];
    }
    else
    {
        
    }
}

#pragma mark- method

- (void)initSuggestCell
{
    _suggestCell.isDone = _viewModel.handled;
    [_suggestCell setText:@"已阅。"];
}

- (void)openAttatchFile:(SendFileAttatchFileInfo *)file {
    FilePreViewController *previewer = [FilePreViewController new];
    previewer.fileModel = file;
    FilePreviewViewModel *vm = [FilePreviewViewModel new];
    vm.recordIdentifier = [ModelManager sharedModelManager].recordIdentfier;
    previewer.viewModel = vm;
    [self.navigationController pushViewController:previewer animated:YES];
}


- (void)initModels
{
    DetailModel *detailModel = [DetailModel new];
    detailModel.left = @"发文编号";
    detailModel.right = self.dataObject.FWH;
    detailModel.isHide = YES;
    [self.detailModelArr addObject:detailModel];
    
    DetailModel *detailModel2 = [DetailModel new];
    detailModel2.left = @"文号";
    detailModel2.right = self.dataObject.WHT;
    detailModel2.isHide = NO;
    [self.detailModelArr addObject:detailModel2];
    
    DetailModel *detailModel3 = [DetailModel new];
    detailModel3.left = @"对应收文编号";
    detailModel3.right = self.dataObject.DYSWH;
    detailModel3.isHide = NO;
    [self.detailModelArr addObject:detailModel3];
    
    DetailModel *detailModel4 = [DetailModel new];
    detailModel4.left = @"拟稿人";
    detailModel4.right = self.dataObject.NGR;
    detailModel4.isHide = NO;
    [_detailModelArr addObject:detailModel4];
    
    DetailModel *detailModel5 = [DetailModel new];
    detailModel5.left = @"签发人";
    detailModel5.right = self.dataObject.QFR;
    detailModel5.isHide = NO;
    [_detailModelArr addObject:detailModel5];
    
    DetailModel *detailModel6 = [DetailModel new];
    detailModel6.left = @"发出日期";
    detailModel6.right = self.dataObject.FCDate;
    detailModel6.isHide = NO;
    [self.detailModelArr addObject:detailModel6];
    
    DetailModel *detailModel7 = [DetailModel new];
    detailModel7.left = @"缓急";
    detailModel7.right = self.dataObject.HJ;
    detailModel7.isHide = NO;
    [self.detailModelArr addObject:detailModel7];
    
    DetailModel *detailModel8 = [DetailModel new];
    detailModel8.left = @"密级";
    detailModel8.right = self.dataObject.MJ;
    detailModel8.isHide = NO;
    [self.detailModelArr addObject:detailModel8];
    
    DetailModel *detailModel9 = [DetailModel new];
    detailModel9.left = @"标题";
    detailModel9.right = self.dataObject.BT;
    detailModel9.isHide = NO;
    [self.detailModelArr addObject:detailModel9];
    
    DetailModel *detailModel10 = [DetailModel new];
    detailModel10.left = @"主送单位";
    detailModel10.right = self.dataObject.ZSDW;
    detailModel10.isHide = NO;
    [_detailModelArr addObject:detailModel10];
    
    DetailModel *detailModel11 = [DetailModel new];
    detailModel11.left = @"抄送单位";
    detailModel11.right = self.dataObject.CSDW;
    detailModel11.isHide = NO;
    [_detailModelArr addObject:detailModel11];
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

- (NSMutableArray *)detailModelArr
{
    if(_detailModelArr == nil)
    {
        _detailModelArr = [NSMutableArray array];
    }
    
    return _detailModelArr;
}

- (NSMutableArray *)titleArr
{
    if(_titleArr == nil)
    {
        _titleArr = [NSMutableArray array];
        
        DetailModel *detailModel = [DetailModel new];
        detailModel.left = @"";
        [_titleArr addObject:detailModel];
        
        DetailModel *detailModel2 = [DetailModel new];
        detailModel2.left = @"附件列表";
        [_titleArr addObject:detailModel2];
        
        DetailModel *detailModel3 = [DetailModel new];
        detailModel3.left = @"办理意见";
        [_titleArr addObject:detailModel3];
    }
    
    return _titleArr;
}

- (NSMutableArray<NSString *> *)usualArr
{
    if(_usualArr == nil)
    {
        _usualArr = [NSMutableArray array];
    }
    
    return _usualArr;
}


@end

