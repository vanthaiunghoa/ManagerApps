//
//  AppDelegate.m
//  WanveTest
//
//  Created by wanve on 17/11/7.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "UserManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PLog(@"screen_size == %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
    
    [self keyboardInit];
    [self progressHUDInit];
    [self userModelInit];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *vc = [LoginViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)keyboardInit
{
    // 启用
    [IQKeyboardManager sharedManager].enable = YES;
    // 点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // 工具条不显示
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)progressHUDInit
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
}

- (void)userModelInit
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel == nil)
    {
        userModel = UserModel.new;
        userModel.username = @"";
        userModel.password = @"";
        userModel.isRememberUsername = NO;
        userModel.isAutoLogin = NO;
        userModel.isLogout = NO;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
}

#pragma mark - Notification handling

- (void)handleNotification:(NSNotification *)notification
{
//    [SVProgressHUD dismiss];
}


@end
