//
//  AddressDetailViewController.m
//  WanveTest
//
//  Created by wanve on 2018/1/23.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "AddressModel.h"
#import "DetailCell.h"
#import "UIColor+color.h"

@interface AddressDetailViewController ()<DetailCellDelegate>

@property (nonatomic, strong) NSMutableArray *phones;

@end

@implementation AddressDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:NSStringFromClass([DetailCell class])];
    
    [self initView];
    _phones = [[NSMutableArray alloc] init];
    [self initDatas];
}

- (void)initView
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, 200)];
    head.backgroundColor = [UIColor colorWithHexString:@"#3FA6CF"];
    self.tableView.tableHeaderView = head;
    
    UILabel *name = [UILabel new];
    [head addSubview:name];
    name.text = _userListModel.UserName;
    name.textColor = [UIColor whiteColor];
//    name.font = [UIFont systemFontOfSize:15];
    
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.left).offset(30);
        make.top.equalTo(head.top).offset(75);
        make.height.equalTo(@20);
    }];
    
    UILabel *departmant = [UILabel new];
    [head addSubview:departmant];
    departmant.text = _userListModel.kSName;
    departmant.textColor = [UIColor whiteColor];
//    departmant.font = [UIFont systemFontOfSize:15];
    
    [departmant makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.left).offset(30);
        make.bottom.equalTo(head.bottom).offset(-75);
        make.height.equalTo(@20);
    }];
}

- (void)initDatas
{
    if(_userListModel.MobileNumber.length != 0)
    {
        AddressDetailModel *model = [AddressDetailModel new];
        model.number = _userListModel.MobileNumber;
        model.type = @"用户手机号";
        [_phones addObject:model];
    }
    if(_userListModel.MobileNumber2.length != 0)
    {
        AddressDetailModel *model = [AddressDetailModel new];
        model.number = _userListModel.MobileNumber2;
        model.type = @"用户手机号2";
        [_phones addObject:model];
    }
    if(_userListModel.OfficeNumber.length != 0)
    {
        AddressDetailModel *model = [AddressDetailModel new];
        model.number = _userListModel.OfficeNumber;
        model.type = @"办公电话";
        [_phones addObject:model];
    }
    if(_userListModel.HomeNumber.length != 0)
    {
        AddressDetailModel *model = [AddressDetailModel new];
        model.number = _userListModel.HomeNumber;
        model.type = @"家庭电话";
        [_phones addObject:model];
    }
    if(_userListModel.ShortNumber.length != 0)
    {
        AddressDetailModel *model = [AddressDetailModel new];
        model.number = _userListModel.ShortNumber;
        model.type = @"短号";
        [_phones addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _phones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailCell class])];
    cell.delegate = self;
    cell.model = _phones[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - DetailCellDelegate

- (void)call:(AddressDetailModel *)model
{
    PLog(@"yo");
}

- (void)sendMessage:(AddressDetailModel *)model
{
    PLog(@"yo");
}


@end
