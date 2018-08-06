//
//  SendFileHandleViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/4.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendFileHandleViewController.h"
#import "InfoCell.h"
#import "AttachedFilesCell.h"
#import "SendFileRecord.h"
#import "SendFileAttatchFileInfo.h"
#import "AdviseCell.h"
#import "HandleInfoGeneralCell.h"
#import "HandleInfoGeneralHeader.h"
#import "SendFileHandleViewModel.h"
#import "MBProgressHUD+LCL.h"
#import "AttatchFileDownloader.h"
#import "FilePreViewController.h"
#import "UserService.h"
#import "SendFileService.h"
#import "CommonDatePicker.h"
#import "SendFileService.h"

static NSString *const oneItemCell = @"oneItemCell";
static NSString *const twoItemsCell = @"twoItemsCell";
static NSString *const threeItemsCell = @"threeItemsCell";
static NSString *const attachFilesCell = @"attachFilesCell";
static NSString *const handleInfoGeneralHeaderIdentfier = @"HandleInfoGeneralHeaderIdentfier";
static NSString *const handleInfoGeneralCellIdentfier = @"handleInfoGeneralCellIdentfier";
static NSString *const emptyHeaderIdentifier = @"emptyHeader";

@interface SendFileHandleViewController () <UITableViewDataSource, UITableViewDelegate, AttachedFilesCellDelegate, CommonDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SendFileDetail *dataObject;
@property (nonatomic, strong) NSArray *attachedfiles; //附件
@property (nonatomic, strong) NSArray *records; //办理情况
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeight;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) SendFileHandleViewModel *viewModel;
@property (strong, nonatomic) AdviseCell *adviceCell;

@end

@implementation SendFileHandleViewController

- (void)dealloc {
    NSLog(@"SendFileHandleViewController 销毁 ♻️");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // register cells
    [self.tableView registerNib:[UINib nibWithNibName:@"Info1Items" bundle:nil] forCellReuseIdentifier:oneItemCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"Info2Items" bundle:nil] forCellReuseIdentifier:twoItemsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"Info3Items" bundle:nil] forCellReuseIdentifier:threeItemsCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"AttachedFilesCell" bundle:nil] forCellReuseIdentifier:attachFilesCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"HandleInfoGeneralHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:handleInfoGeneralHeaderIdentfier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HandleInfoGeneralCell" bundle:nil] forCellReuseIdentifier:handleInfoGeneralCellIdentfier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:emptyHeaderIdentifier];

    
    [self loadData];
    
    if (self.shouldHiddenAdviseCell) {
        self.bottomButtonHeight.constant = 0;
    }
    
    // 尾部留白
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 100)];
    
    self.viewModel.dueDate = [[NSDate new] adviceCellDateString];

    
}

#pragma mark - data

- (void)loadData {
    RACSignal *response = [self.viewModel fileHandleData];
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"加载中..." atView:self.tableView];
    @weakify(self);
    [response subscribeNext:^(RACTuple *x) {
        @strongify(self);
        if (self) {
            self.dataObject = [x first];
            self.attachedfiles = [x second];
            self.records = [x third];
            [self.tableView reloadData];
        }
        [hud hideAnimated:YES];
    } error:^(NSError * _Nullable error) {
        [hud showMessage:error.localizedDescription];
    }];
}

- (void)reloadRecords {
    RACSignal *requestRecords = [[SendFileService shared] handleFileRecordsForIdentifier:self.identifier];
     @weakify(self);
    [requestRecords subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.records = x;
        [self.tableView reloadData];
    }];
}
#pragma mark - actions

- (IBAction)submit:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认执行操作？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        RACSignal *response = [self.viewModel saveAdvice];
        MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"提交中..." atView:nil];
        [response subscribeNext:^(id  _Nullable x) {
            [hud showMessage:@"成功提交"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidHandleTask" object:nil];
            [self reloadRecords];
        } error:^(NSError * _Nullable error) {
            [hud showMessage:error.localizedDescription];
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 点击文件按钮的回调
 
 @param cell 被点击的cell
 @param index 目前支持两个文件显示，即0或者1
 */
- (void)attachedFilesCell:(AttachedFilesCell *)cell didSelectFileAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger fileIndex = (indexPath.row-6)*2 + index;
    SendFileAttatchFileInfo *file = self.attachedfiles[fileIndex];
     [self openAttatchFile:file];
}


- (void)openAttatchFile:(SendFileAttatchFileInfo *)file {
    FilePreViewController *previewer = [FilePreViewController new];
    previewer.fileModel = file;
    FilePreviewViewModel *vm = [FilePreviewViewModel new];
    vm.recordIdentifier = self.recordIdentfier;
    previewer.viewModel = vm;
    [self.navigationController pushViewController:previewer animated:YES];
}

/**
 意见处理时间
 */
- (void)adviceChooseDate:(id)sender {
    CommonDatePicker *picker = [CommonDatePicker showDatePickerAtWindow];
    picker.identifier = @"advice";
    picker.delegate = self;
    if (self.viewModel.dueDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:self.viewModel.dueDate];
        picker.datePicker.date = date;
    } else {
        picker.datePicker.date = [NSDate new];
    }
    [picker setMinimumCurrent];
}

- (void)datePicker:(CommonDatePicker *)datePicker didTapConfirmButton:(UIButton *)button {
    if ([datePicker.identifier isEqualToString:@"advice"]) {
        NSDate *selectedDate = [datePicker datePicker].date;
        self.viewModel.dueDate = [selectedDate adviceCellDateString];
    }
    [datePicker dimissAnimated];
}
- (void)datePicker:(CommonDatePicker *)datePicker didTapCancelButton:(UIButton *)button {
    [datePicker dimissAnimated];
}

#pragma mark - views

- (void)configureAdviseCell:(AdviseCell *)cell {
    
    cell.assignmentTextField.text = [UserService shared].currentUser.UserName;
    cell.textView.text = @"已阅。";
    
    RACSignal *handled = RACObserve(self.viewModel, handled);
    RAC(cell.doing, selected) = [handled map:^NSNumber *(NSNumber *value) {
        return @(![value boolValue]);
    }];
    RAC(cell.done, selected) = handled;
    @weakify(self);
    [[cell.doing rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.handled = NO;
    }];
    [[cell.done rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.handled = YES;
    }];
    
    RACSignal *adviceSignal = cell.textView.rac_textSignal;
    RACSignal *assigmentSignal = cell.assignmentTextField.rac_textSignal;
    
    [cell.chooseDateButton addTarget:self action:@selector(adviceChooseDate:) forControlEvents:UIControlEventTouchUpInside];

    RAC(self.viewModel, advice) = adviceSignal;
    RAC(self.viewModel, signature) = assigmentSignal;
    // 都设置了落款人和意见的时候，可以发送
    // (需求上说不用校验是否填写, 此功能已经禁用）
//    RAC(self.bottomButton, enabled) = [[RACSignal combineLatest:@[adviceSignal, assigmentSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
//        return @([[value first] length] > 0 && [[value second] length] > 0);
//    }];
    
    RAC(cell.dateLabel, text) = RACObserve(self.viewModel, dueDate);
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + (self.shouldHiddenAdviseCell==NO);
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    else if (section == 1)  {
        return 6 + (self.attachedfiles.count+1)/2;
    }
    else  {
        if (self.shouldHiddenAdviseCell) {
            return self.records.count;
        } else {
            if (section == 2) {
                return 1; //处理意见
            } else {
                return self.records.count;
            }
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        InfoCell *cell;
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"发文编号：";
            cell.info2DescriptionLabel.text = @"文号：";
            cell.info1ContentLabel.text = self.dataObject.FWH;
            cell.info2ContentLabel.text = self.dataObject.WHT;
        }
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"密级：";
            cell.info2DescriptionLabel.text = @"对应收文编号:";
            cell.info1ContentLabel.text = self.dataObject.MJ;
            cell.info2ContentLabel.text = self.dataObject.DYSWH;
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"主办科室：";
            cell.info2DescriptionLabel.text = @"拟稿人：";
            cell.info1ContentLabel.text = self.dataObject.ZBKS;
            cell.info2ContentLabel.text = self.dataObject.NGR;
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:threeItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"签发人：";
            cell.info2DescriptionLabel.text = @"签发日期：";
            cell.info3DescriptionLabel.text = @"缓急：";
            cell.info1ContentLabel.text = self.dataObject.QFR;
            cell.info2ContentLabel.text = self.dataObject.QFDate;
            cell.info3ContentLabel.text = self.dataObject.HJ;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"发文标题：";
            cell.info1ContentLabel.text = self.dataObject.BT;
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"主题词：";
            cell.info1ContentLabel.text = self.dataObject.ZTC;
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        InfoCell *cell;
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:threeItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"文种：";
            cell.info2DescriptionLabel.text = @"安全级别：";
            cell.info3DescriptionLabel.text = @"打印人：";
            cell.info1ContentLabel.text = self.dataObject.WZ;
            cell.info2ContentLabel.text = self.dataObject.AQJB;
            cell.info3ContentLabel.text = self.dataObject.DYR;
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:threeItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"校对人：";
            cell.info2DescriptionLabel.text = @"页数：";
            cell.info3DescriptionLabel.text = @"份数：";
            cell.info1ContentLabel.text = self.dataObject.JDR;
            cell.info2ContentLabel.text = self.dataObject.YS;
            cell.info3ContentLabel.text = self.dataObject.FS;
        }
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"发出日期：";
            cell.info2DescriptionLabel.text = @"会签单位：";
            cell.info1ContentLabel.text = self.dataObject.FCDate;
            cell.info2ContentLabel.text = self.dataObject.HQDW;
        }
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"主送单位：";
            cell.info2DescriptionLabel.text = @"抄送单位：";
            cell.info1ContentLabel.text = self.dataObject.ZSDW;
            cell.info2ContentLabel.text = self.dataObject.CSDW;
        }
        else if (indexPath.row == 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"信息公开类目：";
            cell.info1ContentLabel.text = self.dataObject.XXGKCatalog;
        }
        else if (indexPath.row == 5) {
            cell = [tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"发文附件描述：";
            cell.info1ContentLabel.text = self.dataObject.FJMS;
        } else {
            AttachedFilesCell *fileCell = [tableView dequeueReusableCellWithIdentifier:attachFilesCell forIndexPath:indexPath];
            NSInteger expectIndex1 = (indexPath.row-6)*2;
            SendFileAttatchFileInfo *info1 = self.attachedfiles[expectIndex1];
            [fileCell.file1 setTitle:info1.FileName forState:0];
            NSInteger expectIndex2 = (indexPath.row-6)*2+1;
            if (expectIndex2 < self.attachedfiles.count) {
                fileCell.file2.hidden = NO;
                fileCell.file2LittleIcon.hidden = NO;
                SendFileAttatchFileInfo *info2 = self.attachedfiles[expectIndex2];
                [fileCell.file2 setTitle:info2.FileName forState:0];
            } else {
                fileCell.file2.hidden = YES;
                fileCell.file2LittleIcon.hidden = YES;
            }
            fileCell.delegate = self;
            return fileCell;
        }
        return cell;
    }
    else if (indexPath.section == 2 && !self.shouldHiddenAdviseCell) {
        if (!_adviceCell) {
            _adviceCell = [[[NSBundle mainBundle] loadNibNamed:@"AdviseCell" owner:nil options:nil] firstObject];
            // 都是通过RAC绑定的，不需要刷新
            [self configureAdviseCell:_adviceCell];
        }
        return _adviceCell;
    }
    else {
        HandleInfoGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:handleInfoGeneralCellIdentfier forIndexPath:indexPath];
        SendFileRecord *record = [self.records objectAtIndex:indexPath.row];
        cell.label1.text = [@([record.BLXH integerValue]) description];
        cell.label2.text = record.BLType;
        cell.label3.text = record.JBR;
        cell.label4.text = record.YiJian;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]-1) { //办理情况
        UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:handleInfoGeneralHeaderIdentfier];
        if (!header) {
            header = [[NSBundle mainBundle] loadNibNamed:@"HandleInfoGeneralHeader" owner:nil options:nil].firstObject;
        }
        return header;
    } else {
        return [tableView dequeueReusableHeaderFooterViewWithIdentifier:emptyHeaderIdentifier];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    if (section == [self numberOfSectionsInTableView:tableView]-1) {
        return 150;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 2) {
        return 70;
    }
    else if (indexPath.section == 2 && !self.shouldHiddenAdviseCell) {
        return 518;
    } else {
        return 70;
    }
}

#pragma mark - getters and setters

- (SendFileHandleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SendFileHandleViewModel new];
        _viewModel.identifier = [_identifier copy];
        _viewModel.recordIdentifier = [_recordIdentfier copy];
    }
    return _viewModel;
}

@end
