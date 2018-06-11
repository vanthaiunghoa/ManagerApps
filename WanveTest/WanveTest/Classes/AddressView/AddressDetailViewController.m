//
//  AddressDetailViewController.m
//  WanveTest
//
//  Created by wanve on 2018/1/23.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "AddressDetailViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "AddressModel.h"
#import "DetailCell.h"
#import "UIColor+color.h"

@interface AddressDetailViewController ()<DetailCellDelegate, MFMessageComposeViewControllerDelegate>

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
    name.font = [UIFont systemFontOfSize:15];
    
    [name makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.left).offset(30);
        make.top.equalTo(head.top).offset(77);
        make.height.equalTo(@18);
    }];
    
    UILabel *departmant = [UILabel new];
    [head addSubview:departmant];
    departmant.text = _userListModel.kSName;
    departmant.textColor = [UIColor whiteColor];
    departmant.font = [UIFont systemFontOfSize:15];
    
    [departmant makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.left).offset(30);
        make.bottom.equalTo(head.bottom).offset(-77);
        make.height.equalTo(@18);
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
    return 54;
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
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", model.number];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)sendMessage:(AddressDetailModel *)model
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        // 设置短信内容
        vc.body = @"";
        // 设置收件人列表
        vc.recipients = @[model.number];  // 号码数组
        // 设置代理
        vc.messageComposeDelegate = self;
        // 显示控制器
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
    {
        PLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        PLog(@"Message sent");
    }
    else
    {
        PLog(@"Message failed");
    }
}


@end
