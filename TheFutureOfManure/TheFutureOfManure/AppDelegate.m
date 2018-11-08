//
//  AppDelegate.m
//  GrapTheOrder
//
//  Created by wanve on 17/11/7.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "UserManager.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "TopViewController.h"
#import "WebDetailViewController.h"
#import <LeoPayManager/LeoPayManager.h>
#import "WebViewController.h"

//极光
#define JPUSHAPPKEY             @"5a299e87ba081dc8af784561"
#define JPUSHCHANNEL            @"App Store"
//#define JPUSHCHANNEL            @"Publish channel"

#ifdef DEBUG
#define  isProduction  0
#else
#define  isProduction  1
#endif

#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 微信支付
//    [LeoPayManager wechatRegisterAppWithAppId:@"WeChat_appId" description:@"description"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"isOpenWebView"];
    
    PLog(@"screen_size == %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
    //    全局缓存区设置
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    
    [self keyboardInit];
    [self progressHUDInit];
    [self initJPush:launchOptions];
    [self userModelInit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *vc = [LoginViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - pay

//iOS9之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([url.host hasPrefix:@"wx"])//微信
    {
        return [LeoPayManager wechatHandleOpenURL:url];
    }
    else if([url.host hasPrefix:@"UnionPay"])//银联
    {
        return [LeoPayManager unionHandleOpenURL:url];
    }
    else if([url.host hasPrefix:@"safepay"])//支付宝
    {
        return [LeoPayManager alipayHandleOpenURL:url];
    }
    
    return YES;
}

//iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if([url.host hasPrefix:@"wx"])//微信
    {
        return [LeoPayManager wechatHandleOpenURL:url];
    }
    else if([url.host hasPrefix:@"UnionPay"])//银联
    {
        return [LeoPayManager unionHandleOpenURL:url];
    }
    else if([url.host hasPrefix:@"safepay"])//支付宝
    {
        return [LeoPayManager alipayHandleOpenURL:url];
    }
    
    return YES;
}

#pragma mark - init

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
        
//        [self initRootViewController:NO];
    }
//    else
//    {
//        if(userModel.isAutoLogin)
//        {
//            [self login:userModel.username password:userModel.password];
//        }
//        else
//        {
//            [self initRootViewController:NO];
//        }
//    }
}

-(void)login:(NSString *)username password:(NSString *)password
{
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"j_username":username,
                           @"j_password":password
                           };
    NSString *url = @"http://xin.xinkozi.com:8088/xds/j_spring_security_check";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *result = dict[@"status"];
        if([result isEqualToString:@"y"])
        {
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = username;
            userModel.password = password;
            userModel.isAutoLogin = YES;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            [JPUSHService setAlias:username completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq)
             {
                 switch (iResCode) {
                     case 0:
                         PLog(@"设置别名成功");
                         //                         [SVProgressHUD showInfoWithStatus:@"设置别名成功"];
                         break;
                     case 6003:
                         PLog(@"alias 字符串不合法  有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字");
                         //                         [SVProgressHUD showInfoWithStatus:@"alias字符串不合法，有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字"];
                         break;
                     case 6004:
                         PLog(@"alias超长。最多 40个字节  中文 UTF-8 是 3 个字节");
                         //                         [SVProgressHUD showInfoWithStatus:@"alias超长。最多40个字节，中文UTF-8是3个字节"];
                         break;
                     default:
                         PLog(@"设置别名失败");
                         //                         [SVProgressHUD showInfoWithStatus:@"设置别名失败"];
                         break;
                 }
             } seq:[self getRandomNumber:0 to:RAND_MAX]];
            
//            UIViewController *vc = [NSClassFromString(@"WebViewController") new];
//            [self.navigationController pushViewController:vc animated:YES];
            [self initRootViewController:YES];
        }
        else
        {
//            NSString *mes = dict[@"info"];
//            [SVProgressHUD showErrorWithStatus:mes];
            [self initRootViewController:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error.userInfo);
//        [SVProgressHUD showInfoWithStatus:@"网络异常"];
        [self initRootViewController:NO];
    }];
}

// 获取随机数
- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)initRootViewController:(BOOL )isLoginSuc
{
    if(isLoginSuc)
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        
        WebViewController *vc = [WebViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    else
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        
        LoginViewController *vc = [LoginViewController new];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
}

#pragma mark - Notification handling

- (void)handleNotification:(NSNotification *)notification
{
//    [SVProgressHUD dismiss];
}

#pragma mark - JPush

- (void)initJPush:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:JPUSHCHANNEL
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            PLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            PLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    /*
     iOS 设备收到一条推送（APNs），用户点击推送通知打开应用时，应用程序根据状态不同进行处理需在 AppDelegate 中的以下两个方法中添加代码以获取apn内容
     如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他
     */
    if(launchOptions)
    {
        NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        if(remoteNotification)
        {
            PLog(@"app未启动，点击推送的内容 == %@", remoteNotification);
            [self handleNotificationClicked:remoteNotification];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //    [APService stopLogPageView:@"aa"];
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    PLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    PLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    PLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
      
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegistersDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        PLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        PLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
//        PLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        PLog(@"iOS10 收到远程通知:%@", userInfo);
        [self handleNotificationClicked:userInfo];
    }
    else {
        // 判断为本地通知
        PLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

#pragma mark - handleNotificationClicked

- (void)handleNotificationClicked:(NSDictionary *)dict
{
    NSString *url = [dict valueForKey:@"url"];
    PLog(@"url == :%@", url);
    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"http://xin.xinkozi.com:8088/xds/app/index.do" forKey:@"url"];
    
    // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
    [defaults synchronize];
    
    if([TopViewController sharedTopViewController].top)
    {
        // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
//        [defaults synchronize];
        
        if([[TopViewController sharedTopViewController].top isKindOfClass:[WebDetailViewController class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:LoadWebViewAgain
                                                                object:self];
        }
        else
        {
            UIViewController *vc = [NSClassFromString(@"WebDetailViewController") new];
        //    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
        //    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        //    [[[TopViewController sharedTopViewController] top].navigationController pushViewController:vc animated:YES];
            [[TopViewController sharedTopViewController].top.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
//        UIViewController *vc = [NSClassFromString(@"WebDetailViewController") new];
////        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
//        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"YES" forKey:@"isOpenWebView"];
        
        // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
        [defaults synchronize];
    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
