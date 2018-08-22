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
#import "UrlManager.h"
#import "NSString+md5.h"

@interface AppDelegate ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger index;

@end

@implementation AppDelegate

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [change[@"new"] integerValue];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PLog(@"screen_size == %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
    
//    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [application registerUserNotificationSettings:setting];
    
    [self keyboardInit];
    [self progressHUDInit];
    [self userModelInit];
//    [self createTimer];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *vc = [LoginViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
        
    return YES;
}

/** 创建定时器 */
- (void)createTimer
{
//    __block int i = 1;
    self.index = 1;
    // GCD定时器
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每分钟执行
    self.timer = timer;
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            PLog(@"定时器执行");
            [self login];
//            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:i++];
        });
    });
    
    // 开启定时器
    dispatch_resume(timer);
}

-(void)login
{
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    
    //2.发送请求
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"Action"] = @"GetPhoneAppNum";
//    param[@"UserID"] = userModel.username;
    param[@"UserID"] = @"cwq";
    param[@"Timestamp"] = [self currentTimeStr];
    param[@"Signature"] = [self getMD5:@"cwq"];
    
    PLog(@"md5 == %@", [self getMD5:@"cwq"]);
    
    NSString *url = [NSString stringWithFormat:@"%@Handlers/DMS_Handler.ashx?", [[UrlManager sharedUrlManager] getBaseUrl]];
    
    [manager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"请求成功--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *result = dict[@"IsSuccess"];
        NSNumber *num = [NSNumber numberWithInt:1];
        if([result isEqualToNumber:num])
        {
            PLog(@"请求成功2--%@",responseObject);
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(long)dict[@"HandlerNum"]];
        }
        else
        {
            NSString *mes = dict[@"ErrorMessage"];
            PLog(@"get app num error == %@", mes);
//            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
//        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (NSString *)getMD5:(NSString *)userID
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@■%@■WanveDMSOA■%@", [self currentTimeStr], userID, [self currentTimeStr]];
    return [tmpStr md5];
}

- (NSString *)currentTimeStr
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
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
        userModel.vpnAccount = @"";
        userModel.vpnPassword = @"";
        userModel.isRememberUsername = NO;
        userModel.isAutoLogin = NO;
        userModel.isOpen = NO;
        userModel.isVPNLogin = NO;
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
