//
//  MainViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+EasyExtend.h"
#import <LCActionSheet/LCActionSheet.h>
#import "ReceiveFileHandleListViewModel.h"
#import "SendFileListViewModel.h"
#import "SendFileSearchListViewModel.h"
#import "TransactionListViewController.h"
#import "RequestManager.h"
#import "ReceiveTransactionService.h"
#import "ReceiveFileSearchListViewModel.h"
#import "UserService.h"
#import "UserInfoViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "StartMeetingViewController.h"
#import "MainView.h"
#import "UserModel.h"
#import "UserManager.h"
#import "ListViewController.h"
#import "MeetingViewController.h"

@interface MainViewController () <LCActionSheetDelegate, MainViewDelegate>

@property (nonatomic, strong) LCActionSheet *userInfoActionSheet;
@property (nonatomic, strong) LCActionSheet *settingActionSheet;
@property (nonatomic, strong) MainView *mainView;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES; //禁用侧滑；这个界面不能直接返回
    
    //去掉后退按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
  
    [[RequestManager shared] requestWithAction:@"GetSWHandleNum" appendingURL:ReceiveFileServiceURL parameters:@{} shouldDetectDictionary:NO callback:^(BOOL success, id data, NSError *error) {
        if (success) {
            PLog(@"%@", data);
        }
    }];
    
    [self loadData];
}

- (void)loadView
{
    MainView *mainView = [[MainView alloc]init];
    mainView.delegate = self;
    self.view = mainView;
    
    self.mainView = mainView;
}

/** 创建定时器 */
- (void)createTimer
{
    // GCD定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 60.0 * NSEC_PER_SEC, 0); //每分钟执行
    self.timer = timer;
  
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainView reloadHello];
            PLog(@"刷新问候！");
        });
    });
    
    // 开启定时器
    dispatch_resume(timer);
}

- (void)loadData
{
    @weakify(self);
    [[[UserService shared] fetchUserInfo] subscribeNext:^(UserInfo *x) {
        PLog(@"用户信息加载完毕");
        @strongify(self);
        
        [self.mainView reloadData:x.UserName];
    }];
}

#pragma mark - MainViewDelegate

- (void)didClickLogout
{
    [UserService shared].currentUser = nil;
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.isLogout = YES;
    [[UserManager sharedUserManager] saveUserModel:userModel];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickIndex:(int)index
{
    switch (index) {
        case 0:
            [self receiveTransaction:nil];
            break;
        case 1:
            [self touchSendFileHandleButton:nil];
            break;
        case 2:
            [self jumpToS];
            break;
        case 3:
            [self touchReceiveFileSearchButton:nil];
            break;
        case 4:
            [self sendFileSerach:nil];
            break;
        default:
            break;
    }
}

- (void)jumpToS
{
//    StartMeetingViewController *vc = [[UIStoryboard storyboardWithName:@"Meetings" bundle:nil] instantiateViewControllerWithIdentifier:@"StartMeetingViewController"];
    
    MeetingViewController *vc = [[MeetingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self _configureNavigationBarWhenAppear];
    
    [self createTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self _configureNavigationBarWhenAppear];
    // 关闭定时器
    dispatch_source_cancel(self.timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_configureNavigationBarWhenAppear {
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.shadowImage = [UIImage new];
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    bar.tintColor = [UIColor whiteColor]; //图标设置为白色
    bar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:22 weight:1.0]
                                }; //设置标题颜色

}

#pragma mark - actions

- (void)touchAvatarButton:(id)sender {
    PLog(@"个人信息设置");
//    [self.userInfoActionSheet show];
}

- (void)touchSettingButton:(id)sender {
    PLog(@"设置");
    [self.settingActionSheet show];
}

- (void)receiveTransaction:(id)sender {
//    TransactionListViewController *vc = [[TransactionListViewController alloc] initWithNibName:@"TransactionListViewController" bundle:nil];
    ListViewController *vc = [[ListViewController alloc] init];
    vc.viewModel = [ReceiveFileHandleListViewModel new];
    vc.title = @"收文办理";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchSendFileHandleButton:(id)sender {
//    TransactionListViewController *vc = [[TransactionListViewController alloc] initWithNibName:@"TransactionListViewController" bundle:nil];
    ListViewController *vc = [[ListViewController alloc] init];
    SendFileListViewModel *viewModel = [SendFileListViewModel new];
    vc.viewModel = viewModel;
    vc.title = @"发文办理";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendFileSerach:(id)sender {
//    TransactionListViewController *vc = [[TransactionListViewController alloc] initWithNibName:@"TransactionListViewController" bundle:nil];
    ListViewController *vc = [[ListViewController alloc] init];
    SendFileSearchListViewModel *viewModel = [SendFileSearchListViewModel new];
    vc.viewModel = viewModel;
    vc.title = @"发文检索";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchReceiveFileSearchButton:(id)sender {
//    TransactionListViewController *vc = [[TransactionListViewController alloc] initWithNibName:@"TransactionListViewController" bundle:nil];
    ListViewController *vc = [[ListViewController alloc] init];
    ReceiveFileSearchListViewModel *viewModel = [ReceiveFileSearchListViewModel new];
    vc.viewModel = viewModel;
    vc.title = @"收文检索";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchMeetingButton:(id)sender {
}
#pragma mark - action sheet handle

/**
 Handle click button.
 */
- (void)actionSheet:(LCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == _settingActionSheet) {
        if (buttonIndex == 1) {
            //用户信息
            UserInfoViewController *next = [UserInfoViewController new];
            [self.navigationController pushViewController:next animated:YES];
        } else if (buttonIndex == 2) {
            PLog(@"退出登录");
            [UserService shared].currentUser = nil;
            
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.isLogout = YES;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - getter and setter

- (LCActionSheet *)userInfoActionSheet {
    if (!_userInfoActionSheet) {
        _userInfoActionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册中选择", nil];
        _userInfoActionSheet.buttonFont = [UIFont systemFontOfSize:30];
        _userInfoActionSheet.buttonHeight = 70;
    }
    return _userInfoActionSheet;
}

- (LCActionSheet *)settingActionSheet {
    if (!_settingActionSheet) {
        _settingActionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"个人信息", @"退出登录" ,nil];
        _settingActionSheet.buttonFont = [UIFont systemFontOfSize:30];
        _settingActionSheet.buttonHeight = 70;
    }
    return _settingActionSheet;
}

@end
