//
//  IndexViewController.m
//  WanvePadOA
//
//  Created by wanve on 2017/11/30.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexView.h"
#import "IconLabel.h"
#import "UIImage+image.h"
#import "SendHandlerViewController.h"
#import "ReceiveHandlerViewController.h"
#import "UserManager.h"
#import "UserModel.h"

@interface IndexViewController ()

@property (nonatomic, strong) IndexView *homeView;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"税务局移动办公网";
    [self setupNavBtn];
}

#pragma mark - nav item
- (void)setupNavBtn
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"personal"] style:UIBarButtonItemStylePlain target:self action:@selector(personalClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutClicked:)];
}

#pragma mark - clicked

- (void)logoutClicked:(UIButton *)sender
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.isLogout = YES;
    userModel.isAutoLogin = NO;
    userModel.isRememberUsername = NO;
    [[UserManager sharedUserManager] saveUserModel:userModel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)personalClicked:(UIButton *)sender
{
    
}

- (void)loadView
{
    _homeView = [[IndexView alloc] initWithFrame:SCREEN_BOUNDS];
//    NSArray *array = @[@"收文办理", @"发文办理", @"会议办理", @"用车审批", @"休假申请", @"休假计划", @"会议会务", @"领导日程", @"工作日程", @"收文检索", @"发文检索", @"会议检索", @"机关文件检索", @"个人文件夹", @"通讯录"];
    NSArray *array = @[@"收文办理", @"发文办理"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for (int i = 0; i < array.count; ++i)
    {
        IconLabelModel *item = [IconLabelModel new];
        item.icon = [UIImage imageNamed:[NSString stringWithFormat:@"index-%d", i]];
        item.text = array[i];
        [models addObject:item];
    }
    
    self.view = _homeView;
    self.view.backgroundColor = [UIColor whiteColor];
    _homeView.models = models;
    [self handleItemClicked];
}

- (void)handleItemClicked
{
    __weak typeof(self) weak_self = self;
    _homeView.didClickItems = ^(IndexView *homeView, NSInteger index)
    {
        NSString *title = homeView.items[index].textLabel.text;
        PLog(@"title == %@", title);
        PLog(@"tag == %ld", index);
        
        if(0 == index)
        {
            ReceiveHandlerViewController *vc = [[ReceiveHandlerViewController alloc]init];
            vc.menuViewStyle = WMMenuViewStyleLine;
            vc.title = title;
            [weak_self.navigationController pushViewController:vc animated:YES];
        }
        else if(1 == index)
        {
            SendHandlerViewController *vc = [[SendHandlerViewController alloc]init];
            vc.menuViewStyle = WMMenuViewStyleLine;
            vc.title = title;
            [weak_self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            UIViewController *vc = nil;
            switch (index)
            {
                case 0:
    //                vc = [NSClassFromString(@"ReceiveTableViewController") new];
                    break;
                    
                default:
                    
                    break;
            }
            
            vc.title = title;
            if(!vc)
            {
    //            vc = [NSClassFromString(@"ReceiveTableViewController") new];
            }
            [weak_self.navigationController pushViewController:vc animated:YES];
        }
    };

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
