//
//  ReceiveFileReviewViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/8.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveFileReviewViewController.h"
#import "ReceiveFileHandleViewModel.h"
#import "InfoCell.h"
#import "FileTransferCell.h"
#import "AttachedFilesCell.h"
#import "AdviseCell.h"
#import "Personel.h"
#import "ChooseNameViewController.h"
#import "ReceiveFileDetail.h"
#import "ReceiveFileHandleRecord.h"
#import "ReceiveFileRecordCell.h"
#import "ReceiveFileRecordHeader.h"
#import "ReceiveTransactionService.h"
#import "AttatchFileDownloader.h"
#import "FilePreViewController.h"
#import "ReceiveFileAttatchFileInfo.h"
#import "MBProgressHUD+LCL.h"
#import "FilePreviewViewModel.h"

static NSString *const oneItemCell = @"oneItemCell";
static NSString *const twoItemsCell = @"twoItemsCell";
static NSString *const threeItemsCell = @"threeItemsCell";
static NSString *const attachFilesCell = @"attachFilesCell";
static NSString *const recordHeadCell = @"RecordHead";
static NSString *const recordHeader = @"recordHeader";
static NSString *const recordCell = @"recordCell";

@interface ReceiveFileReviewViewController () <UITableViewDelegate, UITableViewDataSource, AttachedFilesCellDelegate>

@property (strong, nonatomic) ReceiveFileHandleViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray *records; //每个元素都是一个数组
@property (strong, nonatomic) NSArray *attatchFiles;
@property (strong, nonatomic) ReceiveFileDetail *detail;

@end

@implementation ReceiveFileReviewViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // register cells
    [self.tableView registerNib:[UINib nibWithNibName:@"Info1Items" bundle:nil] forCellReuseIdentifier:oneItemCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"Info2Items" bundle:nil] forCellReuseIdentifier:twoItemsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"Info3Items" bundle:nil] forCellReuseIdentifier:threeItemsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"AttachedFilesCell" bundle:nil] forCellReuseIdentifier:attachFilesCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveFileRecordHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:recordHeader];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveFileRecordCell" bundle:nil] forCellReuseIdentifier:recordCell];

    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - data flow

- (void)loadData {
    
    
    @weakify(self);
    [[self.viewModel receiveFileDetail] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.detail = x;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showMessage:error.localizedDescription];
    }];
    
    // 办理记录有多条数据；发送了5个左右请求；每次请求都会返回next
    [[self.viewModel hanldedRecords] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x count]) {
            [self.records addObject:x];
            [self.tableView reloadData];
        }
    } error:^(NSError * _Nullable error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showMessage:error.localizedDescription];
    } completed:^{
        NSLog(@"completed");
    }];
    
    [[self.viewModel receiveFileAttachFiles] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.attatchFiles = x;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showMessage:error.localizedDescription];
    }];
}

#pragma mark - views control

- (UITableViewCell *)cellForSectionOne:(NSIndexPath *)indexPath {
    InfoCell *cell;
    if (indexPath.row == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"收文编号：";
        cell.info1ContentLabel.text = self.detail.SWBH;
        cell.info2DescriptionLabel.text = @"收文日期：";
        cell.info2ContentLabel.text = self.detail.SWDate;
    } else if (indexPath.row == 1) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"文号：";
        cell.info1ContentLabel.text = self.detail.WHN;
        cell.info2DescriptionLabel.text = @"安全级别：";
        cell.info2ContentLabel.text = self.detail.SW_Security;
    } else if (indexPath.row == 2) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"对应发文号：";
        cell.info1ContentLabel.text = self.detail.DY_FWBH;
        cell.info2DescriptionLabel.text = @"缓急：";
        cell.info2ContentLabel.text = self.detail.HJ;
    } else if (indexPath.row == 3) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"密级：";
        cell.info1ContentLabel.text = self.detail.MJ;
        cell.info2DescriptionLabel.text = @"来文单位：";
        cell.info2ContentLabel.text = self.detail.LWDW;
    } else if (indexPath.row == 4) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"标题：";
        cell.info1ContentLabel.text = self.detail.Title;
    } else if (indexPath.row == 5) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"主标题：";
        cell.info1ContentLabel.text = self.detail.ZTC;
    }
    return cell;
}

- (UITableViewCell *)cellForSectionTwo:(NSIndexPath *)indexPath {
    InfoCell *cell;
    if (indexPath.row == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:threeItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"主办科室：";
        cell.info1ContentLabel.text = self.detail.ZBKSName;
        cell.info2DescriptionLabel.text = @"公开类型：";
        cell.info2ContentLabel.text = self.detail.GK_Type;
        cell.info3DescriptionLabel.text = @"文种：";
        cell.info3ContentLabel.text = self.detail.WZ;
    } else if (indexPath.row == 1) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:threeItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"成文日期：";
        cell.info1ContentLabel.text = self.detail.CWDate;
        cell.info2DescriptionLabel.text = @"页数：";
        cell.info2ContentLabel.text = [self.detail.YS description];
        cell.info3DescriptionLabel.text = @"份数：";
        cell.info3ContentLabel.text = [self.detail.FS description];
    } else if (indexPath.row == 2) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:threeItemsCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"单位类别：";
        cell.info1ContentLabel.text = self.detail.LWDWLB;
        cell.info2DescriptionLabel.text = @"类别编号：";
        cell.info2ContentLabel.text = self.detail.LWDWLB_BH;
        cell.info3DescriptionLabel.text = @"文件性质：";
        cell.info3ContentLabel.text = self.detail.FileBL_Type;
    } else if (indexPath.row == 3) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"主抄送单位：";
        cell.info1ContentLabel.text = self.detail.ZSDW;
    } else if (indexPath.row == 4) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"附件描述：";
        cell.info1ContentLabel.text = self.detail.QWMemo;
    } else if (indexPath.row == 5) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"文件去向：";
        cell.info1ContentLabel.text = self.detail.SW_MoveTo;
    } else if (indexPath.row == 6) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"办理结果：";
        cell.info1ContentLabel.text = self.detail.BLResult;
    } else if (indexPath.row == 7) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
        cell.info1DescriptionLabel.text = @"备注：";
        cell.info1ContentLabel.text = self.detail.SWMemo;
    } else {
        AttachedFilesCell *cell = [self.tableView dequeueReusableCellWithIdentifier:attachFilesCell forIndexPath:indexPath];
        cell.delegate = self;
        NSInteger index = (indexPath.row-8)*2;
        ReceiveFileAttatchFileInfo *file1 = self.attatchFiles[index];
        [cell.file1 setTitle:file1.Name forState:0];
        if (index+1 < self.attatchFiles.count) {
            ReceiveFileAttatchFileInfo *file2 = self.attatchFiles[index+1];
            cell.file2LittleIcon.hidden = NO;
            cell.file2.hidden = NO;
            [cell.file2 setTitle:file2.Name forState:0];
        } else {
            cell.file2.hidden = YES;
            cell.file2LittleIcon.hidden = YES;
        }
        
        return cell;
    }
    return cell;
}

#pragma mark - actions

/**
 点击文件按钮的回调
 
 @param cell 被点击的cell
 @param index 目前支持两个文件显示，即0或者1
 */
- (void)attachedFilesCell:(AttachedFilesCell *)cell didSelectFileAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger fileIndex = (indexPath.row-8)*2 + index;
    ReceiveFileAttatchFileInfo *file = self.attatchFiles[fileIndex];
    [self openAttatchFile:file];

}

- (void)openAttatchFile:(ReceiveFileAttatchFileInfo *)file {
    FilePreViewController *previewer = [FilePreViewController new];
    previewer.fileModel = file;
    FilePreviewViewModel *viewModel = [FilePreviewViewModel new];
    viewModel.recordIdentifier = [self.detail.Main_GUID copy];
    previewer.viewModel = viewModel;
    [self.navigationController pushViewController:previewer animated:YES];
}


#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < 2) {
        return 10.f;
    } else {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < 3) {
        return 0.1f;
    } else {
        return 50.f;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        return 70;
    } else if(indexPath.section == 2){
        return 70;
    } else  {
        NSArray *records = [self.records objectAtIndex:(indexPath.section-3)];
        ReceiveFileHandleRecord *record = records[indexPath.row];
        if ([record.Yijian length] > 0) {
            CGRect rect = [record.Yijian boundingRectWithSize:CGSizeMake(700, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
            return rect.size.height + 50;
        } else {
            return 50;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.records.count == 0) {
        return 2;
    } else {
        return 3 + self.records.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else if (section == 1) {
        return 8 + (self.attatchFiles.count+1)/2;
    } else if(section == 2) {
        return 1;
    } else {
        NSArray *records = [self.records objectAtIndex:(section-3)];
        return records.count;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < 3) {
        return nil;
    } else {
        //前面有3个section
        ReceiveFileHandleRecord *any = [[self.records objectAtIndex:(section-3)] firstObject];
        ReceiveFileRecordHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:recordHeader];
        header.titleLabel.text = any.BLType;
        return header;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self cellForSectionOne:indexPath];
    } else if (indexPath.section == 1) {
        return [self cellForSectionTwo:indexPath];
    } else if(indexPath.section == 2){
        return [tableView dequeueReusableCellWithIdentifier:recordHeadCell forIndexPath:indexPath];
    } else {
        ReceiveFileRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCell forIndexPath:indexPath];
        NSArray *recordList = [self.records objectAtIndex:(indexPath.section-3)];
        ReceiveFileHandleRecord *record = recordList[indexPath.row];
        cell.nameLabel.text = record.UserName;
        cell.statusLabel.text = record.BLStatus;
        cell.dateLabel.text = record.BLDate;
        cell.opinionLabel.text = record.Yijian;
        return cell;
    }
}

#pragma mark - getters and setters

- (ReceiveFileHandleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [ReceiveFileHandleViewModel new];
    }
    return _viewModel;
}

- (void)setMainIdentifier:(NSString *)mainIdentifier {
    _mainIdentifier = [mainIdentifier copy];
    self.viewModel.mainGUID = [mainIdentifier copy];
}

- (NSMutableArray *)records {
    if (!_records) {
        _records = [NSMutableArray arrayWithCapacity:4];
    }
    return _records;
}

@end
