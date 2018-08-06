//
//  SelectViewController.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectCell.h"
#import "SelectHeaderView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "RequestManager.h"
#import "UserService.h"
#import "NSDictionary+CreateModel.h"
#import "Organization.h"
#import "Personel.h"
#import <MJExtension/MJExtension.h>
#import "MBProgressHUD+LCL.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SelectViewController ()<UITableViewDelegate, UITableViewDataSource, SelectHeaderViewDelegate, SelectCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
//@property (copy, nonatomic) NSArray<Organization *> *readonlyOrganization;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    self.title = @"选择经办人";
    
    [self addClearButton];
    [self initTableView];
    [self initBottomView];
    if(self.organizations.count == 0)
    {
        [self loadOrganizations];
    }
    else
    {
        [self.tableView reloadData];
    }
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
    
    [self.tableView registerClass:[SelectHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SelectHeaderView class])];
    [self.tableView registerClass:[SelectCell class] forCellReuseIdentifier:NSStringFromClass([SelectCell class])];
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

#pragma mark - data

- (void)loadOrganizations
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;

    @weakify(self);
    [[RequestManager shared] requestWithAction:UserServiceGetOrganizationListAction appendingURL:UserServiceURL parameters:@{} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            NSArray *responseData = data[@"Datas"];
            self.organizations = [Organization mj_objectArrayWithKeyValuesArray:responseData];
            [self.tableView reloadData];
        } else {
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = error.localizedDescription;
//            [hud hideAnimated:YES afterDelay:2.0];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

- (void)loadStaff:(NSInteger )indexPath
{
    Organization *org = self.organizations[indexPath];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    self.view.userInteractionEnabled = NO;
    @weakify(self);
    [[RequestManager shared] requestWithAction:UserServiceGetStaffListAction appendingURL:UserServiceURL parameters:@{@"KSCode": org.KSCode, @"UserRightType": @"", @"QZH": org.QZH} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
            NSArray *responseData = data;
            [responseData.firstObject createModelWithName:@"Personel"];
            self.organizations[indexPath].staff = [Personel mj_objectArrayWithKeyValuesArray:responseData];
            
            [self initDatas:indexPath];
        } else {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = error.localizedDescription;
//            [hud hideAnimated:YES afterDelay:2.0];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
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
        for(int i = 0; i < self.organizations.count; ++i)
        {
            self.organizations[i].isSelect = NO;
            if(self.organizations[i].staff != nil)
            {
                for(int j = 0; j < self.organizations[i].staff.count; ++j)
                {
                    self.organizations[i].staff[j].selectMode = SelectNone;
                }
            }
        }
        
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)bottomClicked:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        [_delegate controller:self didConfirmPensonel:self.organizations];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SelectHeaderViewDelegate

- (void)didSelectIndexPath:(NSInteger )indexPath
{
    if(self.organizations[indexPath].staff == nil || self.organizations[indexPath].staff.count == 0)
    {
        [self loadStaff:indexPath];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (void)didSelectRead:(NSInteger )indexPath
{
    if(self.organizations[indexPath].staff == nil || self.organizations[indexPath].staff.count == 0)
    {
        [self loadStaff:indexPath];
        
    }
    else
    {
        [self initDatas:indexPath];
    }
}

#pragma mark - SelectCellDelegate

- (void)updateDepartmentSelectStatus:(NSIndexPath *)indexPath
{
    BOOL isSelect = YES;
    for(int i = 0; i < self.organizations[indexPath.section].staff.count; ++i)
    {
        if(self.organizations[indexPath.section].staff[i].selectMode != SelectRead)
        {
            isSelect = NO;
            break;
        }
    }
    
    self.organizations[indexPath.section].isSelect = isSelect;
    [self.tableView reloadData];
}

#pragma mark - method

- (void)initDatas:(NSUInteger )indexPath
{
    if(self.organizations[indexPath].isSelect)
    {
        for(Personel *p in self.organizations[indexPath].staff)
        {
            p.selectMode = SelectRead;
        }
    }
    else
    {
        for(Personel *p in self.organizations[indexPath].staff)
        {
            p.selectMode = SelectNone;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.organizations.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SelectHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SelectHeaderView class])];
    header.model = self.organizations[section];
    header.indexPath = section;
    header.delegate = self;
    return header;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.organizations[section].isExpand){
        //如果是展开状态
//        return self.organizations[section].staff.count;
        
        if(self.organizations[section].staff == nil)
        {
            return 0;
        }
        return self.organizations[section].staff.count;
    }else{
        //如果是闭合，返回0
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectCell class])];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.organizations[indexPath.section].staff[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if(indexPath.row == self.organizations[indexPath.section].staff.count - 1)
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
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - lazy load

- (NSMutableArray<Organization *> *)organizations
{
    if(_organizations == nil)
    {
        _organizations = [NSMutableArray array];
    }
    
    return _organizations;
}


@end
