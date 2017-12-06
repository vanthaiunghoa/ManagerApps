//
//  BaseNavigationController.m
//  WanveTest
//
//  Created by wanve on 2017/11/20.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "BaseNavigationController.h"
//#import "UIImage+image.h"
//#import "MJTableViewController.h"
//#import "UserManager.h"

// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
//    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil];
    
//    // 2.设置导航栏的背景图片
//    NSString *navBarBg = nil;
//    if (iOS7) { // iOS7
//        navBarBg = @"NavBar64";
//        navBar.tintColor = [UIColor whiteColor];
//    } else { // 非iOS7
//        navBarBg = @"NavBar";
//    }
//    UIColor *color = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
//    [navBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    
//    // 3.标题
//#ifdef __IPHONE_7_0
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//#else
//    [navBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
//#endif
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
////    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : WhiteColor}];
//
//    // 获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
////    [viewController.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:Scale_Size_Smaller()]} forState:UIControlStateNormal];
//    if (self.childViewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    [super pushViewController:viewController animated:YES];
//}
//
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    // 当前页面是显示结果页，不响应滑动手势
////    UIViewController *vc = [self.childViewControllers lastObject];
////    if ([vc isKindOfClass:[MJTableViewController class]])
////    {
////        [[UserManager sharedUserManager] logout];
////        return NO;
////    }
//
//    return YES;
//}



@end
