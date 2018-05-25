//
//  BaseNavigationController.m
//  WanveTest
//
//  Created by wanve on 2017/11/20.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIColor+color.h"
//#import "UIImage+image.h"

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
    [navBar setBarTintColor:[UIColor colorWithRGB:28 green:120 blue:255]];
    
    // 2.设置导航栏的背景图片
////    NSString *navBarBg = nil;
////    if(iOS7) { // iOS7
////        navBarBg = @"NavBar64";
////        navBar.tintColor = [UIColor whiteColor];
////    } else { // 非iOS7
////        navBarBg = @"NavBar";
////        navBar.tintColor = [UIColor redColor];
////    }
//    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:28 green:120 blue:255]] forBarMetrics:UIBarMetricsDefault];
    
    // 3.标题
#ifdef __IPHONE_7_0
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#555555"]}];
#else
    [navBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor colorWithHexString:@"#555555"]}];
#endif
}

/**
 *  通过拦截push方法来设置每个push进来的控制器的返回按钮
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btn setTitle:@"返回" forState:UIControlStateNormal];
        //        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"white-arrow-back"] forState:UIControlStateNormal];
        //        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        
        [btn sizeToFit];
        // 让按钮内部的所有内容左对齐
        //        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //设置内边距，让按钮靠近屏幕边缘
        //        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    // 一旦调用super的pushViewController方法,就会创建子控制器viewController的view并调用viewController的viewDidLoad方法。可以在viewDidLoad方法中重新设置自己想要的左上角按钮样式
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    if([SVProgressHUD isVisible])
    {
        [SVProgressHUD dismiss];
    }
    [self popViewControllerAnimated:YES];
}


@end
