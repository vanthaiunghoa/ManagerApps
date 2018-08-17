//
//  ReceiveRetrievalFilterViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveRetrievalFilterViewController.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "SinglePickerCell.h"
#import "DoublePickerCell.h"
#import "InputCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "XLsn0wPickerSingler.h"
#import "PGDatePickManager.h"
#import "RequestManager.h"
#import "FileTypeModel.h"
#import <MJExtension/MJExtension.h>

@interface ReceiveRetrievalFilterViewController ()<UITableViewDelegate, UITableViewDataSource, InputCellDelegate, SinglePickerCellDelegate, DoublePickerCellDelegate, XLsn0wPickerSinglerDelegate, PGDatePickerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SinglePickerCell *hjCell;
@property (strong, nonatomic) SinglePickerCell *whnCell;
@property (strong, nonatomic) DoublePickerCell *doublePickerCell;
@property (assign, nonatomic) SelectType selectType;
@property (strong, nonatomic) NSMutableArray<NSString *> *hjArr;

@end

@implementation ReceiveRetrievalFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    self.title = @"筛选查询条件";
    
    [self addClearButton];
    [self initTableView];
    [self initBottomView];
}

- (void)addClearButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setTitle:@"清空" forState:0];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[InputCell class] forCellReuseIdentifier:NSStringFromClass([InputCell class])];
    [self.tableView registerClass:[SinglePickerCell class] forCellReuseIdentifier:NSStringFromClass([SinglePickerCell class])];
    [self.tableView registerClass:[DoublePickerCell class] forCellReuseIdentifier:NSStringFromClass([DoublePickerCell class])];
}

- (void)initBottomView
{
    float x = 0;
    float w = SCREEN_WIDTH / 2.0;
    
    NSArray *titles = @[@"确定", @"取消"];
    
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

- (void)clearClicked:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认清空之前的选择？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        
        [self.dict setObject:@"" forKey:@"流水号"];          // 收文流水号
        [self.dict setObject:@"" forKey:@"缓急"];           // 文件缓急
        
        [self.dict setObject:@"" forKey:@"文号头"];         // 文号头
        [self.dict setObject:@"" forKey:@"文号年"];         // 文号年
        
        [self.dict setObject:@"" forKey:@"文号数"];         // 文号数
        [self.dict setObject:@"" forKey:@"标题"];           // 标题
        
        [self.dict setObject:@"" forKey:@"来文单位"];        // 来文单位
        [self.dict setObject:@"" forKey:@"成文时间开始"];     //
        [self.dict setObject:@"" forKey:@"成文时间结束"];     //

        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)bottomClicked:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [_delegate controller:self didConfirmFilter:_dict];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - method


#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 2)
    {
        InputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InputCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        
        if(indexPath.row == 0)
        {
            cell.key = @"流水号";
            cell.value = _dict[@"流水号"];
        }
        else
        {
            cell.key = @"文号头";
            cell.value = _dict[@"文号头"];
        }

        return cell;
    }
    else if(indexPath.row == 2) // 文号年
    {
        if(_whnCell == nil)
        {
            _whnCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SinglePickerCell class])];
            [_whnCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            _whnCell.delegate = self;
        }
        _whnCell.key = @"文号年";
        _whnCell.value = _dict[@"文号年"];
        
        return _whnCell;
    }
    if(indexPath.row > 2 && indexPath.row < 6)
    {
        InputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InputCell class])];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        
        if(indexPath.row == 3)
        {
            cell.key = @"文号数";
            cell.value = _dict[@"文号数"];
        }
        else if(indexPath.row == 4)
        {
            cell.key = @"标题";
            cell.value = _dict[@"标题"];
        }
        else
        {
            cell.key = @"来文单位";
            cell.value = _dict[@"来文单位"];
        }
        
        return cell;
    }
    else if(indexPath.row == 6) // 缓急
    {
        if(_hjCell == nil)
        {
            _hjCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SinglePickerCell class])];
            [_hjCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            _hjCell.delegate = self;
        }
        _hjCell.key = @"缓急";
        _hjCell.value = _dict[@"缓急"];
        
        return _hjCell;
    }
    else
    {
        if(_doublePickerCell == nil)
        {
            _doublePickerCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DoublePickerCell class])];
            [_doublePickerCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            _doublePickerCell.delegate = self;
        }
        _doublePickerCell.key = @"成文时间";
        _doublePickerCell.beginTime = _dict[@"成文时间开始"];
        _doublePickerCell.endTime = _dict[@"成文时间结束"];
        
        return _doublePickerCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark InputCellDelegate

- (void)textFieldDidChange:(NSString *)valueOfKey value:(NSString *)value
{
    self.dict[valueOfKey] = value;
}

#pragma mark -  DoublePickerCellDelegate

- (void)didDoublePickerCellBtnClicked:(NSInteger)tag
{
    if(tag == 0)
    {
        self.selectType = HandlerBeginTime;
    }
    else
    {
        self.selectType = HandlerEndTime;
    }
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];

    //设置半透明的背景颜色
    datePickManager.isShadeBackgroud = true;
    //设置线条的颜色
    datePicker.lineBackgroundColor = [UIColor lightGrayColor];
    //设置选中行的字体颜色
    datePicker.textColorOfSelectedRow = [UIColor blackColor];
    //设置取消按钮的字体颜色
    datePickManager.cancelButtonTextColor = GrayColor;
    //设置取消按钮的字
    datePickManager.cancelButtonText = @"取消";
    //设置取消按钮的字体大小
    datePickManager.cancelButtonFont = [UIFont boldSystemFontOfSize:20];
    //设置确定按钮的字体颜色
    datePickManager.confirmButtonTextColor = [UIColor colorWithHex:0x3D98FF];
    //设置确定按钮的字
    datePickManager.confirmButtonText = @"确定";
    //设置确定按钮的字体大小
    datePickManager.confirmButtonFont = [UIFont boldSystemFontOfSize:20];
}

#pragma mark - data

- (void)loadHJData
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    
    @weakify(self);
    [[RequestManager shared] requestWithAction:@"GetSD_WJHJ_List" appendingURL:@"Handlers/SWMan/SWHandlers.ashx" parameters:nil callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        
        if (success)
        {
            [SVProgressHUD dismiss];
            NSArray *tmp = [FileTypeModel mj_objectArrayWithKeyValuesArray:data[@"Datas"]];
            if(tmp.count)
            {
                for(FileTypeModel *p in tmp)
                {
                    [self.hjArr addObject:p.Value];
                }
                
                XLsn0wPickerSingler *singler = [[XLsn0wPickerSingler alloc] initWithArrayData:self.hjArr unitTitle:@"" xlsn0wDelegate:self];
                [singler show];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"暂无缓急类型"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

#pragma mark - SinglePickerCellDelegate

- (void)didSinglePickerCellBtnClicked:(NSString *)valueOfKey
{
    if([valueOfKey isEqualToString:@"缓急"])
    {
        if(self.hjArr.count == 1)
        {
            [self loadHJData];
        }
        else
        {
            XLsn0wPickerSingler *singler = [[XLsn0wPickerSingler alloc] initWithArrayData:self.hjArr unitTitle:@"" xlsn0wDelegate:self];
            [singler show];
        }
    }
    else
    {
        self.selectType = WHN;
        
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerMode = PGDatePickerModeYear;
        [self presentViewController:datePickManager animated:false completion:nil];
        
        //设置半透明的背景颜色
        datePickManager.isShadeBackgroud = true;
        //设置线条的颜色
        datePicker.lineBackgroundColor = [UIColor lightGrayColor];
        //设置选中行的字体颜色
        datePicker.textColorOfSelectedRow = [UIColor blackColor];
        //设置取消按钮的字体颜色
        datePickManager.cancelButtonTextColor = GrayColor;
        //设置取消按钮的字
        datePickManager.cancelButtonText = @"取消";
        //设置取消按钮的字体大小
        datePickManager.cancelButtonFont = [UIFont boldSystemFontOfSize:20];
        //设置确定按钮的字体颜色
        datePickManager.confirmButtonTextColor = [UIColor colorWithHex:0x3D98FF];
        //设置确定按钮的字
        datePickManager.confirmButtonText = @"确定";
        //设置确定按钮的字体大小
        datePickManager.confirmButtonFont = [UIFont boldSystemFontOfSize:20];
    }
}

#pragma mark - XLsn0wPickerSinglerDelegate

- (void)pickerSingler:(XLsn0wPickerSingler *)pickerSingler selectedTitle:(NSString *)selectedTitle selectedRow:(NSInteger)selectedRow
{
    if([selectedTitle isEqualToString:@"不选择"])
    {
        self.dict[@"缓急"] = @"";
    }
    else
    {
        self.dict[@"缓急"] = selectedTitle;
    }
    _hjCell.value = selectedTitle;
}

#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents
{
    NSString *formatTime = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    if(dateComponents.month < 10)
    {
        formatTime = [NSString stringWithFormat:@"%ld-0%ld-%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }
    if(dateComponents.day < 10)
    {
        formatTime = [NSString stringWithFormat:@"%ld-%ld-0%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }
    if(dateComponents.month < 10 && dateComponents.day < 10)
    {
        formatTime = [NSString stringWithFormat:@"%ld-0%ld-0%ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    }
    
    if(self.selectType == WHN)
    {
        NSString *value = [NSString stringWithFormat:@"%ld", (long)dateComponents.year];
        self.dict[@"文号年"] = value;
        _whnCell.value = value;
    }
    else if(self.selectType == HandlerBeginTime)
    {
        self.dict[@"成文时间开始"] = formatTime;
        _doublePickerCell.beginTime = formatTime;
    }
    else
    {
        self.dict[@"成文时间结束"] = formatTime;
        _doublePickerCell.endTime = formatTime;
    }
}

#pragma mark - lazy load

- (NSMutableArray<NSString *> *)hjArr
{
    if(_hjArr == nil)
    {
        _hjArr = [NSMutableArray array];
        [_hjArr addObject:@"不选择"];
    }
    
    return _hjArr;
}


@end
