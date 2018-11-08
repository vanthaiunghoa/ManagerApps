//
//  BaseNavigationController.m
//  WanveTest
//
//  Created by wanve on 2017/11/20.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+color.h"

// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

#pragma mark 一个类只会调用一次
+ (void)initialize
{
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[BaseNavigationController class], nil];
    
//     2.设置导航栏的背景图片
    NSString *navBarBg = nil;
    if (iOS7) { // iOS7
        navBarBg = @"NavBar64";
        navBar.tintColor = [UIColor whiteColor];
    } else { // 非iOS7
        navBarBg = @"NavBar";
    }
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    // 勤智资本  万维博通投资
//    navBar.barTintColor = [UIColor colorWithHexString:@"#2196F3"];
    
//    // 3.标题
#ifdef __IPHONE_7_0
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#555555"]}];
#else
    [navBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor colorWithHexString:@"#555555"]}];
#endif
    
//#ifdef __IPHONE_7_0
//    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//#else
//    [navBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
//#endif
}


@end
