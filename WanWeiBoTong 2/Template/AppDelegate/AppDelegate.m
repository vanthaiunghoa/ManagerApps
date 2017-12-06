//
//  AppDelegate.m
//  Template
//
//  Created by Apple on 2017/10/15.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import <IQKeyboardManager.h>

#import "UIWindow+TTFLEXSetting.h"

#ifdef DEBUG
#define  isProduction_eye  0

#define EM_PUSH_CER @"developCer"
#else
#define  isProduction_eye  1

#define EM_PUSH_CER @"product"
#endif

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    全局缓存区设置
    
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    
   
    //设置全局外貌
    [self customizeInterface];
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:JPUSHCHANNEL
                 apsForProduction:isProduction_eye
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    [JPUSHService resetBadge];

    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    
    //点击空白收回键盘
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    //设置窗口和根控制器
    UIWindow*window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window=window;
    self.window.backgroundColor=[UIColor whiteColor];
    
    
    
    MainVC*vc=[MainVC new];
    
    
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:vc];

    
    self.window.rootViewController=nav;
    
    
    [self.window makeKeyAndVisible];
    
    
  
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
    
    
    
    //添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [self didReceiveNotification:userInfo];
    });
    
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"我接收到了远程通知  iOS 10 Support");
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didReceiveNotification:userInfo];
    });
    
    completionHandler();  // 系统要求执行这个方法
}
    //接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"我接收到了远程通知  iOS 7 Support");
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self didReceiveNotification:userInfo];
    });
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"我接收到了远程通知  iOS6 Support");
    
    //    if (_mainController) {
    //        [_mainController jumpToChatList];
    //    }
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self didReceiveNotification:userInfo];
    });
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}
    //接受到了本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    //    if (_mainController) {
    //        [_mainController didReceiveLocalNotification:notification];
    //    }
    
    //    UIApplicationStateActive, // 激活状态，用户正在使用App
    //    UIApplicationStateInactive, // 不激活状态，用户切换到其他App、按Home键回到桌面、拉下通知中心
    //    UIApplicationStateBackground // 在后台运行
    
}
    
    
    
//远程通知和本地通知一起
- (void)didReceiveNotification:(NSDictionary*)userInfo{
    
    NSLog(@"接收到了通知");
    
    
    NSLog(@"userInfo == %@",userInfo);
    
    
//    {
//        "_j_business" = 1;
//        "_j_msgid" = 27021597978286429;
//        "_j_uid" = 6161443313;
//        aps =     {
//            alert =         {
//                body = "我是内容";
//                subtitle = "我是子内容";
//                title = "我是标题";
//            };
//            badge = 1;
//            category = "自定义分类";
//            "mutable-content" = 1;//携带多个参数
//            sound = default;//默认声音
//        };
          //额外参数
//        key1 = value1;
//        key2 = value2;
//        key3 = value3;
//        key4 = value4;
//    }
    
    
}
    
    
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    [[NSUserDefaults standardUserDefaults]setValue:deviceToken forKey:@"deviceToken"];
    
    
    
    
    NSLog(@"deviceToken == %@",deviceToken);
    
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}
    
    //设置全局样式
- (void)customizeInterface{
    
    if (@available(iOS 11.0, *)) {
        
        
        
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        
    }
 
    
    
    if([DDGetUserInformationTool getUserInformation]==nil){
    
    DDModel*model=[DDModel new];
    model.userName=@"";
    model.pwdName=@"";
    model.vpnUserName=@"";
    model.vpnPwdName=@"";
    model.isRecode=@"0";
    model.isAutoLogin=@"0";
    model.isOpenLogin=@"0";
    [DDGetUserInformationTool saveUserInformationWithModel:model];
    
    }
    
    [[UIButton appearance] setExclusiveTouch:YES];
    
    /************ 控件外观设置 **************/
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [[UITabBar appearance] setTintColor:kTheme];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kTheme} forState:UIControlStateSelected];
    
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x3e48cc]];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithHex:0x3e48cc]];
    //    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:]];
    
//    [UISearchBar appearance].tintColor = [UIColor colorWithHex:0x15A230];
    //    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setCornerRadius:14.0];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAlpha:0.6];
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xDCDCDC];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
//    [[UITextField appearance] setTintColor:[UIColor nameColor]];
    [[UITextView appearance]  setTintColor:[UIColor nameColor]];
    
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuVisible:YES animated:YES];
    [menuController setMenuItems:@[
                                   [[UIMenuItem alloc] initWithTitle:@"复制" action:NSSelectorFromString(@"copyText:")],
                                   [[UIMenuItem alloc] initWithTitle:@"删除" action:NSSelectorFromString(@"deleteObject:")]
                                   ]];
    
    

    UIImage*img =[UIImage imageWithColor:[UIColor colorWithHex:0x24A6CB]];
    
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage: img forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:[UIColor colorWithHex:0x5E5C5C]];//返回按钮的箭头颜色
    [navigationBarAppearance setTranslucent:NO];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:(20)],
                                     NSForegroundColorAttributeName: [UIColor colorWithHex:0x343434],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    
    
    
    //    [[UITextField appearance] setTintColor:kColorBrandGreen];//设置UITextField的光标颜色
    //    [[UITextView appearance] setTintColor:kColorBrandGreen];//设置UITextView的光标颜色
    //    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
    
    
    
}


//应用支持只竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskPortrait;
}





@end
