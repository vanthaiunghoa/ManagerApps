//
//  ReceiveFileHandleViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveFileHandleViewController.h"
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
#import "CommonDatePicker.h"
#import "ListPicker.h"
#import "ReceiveFileAttatchFileInfo.h"
#import "MBProgressHUD+LCL.h"
#import "ReceiveTransactionService.h"
#import "AttatchFileDownloader.h"
#import "FilePreViewController.h"
#import "UserService.h"
#import "FilePreviewViewModel.h"

static NSString *const oneItemCell = @"oneItemCell";
static NSString *const twoItemsCell = @"twoItemsCell";
static NSString *const threeItemsCell = @"threeItemsCell";
static NSString *const attachFilesCell = @"attachFilesCell";
static NSString *const fileTransferID = @"fileTransferID";
static NSString *const adviceCellID = @"AdviseCellID";
static NSString *const recordHeadCell = @"RecordHead";
static NSString *const recordHeader = @"recordHeader";
static NSString *const recordCell = @"recordCell";
static NSString *const list1Identifier = @"list1Identifier";
static NSString *const list2Identifier = @"list2Identifier";
static NSString *const list3Identifier = @"list3Identifier";
static NSString *const listTypesIdentifier = @"listTypesIdentifier";

@interface ReceiveFileHandleViewController () <UITableViewDelegate, UITableViewDataSource, ChooseNameViewDelegate, ChooseNameViewControllerDelegate, CommonDatePickerDelegate, ListPickerDelegate, AttachedFilesCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ReceiveFileHandleViewModel *viewModel;
@property (strong, nonatomic) AdviseCell *adviceCell;
@property (strong, nonatomic) FileTransferCell *fileTransferCell;

@property (strong, nonatomic) NSArray *attatchFiles;
@property (strong, nonatomic) NSMutableArray *records;

@end

@implementation ReceiveFileHandleViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"FileTransferCell" bundle:nil] forCellReuseIdentifier:fileTransferID];
    [self.tableView registerNib:[UINib nibWithNibName:@"AdviseCell" bundle:nil] forCellReuseIdentifier:adviceCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveFileRecordHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:recordHeader];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveFileRecordCell" bundle:nil] forCellReuseIdentifier:recordCell];
    
    self.title = @"收文办理";
    
    //初始化落款时间；默认勾选
    self.viewModel.signDate = [[NSDate new] adviceCellDateString];
    self.viewModel.fileDueDate = [[NSDate dateWithTimeIntervalSinceNow:24*60*60*7] fileTransferDateString];
    self.viewModel.autoGenerateAdvice = YES;
    self.viewModel.postFile = YES;
    self.viewModel.transferLeaderOperator = @"请";
    self.viewModel.transferLeaderOperation = @"阅示";
    self.viewModel.transferOperator2 = @"请";
    self.viewModel.filetype = @"办件";
    
    [self _loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data flows

- (void)_loadData {
    [self _reloadRecords];
     @weakify(self);
    [[self.viewModel receiveFileAttachFiles] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.attatchFiles = x;
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showMessage:error.localizedDescription];
    }];
    
}

- (void)_reloadRecords {
    self.records = [NSMutableArray arrayWithCapacity:6];
    [self.tableView reloadData];
    @weakify(self);
    [[self.viewModel hanldedRecords] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x count]) {
            [self.records addObject:x];
            NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
            for (NSInteger i = 3; i < self.records.count; i++) {
                [set addIndex:i];
            }
            [self.tableView reloadData];
        }
        
    } error:^(NSError * _Nullable error) {
        NSLog(@"load records encounted an error %@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showMessage:error.localizedDescription];
    } completed:^{
        NSLog(@"completed load records");
    }];
}

#pragma mark - actions

//选择姓名
- (void)chooseNameFromView:(ChooseNameView *)view {
    ChooseNameViewController *next = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseNameViewController"];
    next.referenceObject = view;
    next.delegate = self;
    if (view != _fileTransferCell.mainChooseName) {
        next.mode = ChooseNameModeMultiple;
    }
    if (view == _fileTransferCell.chooseName1) {
        [next setSelectedPersonel:self.viewModel.transferLeaderReceivers];
    } else if (view == _fileTransferCell.assistChooseName) {
        [next setSelectedPersonel:self.viewModel.transferAssistReceivers];
    } else if (view == _fileTransferCell.readChooseName) {
        [next setSelectedPersonel:self.viewModel.transferReadReceivers];
    }
    [self.navigationController pushViewController:next animated:YES];
}
//取消当前的选择
- (void)cancelNameFromView:(ChooseNameView *)view {
    if (view == _fileTransferCell.mainChooseName) {
        self.viewModel.transferMainReceiver = nil;
    }
}

// 选择人员的回调
- (void)controller:(ChooseNameViewController *)controller didChoosePersonel:(Personel *)aGuy {
    [self.navigationController popViewControllerAnimated:YES]; //关闭选择人员视图
    if (controller.referenceObject == _fileTransferCell.mainChooseName) {
        self.viewModel.transferMainReceiver = aGuy;
    }
    [self updateAutoGenerateAdvice];
}

- (void)controller:(ChooseNameViewController *)controller didConfirmPensonel:(NSArray<Personel *> *)confirmGuys {
    if (controller.referenceObject == _fileTransferCell.chooseName1) { //领导
        self.viewModel.transferLeaderReceivers = confirmGuys;
    } else if (controller.referenceObject == _fileTransferCell.assistChooseName) {
        self.viewModel.transferAssistReceivers = confirmGuys;
    }  else if (controller.referenceObject == _fileTransferCell.readChooseName) {
        self.viewModel.transferReadReceivers = confirmGuys;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self updateAutoGenerateAdvice];
}

/**
 意见处理时间
 */
- (void)adviceChooseDate:(id)sender {
    CommonDatePicker *picker = [CommonDatePicker showDatePickerAtWindow];
    picker.identifier = @"advice";
    picker.delegate = self;
    if (self.viewModel.signDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:self.viewModel.signDate];
        picker.datePicker.date = date;
    } else {
        picker.datePicker.date = [NSDate new];
    }
    [picker setMinimumCurrent];
}

- (void)fileTransferChooseDate:(id)sender {
    CommonDatePicker *picker = [CommonDatePicker showDatePickerAtWindow];
    picker.datePicker.datePickerMode = UIDatePickerModeDate;
    picker.identifier = @"fileTransfer";
    picker.delegate = self;
    if (self.viewModel.fileDueDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:self.viewModel.fileDueDate];
        picker.datePicker.date = date;
    } else {
        picker.datePicker.date = [NSDate new];
    }
    [picker setMinimumCurrent];
    
}

- (void)datePicker:(CommonDatePicker *)datePicker didTapConfirmButton:(UIButton *)button {
    if ([datePicker.identifier isEqualToString:@"advice"]) {
        NSDate *selectedDate = [datePicker datePicker].date;
        self.viewModel.signDate = [selectedDate adviceCellDateString];
    } else {
        NSDate *selectedDate = [datePicker datePicker].date;
        self.viewModel.fileDueDate = [selectedDate fileTransferDateString];
    }
    [datePicker dimissAnimated];
}
- (void)datePicker:(CommonDatePicker *)datePicker didTapCancelButton:(UIButton *)button {
    [datePicker dimissAnimated];
}

- (void)listPicker:(ListPicker *)picker didSelectItemAtIndex:(NSInteger)index title:(NSString *)title {
    if ([picker.identifier isEqualToString:list1Identifier]) {
        self.viewModel.transferLeaderOperator = title;
        _fileTransferCell.operationText.text = title;
        _fileTransferCell.operationKind.text = [@(index+1) description]; 
    }
    if ([picker.identifier isEqualToString:list2Identifier]) {
        self.viewModel.transferLeaderOperation = title;
        _fileTransferCell.operation2Text.text = title;
        _fileTransferCell.operationKind2.text = [@(index+1) description];
    }
    if ([picker.identifier isEqualToString:list3Identifier]) {
        self.viewModel.transferOperator2 = title;
        _fileTransferCell.operationPart2Text.text = title;
        _fileTransferCell.operationPart2Kind.text = [@(index+1) description];
    }
    if ([picker.identifier isEqualToString:listTypesIdentifier]) {
        self.viewModel.filetype = title;
        _fileTransferCell.handleKind.text = title;
    }
    [picker dismissAnimated];
    [self updateAutoGenerateAdvice];
}
- (void)listPicker:(ListPicker *)picker didSelectHeader:(id)sender {
    
}
- (void)listPicker:(ListPicker *)picker didSelectFooter:(id)sender {
    [picker dismissAnimated];
}

- (IBAction)tempSave:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"正在保存.." atView:self.view];
    [[self.viewModel saveAdvice] subscribeNext:^(id  _Nullable x) {
        [hud showMessage:@"意见保存成功"];
        [self _reloadRecords];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidHandleTask" object:nil];
    } error:^(NSError * _Nullable error) {
        [hud showMessage:error.localizedDescription];
    }];
}

- (IBAction)saveAndExit:(id)sender {
    @weakify(self);
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"正在保存.." atView:nil];
    [[self.viewModel saveAdvice] subscribeNext:^(id  _Nullable x) {
        [hud showMessage:@"意见保存成功"];
        @strongify(self);
        if (self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userDidHandleTask" object:nil];
    } error:^(NSError * _Nullable error) {
        [hud showMessage:error.localizedDescription];
    }];
}

/**
 点击文件按钮的回调
 
 @param cell 被点击的cell
 @param index 目前支持两个文件显示，即0或者1
 */
- (void)attachedFilesCell:(AttachedFilesCell *)cell didSelectFileAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger fileIndex = (indexPath.row-4)*2 + index;
    ReceiveFileAttatchFileInfo *file = self.attatchFiles[fileIndex];
    [self openAttatchFile:file];

}

- (void)openAttatchFile:(ReceiveFileAttatchFileInfo *)file {
    FilePreViewController *previewer = [FilePreViewController new];
    previewer.fileModel = file;
    FilePreviewViewModel *viewModel = [FilePreviewViewModel new];
    viewModel.recordIdentifier = self.mainGUID;
    previewer.viewModel = viewModel;
    [self.navigationController pushViewController:previewer animated:YES];
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
    
    RAC(cell.dateLabel, text) = RACObserve(self.viewModel, signDate);
}

- (void)configureFileTransferCell:(FileTransferCell *)cell {
    // 选择名单状态绑定
    RACSignal *transferLeaderReceivers = RACObserve(self.viewModel, transferLeaderReceivers);
    RACSignal *transferMainReceiver = RACObserve(self.viewModel, transferMainReceiver);
    RACSignal *transferAssitsReceiver = RACObserve(self.viewModel, transferAssistReceivers);
    RACSignal *transferReadReceivers = RACObserve(self.viewModel, transferReadReceivers);
    RAC(cell.chooseName1, state) = [transferLeaderReceivers mapToState];
    RAC(cell.mainChooseName, state) = [transferMainReceiver mapToState];
    RAC(cell.assistChooseName, state) = [transferAssitsReceiver mapToState];
    RAC(cell.readChooseName, state) = [transferReadReceivers mapToState];
    RAC(cell.chooseName1.nameLabel, text) = [transferLeaderReceivers mapToName];
    RAC(cell.mainChooseName.nameLabel, text) = [transferMainReceiver mapToName];
    RAC(cell.assistChooseName.nameLabel, text) = [transferAssitsReceiver mapToName];
    RAC(cell.readChooseName.nameLabel, text) = [transferReadReceivers mapToName];
    RAC(cell.deadlineaLabel, text) = RACObserve(self.viewModel, fileDueDate);
    cell.chooseName1.delegate = self;
    cell.mainChooseName.delegate = self;
    cell.assistChooseName.delegate = self;
    cell.readChooseName.delegate = self;
    [cell.chooseDeadline addTarget:self action:@selector(fileTransferChooseDate:) forControlEvents:UIControlEventTouchUpInside];

    @weakify(self);
    [[cell.operationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ListPicker *picker = [ListPicker listPickerWithTitles:@[@"请", @"呈"] delegate:self];
        picker.identifier = list1Identifier;
    }];
    
    [[cell.operation2Button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ListPicker *picker = [ListPicker listPickerWithTitles:@[@"阅示", @"批办", @"阅"] delegate:self];
        picker.identifier = list2Identifier;
    }];
    
    [[cell.operationPart2Button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ListPicker *picker = [ListPicker listPickerWithTitles:@[@"请", @"并", @"拟"] delegate:self];
        picker.identifier = list3Identifier;
    }];
    
    [[cell.chooseHandleKind rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ListPicker *picker = [ListPicker listPickerWithTitles:@[@"办件", @"阅件"] delegate:self];
        picker.identifier = listTypesIdentifier;
    }];

    // 4个选项
    RAC(cell.trackingButton, selected) = RACObserve(self.viewModel, tracking);
    RAC(cell.sendMessageButton, selected) = RACObserve(self.viewModel, sendMessage);
    RAC(cell.autoGenerateButton, selected) = RACObserve(self.viewModel, autoGenerateAdvice);
    RAC(cell.transferFileButton, selected) = RACObserve(self.viewModel, postFile);

    [[cell.trackingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.tracking = !self.viewModel.tracking;
    }];
    
    [[cell.sendMessageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.sendMessage = !self.viewModel.sendMessage;
    }];
    
    [[cell.autoGenerateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.autoGenerateAdvice = !self.viewModel.autoGenerateAdvice;
        if (self.viewModel.autoGenerateAdvice) {
            self.adviceCell.textView.text = [self.viewModel autoGenerateSentence];
        }
    }];
    
    [[cell.transferFileButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.postFile = !self.viewModel.postFile;
    }];
}

- (void)updateAutoGenerateAdvice {
    if (self.viewModel.autoGenerateAdvice) {
        _adviceCell.textView.text = [self.viewModel autoGenerateSentence];
    }
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3 + 1 + self.records.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section <= 3) {
        return nil;
    } else {
        //前面有3个section
        ReceiveFileHandleRecord *any = [[self.records objectAtIndex:(section-4)] firstObject];
        ReceiveFileRecordHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:recordHeader];
        header.titleLabel.text = any.BLType;
        return header;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4 + (self.attatchFiles.count+1)/2; // 4 + (附件个数+1)/2
    } else if (section <= 3) {
        return 1;
    } else {
        NSArray *recordsOfSection = [self.records objectAtIndex:section-4];
        return recordsOfSection.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"收文编号：";
            cell.info1ContentLabel.text = self.detail.SWBH;
            cell.info2DescriptionLabel.text = @"收文日期：";
            cell.info2ContentLabel.text = self.detail.SWDate;
            return cell;
        }
        else if (indexPath.row == 1) {
            InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:twoItemsCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"文号：";
            cell.info1ContentLabel.text = self.detail.WH;
            cell.info2DescriptionLabel.text = @"来文单位：";
            cell.info2ContentLabel.text = self.detail.LWDW;
            return cell;
        }
        else if (indexPath.row == 2) {
            InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"文件标题：";
            cell.info1ContentLabel.text = self.detail.Title;
            return cell;
        }
        else if (indexPath.row == 3) {
            InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:oneItemCell forIndexPath:indexPath];
            cell.info1DescriptionLabel.text = @"备注：";
            cell.info1ContentLabel.text = self.detail.Memo;
            return cell;
        } else {
            AttachedFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:attachFilesCell forIndexPath:indexPath];
            cell.delegate = self;
            NSInteger index = (indexPath.row-4)*2;
            ReceiveFileAttatchFileInfo *file1 = self.attatchFiles[index];
            [cell.file1 setTitle:file1.Name forState:0];
            if (index+1 < self.attatchFiles.count) {
                ReceiveFileAttatchFileInfo *file2 = self.attatchFiles[index+1];
                cell.file2.hidden = NO;
                cell.file2LittleIcon.hidden = NO;
                [cell.file2 setTitle:file2.Name forState:0];
            } else {
                cell.file2.hidden = YES;
                cell.file2LittleIcon.hidden = YES;
            }
            
            return cell;
        }
        
    }
    else if (indexPath.section == 1) {
        if (!_fileTransferCell) {
            _fileTransferCell = [tableView dequeueReusableCellWithIdentifier:fileTransferID forIndexPath:indexPath];
            [self configureFileTransferCell:_fileTransferCell];
        }
        return _fileTransferCell;
    }
    else if (indexPath.section == 2) {
        if (!_adviceCell) {
            _adviceCell = [[[NSBundle mainBundle] loadNibNamed:@"AdviseCell" owner:nil options:nil] firstObject];
            // 都是通过RAC绑定的，不需要刷新
            [self configureAdviseCell:_adviceCell];
        }
        return _adviceCell;
    }
    else if(indexPath.section == 3){
        return [tableView dequeueReusableCellWithIdentifier:recordHeadCell forIndexPath:indexPath];
    } else {
        ReceiveFileRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:recordCell forIndexPath:indexPath];
        NSArray *recordList = [self.records objectAtIndex:(indexPath.section-4)];
        ReceiveFileHandleRecord *record = recordList[indexPath.row];
        cell.nameLabel.text = record.UserName;
        cell.statusLabel.text = record.BLStatus;
        cell.dateLabel.text = record.BLDate;
        cell.opinionLabel.text = record.Yijian;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70; //基本信息
    } else if (indexPath.section == 1) {
        return 412; //转派文件
    } else if (indexPath.section == 2) {
        return 518; //意见处理
    } else if  (indexPath.section == 3) {
        return 70;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 4) {
        return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    } else {
        NSArray *records = [self.records objectAtIndex:(indexPath.section-4)];
        ReceiveFileHandleRecord *record = records[indexPath.row];
        if ([record.Yijian length] > 0) {
            CGRect rect = [record.Yijian boundingRectWithSize:CGSizeMake(700, 800) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
            return rect.size.height + 50;
        } else {
            return 50;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section <= 3) {
        return 0.1;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < 3) {
        return 10.0;
    } else {
        return 0.1;
    }
}


#pragma mark - getters and setters

- (ReceiveFileHandleViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [ReceiveFileHandleViewModel new];
    }
    return _viewModel;
}

- (void)setMainGUID:(NSString *)recordIdentfier {
    _mainGUID = [recordIdentfier copy];
    self.viewModel.mainGUID = [recordIdentfier copy];
}

- (void)setWhereGUID:(NSString *)whereGUID {
    _whereGUID = [whereGUID copy];
    self.viewModel.whereGUID = [whereGUID copy];
}

@end
