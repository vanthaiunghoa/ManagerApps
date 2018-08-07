//
//  ReceiveHandlerViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveHandlerViewController.h"
#import "ReceiveFileHandleViewModel.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "InfoCell.h"
#import "FileTransferCell.h"
#import "AttachedFilesCell.h"
#import "AdviseCell.h"
#import "Organization.h"
#import "Personel.h"
#import "ChooseNameViewController.h"
#import "ReceiveFileHandleRecord.h"
#import "ReceiveFileRecordCell.h"
#import "ReceiveFileRecordHeader.h"
#import "CommonDatePicker.h"
#import "ListPicker.h"
#import "ReceiveFileAttatchFileInfo.h"
#import "MBProgressHUD+LCL.h"
#import "FilePreViewController.h"
#import "UserService.h"
#import "FilePreviewViewModel.h"
#import "DetailModel.h"
#import "SuggestCell.h"
#import "SelectPersonCell.h"
#import "AttachmentCell.h"
#import "DetailCell.h"
#import "ModelManager.h"
#import "HeaderView.h"
#import "SelectViewController.h"
#import "PeopleCell.h"
#import "RequestManager.h"
#import "XLsn0wPickerSingler.h"
#import "ShortWordModel.h"
#import <MJExtension/MJExtension.h>

@interface ReceiveHandlerViewController () <UITableViewDelegate, UITableViewDataSource, SuggestCellDelegate, SelectViewControllerDelegate, XLsn0wPickerSinglerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ReceiveFileHandleViewModel *viewModel;
@property (copy, nonatomic) NSArray *attatchFiles;
@property (strong, nonatomic) NSMutableArray<NSString *> *usualArr;
@property (strong, nonatomic) NSMutableArray *detailModelArr;
@property (strong, nonatomic) NSMutableArray *peopleModelArr;
@property (strong, nonatomic) NSMutableArray *titleArr;
@property (strong, nonatomic) SuggestCell *suggestCell;
@property (strong, nonatomic) NSMutableArray<Organization *> *organization;
@property (copy, nonatomic) NSString *shortWord;

@end

@implementation ReceiveHandlerViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.title = @"收文办理";
    self.view.backgroundColor = ViewColor;
    self.shortWord = @"";
    
    //初始化落款时间；默认勾选
    self.viewModel.autoGenerateAdvice = YES;
    self.viewModel.postFile = YES;
    self.viewModel.transferLeaderOperator = @"请";
    self.viewModel.transferLeaderOperation = @"批示";
    self.viewModel.transferOperator2 = @"请";
    self.viewModel.filetype = @"办件";
    
    [self initTableView];
    [self initBottomView];
    [self loadData];
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - topHeight - 64 - 55) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[HeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HeaderView class])];
    [self.tableView registerClass:[SuggestCell class] forCellReuseIdentifier:NSStringFromClass([SuggestCell class])];
    [self.tableView registerClass:[SelectPersonCell class] forCellReuseIdentifier:NSStringFromClass([SelectPersonCell class])];
    [self.tableView registerClass:[AttachmentCell class] forCellReuseIdentifier:NSStringFromClass([AttachmentCell class])];
    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:NSStringFromClass([DetailCell class])];
    [self.tableView registerClass:[PeopleCell class] forCellReuseIdentifier:NSStringFromClass([PeopleCell class])];
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
    self.viewModel.signDate = [[NSDate new] adviceCellDateString];
    self.viewModel.fileDueDate = [[NSDate dateWithTimeIntervalSinceNow:24*60*60*7] fileTransferDateString];
    self.viewModel.advice = [_suggestCell getText];
    
    [SVProgressHUD showWithStatus:@"正在保存..."];
    self.view.userInteractionEnabled = NO;
    @weakify(self);
    [[self.viewModel saveAdvice] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [SVProgressHUD showSuccessWithStatus:@"保存意见成功"];
        self.view.userInteractionEnabled = YES;
        
        if(0 == sender.tag)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadReceiveHandlerRecord" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadReceiveDistributeRecord" object:nil];
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
}

#pragma mark - data

- (void)loadData
{
    //    [self _reloadRecords];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    @weakify(self);
    [[self.viewModel receiveFileAttachFiles] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
        self.attatchFiles = x;
        [self.tableView reloadData];
        
        [self initSuggestCell];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        [hud showMessage:error.localizedDescription];
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)loadUsualData
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    
    @weakify(self);
    [[RequestManager shared] requestWithAction:@"GetShortWord" appendingURL:@"Handlers/DMS_FileMan_Handler.ashx" parameters:@{@"Handle": @"收文"} callback:^(BOOL success, id data, NSError *error) {
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

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
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
    else if(section == 2)
    {
        return 1 + self.peopleModelArr.count;
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
    else if (indexPath.section == 1)
    {
        AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AttachmentCell class])];
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
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            SelectPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectPersonCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        else
        {
            PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PeopleCell class])];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.model = self.peopleModelArr[indexPath.row - 1];
            
            if(indexPath.row == self.peopleModelArr.count)
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
    if (indexPath.section == 3)
    {
        return 250;
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            return 60;
        }
        else
        {
            Class currentClass = [PeopleCell class];
            DetailModel *model = self.peopleModelArr[indexPath.row - 1];
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
        }
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
        ReceiveFileAttatchFileInfo *file = self.attatchFiles[indexPath.row];
        [self openAttatchFile:file];
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            SelectViewController *vc = [[SelectViewController alloc] init];
            vc.delegate = self;
            if([self.organization count])
            {
                if([vc.organizations count])
                {
                    [vc.organizations removeAllObjects];
                }
                
                for(Organization *p in self.organization)
                {
                    [vc.organizations addObject:[p copy]];
                }
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
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

- (void)openAttatchFile:(ReceiveFileAttatchFileInfo *)file
{
    FilePreViewController *previewer = [FilePreViewController new];
    previewer.fileModel = file;
    FilePreviewViewModel *viewModel = [FilePreviewViewModel new];
    viewModel.recordIdentifier = [ModelManager sharedModelManager].model.MGUID;
    previewer.viewModel = viewModel;
    [self.navigationController pushViewController:previewer animated:YES];
}

#pragma mark - SuggestCellDelegate

- (void)handlerStatus:(BOOL)isDone
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

#pragma mark - SelectViewControllerDelegate

- (void)controller:(SelectViewController *)controller didConfirmPensonel:(NSMutableArray<Organization *> *)organizations
{
    [controller.navigationController popViewControllerAnimated:YES];
    
    if([self.organization count])
    {
        [self.organization removeAllObjects];
    }
    for(Organization *p in organizations)
    {
        [self.organization addObject:[p copy]];
    }
    
    // 批示
    NSMutableArray<Personel *> *transferLeaderReceivers = [NSMutableArray array];
    // 主办
    NSMutableArray<Personel *> *transferHostReceivers = [NSMutableArray array];
    // 协办
    NSMutableArray<Personel *> *transferAssistReceivers = [NSMutableArray array];
    // 传阅
    NSMutableArray<Personel *> *transferReadReceivers = [NSMutableArray array];
    
    for(int i = 0; i < self.organization.count; ++i)
    {
        for(int j = 0; j < self.organization[i].staff.count; ++j)
        {
            if(self.organization[i].staff[j].selectMode == SelectComment)
            {
                [transferLeaderReceivers addObject:self.organization[i].staff[j]];
            }
            
            if(self.organization[i].staff[j].selectMode == SelectHost)
            {
                [transferHostReceivers addObject:self.organization[i].staff[j]];
            }
            
            if(self.organization[i].staff[j].selectMode == SelectHelp)
            {
                [transferAssistReceivers addObject:self.organization[i].staff[j]];
            }
            
            if(self.organization[i].staff[j].selectMode == SelectRead)
            {
                [transferReadReceivers addObject:self.organization[i].staff[j]];
            }
        }
    }
    
    self.viewModel.transferLeaderReceivers = transferLeaderReceivers;
    self.viewModel.transferHostReceivers = transferHostReceivers;
    self.viewModel.transferAssistReceivers = transferAssistReceivers;
    self.viewModel.transferReadReceivers = transferReadReceivers;
    
    if([self.peopleModelArr count])
    {
        [self.peopleModelArr removeAllObjects];
    }
    
    if([transferLeaderReceivers count])
    {
        NSMutableString *peoples = [[NSMutableString alloc] init];
        for (Personel *p in transferLeaderReceivers)
        {
            [peoples appendString:p.UserName];
            [peoples appendString:@"、"];
        }
        
        if (peoples.length > 1 && [[peoples substringWithRange:NSMakeRange(peoples.length - 1, 1)] isEqualToString:@"、"])
        {
            [peoples replaceCharactersInRange:NSMakeRange(peoples.length-1, 1) withString:@""];
        }
        
        DetailModel *detailModel = [DetailModel new];
        detailModel.left = @"批示";
        detailModel.right = peoples;
        [self.peopleModelArr addObject:detailModel];
    }
    
    if([transferHostReceivers count])
    {
        NSMutableString *peoples = [[NSMutableString alloc] init];
        for (Personel *p in transferHostReceivers)
        {
            [peoples appendString:p.UserName];
            [peoples appendString:@"、"];
        }
        
        if (peoples.length > 1 && [[peoples substringWithRange:NSMakeRange(peoples.length - 1, 1)] isEqualToString:@"、"])
        {
            [peoples replaceCharactersInRange:NSMakeRange(peoples.length-1, 1) withString:@""];
        }
        
        DetailModel *detailModel = [DetailModel new];
        detailModel.left = @"主办";
        detailModel.right = peoples;
        [self.peopleModelArr addObject:detailModel];
    }
    
    if([transferAssistReceivers count])
    {
        NSMutableString *peoples = [[NSMutableString alloc] init];
        for (Personel *p in transferAssistReceivers)
        {
            [peoples appendString:p.UserName];
            [peoples appendString:@"、"];
        }
        
        if (peoples.length > 1 && [[peoples substringWithRange:NSMakeRange(peoples.length - 1, 1)] isEqualToString:@"、"])
        {
            [peoples replaceCharactersInRange:NSMakeRange(peoples.length-1, 1) withString:@""];
        }
        
        DetailModel *detailModel = [DetailModel new];
        detailModel.left = @"协办";
        detailModel.right = peoples;
        [self.peopleModelArr addObject:detailModel];
    }
    
    if([transferReadReceivers count])
    {
        NSMutableString *peoples = [[NSMutableString alloc] init];
        for (Personel *p in transferReadReceivers)
        {
            [peoples appendString:p.UserName];
            [peoples appendString:@"、"];
        }
        
        if (peoples.length > 1 && [[peoples substringWithRange:NSMakeRange(peoples.length - 1, 1)] isEqualToString:@"、"])
        {
            [peoples replaceCharactersInRange:NSMakeRange(peoples.length-1, 1) withString:@""];
        }
        
        DetailModel *detailModel = [DetailModel new];
        detailModel.left = @"传阅";
        detailModel.right = peoples;
        [self.peopleModelArr addObject:detailModel];
    }
    
    [self.tableView reloadData];
    
    NSString *tmp = [_suggestCell getText];
    NSString *suggest = nil;
    if([tmp containsString:self.shortWord])
    {
        suggest = [tmp stringByReplacingOccurrencesOfString:self.shortWord withString:[self.viewModel autoGenerateSentence]];
    }
    else
    {
        suggest = [NSString stringWithFormat:@"%@%@", [_suggestCell getText], [self.viewModel autoGenerateSentence]];
    }
    
    self.shortWord = [self.viewModel autoGenerateSentence];
    [_suggestCell setText:suggest];
}

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

- (NSMutableArray *)detailModelArr
{
    if(_detailModelArr == nil)
    {
        _detailModelArr = [NSMutableArray array];
        
        DetailModel *detailModel = [DetailModel new];
        detailModel.left = @"收文编号";
        detailModel.right = [ModelManager sharedModelManager].model.SWBH;
        detailModel.isHide = YES;
        [_detailModelArr addObject:detailModel];
        
        DetailModel *detailModel2 = [DetailModel new];
        detailModel2.left = @"收文日期";
        detailModel2.right = [ModelManager sharedModelManager].model.SWDate;
        detailModel2.isHide = NO;
        [_detailModelArr addObject:detailModel2];
        
        DetailModel *detailModel3 = [DetailModel new];
        detailModel3.left = @"文号";
        detailModel3.right = [ModelManager sharedModelManager].model.WH;
        detailModel3.isHide = NO;
        [_detailModelArr addObject:detailModel3];
        
        DetailModel *detailModel4 = [DetailModel new];
        detailModel4.left = @"来文单位";
        detailModel4.right = [ModelManager sharedModelManager].model.LWDW;
        detailModel4.isHide = NO;
        [_detailModelArr addObject:detailModel4];
        
        DetailModel *detailModel5 = [DetailModel new];
        detailModel5.left = @"来文标题";
        detailModel5.right = [ModelManager sharedModelManager].model.Title;
        detailModel5.isHide = NO;
        [_detailModelArr addObject:detailModel5];
        
        DetailModel *detailModel6 = [DetailModel new];
        detailModel6.left = @"备注";
        detailModel6.right = [ModelManager sharedModelManager].model.Memo;
        detailModel6.isHide = NO;
        [_detailModelArr addObject:detailModel6];
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
        detailModel3.left = @"文件转派";
        [_titleArr addObject:detailModel3];
        
        DetailModel *detailModel4 = [DetailModel new];
        detailModel4.left = @"办理意见";
        [_titleArr addObject:detailModel4];
        
    }
    
    return _titleArr;
}

- (NSMutableArray *)peopleModelArr
{
    if(_peopleModelArr == nil)
    {
        _peopleModelArr = [NSMutableArray array];
    }
    
    return _peopleModelArr;
}

- (NSMutableArray<Organization *> *)organization
{
    if(_organization == nil)
    {
        _organization = [NSMutableArray array];
    }
    
    return _organization;
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

