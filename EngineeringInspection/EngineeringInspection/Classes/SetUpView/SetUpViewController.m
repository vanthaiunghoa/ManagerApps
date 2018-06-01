//
//  SetUpViewController.m
//  HSSetTableViewCtrollerDemo
//
//  Created by hushaohui on 2017/7/24.
//  Copyright © 2017年 ZLHD. All rights reserved.
//

#import "SetUpViewController.h"
#import "HSSetTableViewController.h"
#import "UserModel.h"
#import "UserManager.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

@interface SetUpViewController ()

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hs_colorWithHexString:@"#EBEDEF"];
    
    [self initTableView];
}

- (void)initTableView
{
    [self initSetTableViewConfigureStyle:UITableViewStylePlain];
    
    HSTextCellModel *version = [[HSTextCellModel alloc] initWithTitle:@"版本更新" detailText:@"当前版本1.0.1" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"版本更新")
    }];
    version.showArrow = NO;
    
    HSTitleCellModel *qrCode = [[HSTitleCellModel alloc] initWithTitle:@"应用二维码" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"应用二维码")
    }];
    
    HSTitleCellModel *clean = [[HSTitleCellModel alloc] initWithTitle:@"数据清空" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"数据清空")
    }];
    
    HSTitleCellModel *task = [[HSTitleCellModel alloc] initWithTitle:@"任务禁用及恢复" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"任务禁用及恢复")
    }];
    
    HSTitleCellModel *synchronization = [[HSTitleCellModel alloc] initWithTitle:@"同步策略" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"同步策略")
    }];
    
    HSTitleCellModel *update = [[HSTitleCellModel alloc] initWithTitle:@"更新说明" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"更新说明")
    }];
    
    HSTitleCellModel *privacy = [[HSTitleCellModel alloc] initWithTitle:@"隐私政策" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"隐私政策")
    }];
    
    HSTitleCellModel *about = [[HSTitleCellModel alloc] initWithTitle:@"关于我们" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"关于我们")
    }];
    
    HSTitleCellModel *service = [[HSTitleCellModel alloc] initWithTitle:@"服务条款" actionBlock:^(HSBaseCellModel *model) {
        HSLog(@"服务条款")
    }];
    
    HSTitleCellModel *logout = [[HSTitleCellModel alloc] initWithTitle:@"退出登录" actionBlock:^(HSBaseCellModel *model) {
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.username = @"";
        userModel.password = @"";
        userModel.isAutoLogin = NO;
        userModel.isLogout = YES;
        [[UserManager sharedUserManager] saveUserModel:userModel];
        
        LoginViewController *vc = [LoginViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
    logout.showArrow = NO;
    //    about.titleColor = [UIColor redColor];
    logout.titileTextAlignment = NSTextAlignmentCenter;
    
    NSMutableArray *section0 = [NSMutableArray arrayWithObjects:version, nil];
    NSMutableArray *section = [NSMutableArray arrayWithObjects:qrCode, nil];
    NSMutableArray *section1 = [NSMutableArray arrayWithObjects:clean, nil];
    NSMutableArray *section2 = [NSMutableArray arrayWithObjects:task, nil];
    NSMutableArray *section3 = [NSMutableArray arrayWithObjects:synchronization, nil];
    NSMutableArray *section4 = [NSMutableArray arrayWithObjects:update, nil];
    NSMutableArray *section5 = [NSMutableArray arrayWithObjects:privacy, nil];
    NSMutableArray *section6 = [NSMutableArray arrayWithObjects:clean,nil];
    NSMutableArray *section7 = [NSMutableArray arrayWithObjects:about, nil];
    NSMutableArray *section8 = [NSMutableArray arrayWithObjects:service, nil];
    NSMutableArray *section9 = [NSMutableArray arrayWithObjects:logout, nil];
    
    [self.hs_dataArry addObject:section0];
    [self.hs_dataArry addObject:section];
    [self.hs_dataArry addObject:section1];
    [self.hs_dataArry addObject:section2];
    [self.hs_dataArry addObject:section3];
    [self.hs_dataArry addObject:section4];
    [self.hs_dataArry addObject:section5];
    [self.hs_dataArry addObject:section6];
    [self.hs_dataArry addObject:section7];
    [self.hs_dataArry addObject:section8];
    [self.hs_dataArry addObject:section9];
    
    [self.hs_tableView reloadData];
}

@end
