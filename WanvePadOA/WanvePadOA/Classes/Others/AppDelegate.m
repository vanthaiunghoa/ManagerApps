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
#import "iAppOffice.h"
#import "iAppOfficeService.h"

@interface AppDelegate ()<iAppOfficeDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self keyboardInit];
    [self progressHUDInit];
    [self userModelInit];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *vc = [LoginViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    // 到期时间:2017-12-20
    NSString *copyRight = @"SxD/phFsuhBWZSmMVtSjKZmm/c/3zSMrkV2Bbj5tznSkEVZmTwJv0wwMmH/+p6wLiUHbjadYueX9v51H9GgnjUhmNW1xPkB++KQqSv/VKLDsR8V6RvNmv0xyTLOrQoGzAT81iKFYb1SZ/Zera1cjGwQSq79AcI/N/6DgBIfpnlwiEiP2am/4w4+38lfUELaNFry8HbpbpTqV4sqXN1WpeJ7CHHwcDBnMVj8djMthFaapMFm/i6swvGEQ2JoygFU3CQHU1ScyOebPLnpsDlQDzFl6PdtDy57kFV+RWJq+MePx6aD2yiupr6ji7hzsE6/QbaqCDCtTDTe1U1UGNQSK3L4KSzPvnels6ZNbT7bd4+uVWEbHWAH22+t7LdPt+jENkzZtnNzztENURpEKuLOcS89+ejXAkO7Uf1YSlJfm5PCSgCNRP4FpYjl8hG/IVrYXg+4ZXoWKUbJ3lGm6U3gyeOW8fXpxdRHfEuWC1PB9ruQ=";
    // 检测授权码的有效期
    NSUInteger expireDateDays = [iAppOffice checkCopyRight:copyRight];
    if (expireDateDays > 0) {
        // 注册APP
        [iAppOffice registerApp:copyRight wpsKey:nil];
        // 设置端口
        [iAppOffice setPort:3122];
        // 设置调试模式
#ifdef DEBUG
        [[iAppOffice sharedInstance] setDebugMode:YES];
#else
        [[iAppOffice sharedInstance] setDebugMode:NO];
#endif
        // 打印授权结果和授权信息
        NSLog(@"AppDelegate: <-[application:didFinishLaunchingWithOptions:] 授权结果：[%d]", [iAppOffice sharedInstance].isAuthorized);
        for (NSString *key in [iAppOffice sharedInstance].authorizedInfo.allKeys) {
            
            NSLog(@"   %@ = %@", key, [[iAppOffice sharedInstance].authorizedInfo objectForKey:key]);
        }
        NSLog(@"}>");
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWPSDocumentNotification:) name:@"WPSDocumentNotification" object:nil];
    }
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // 必须使用（开启后台监听模式）
    [[iAppOffice sharedInstance] setApplicationDidEnterBackground:application];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (![iAppOffice sharedInstance].isAuthorized) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"授权失败！" message:@"请检查授权码是否有效。" preferredStyle:UIAlertControllerStyleAlert];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    // 检测是否安装了WPS，如未安装给出提示。
//    if (![iAppOffice isAppStoreWPSInstalled]) {
//
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到未安装WPS" message:@"请退出应用安装WPS后重试" preferredStyle:UIAlertControllerStyleAlert];
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // 注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WPSDocumentNotification" object:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // 重新拉起WPS做相应的配置(回调成功，通知WPS。)
    return [iAppOffice handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - Notification
- (void)handleWPSDocumentNotification:(NSNotification *)notification{
    
    NSLog(@"AppDelegate: <-[handleWPSDocumentNotification:] fileName = %@>", notification.object);
    // 获取文档主路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    // 获取通知中的文档名称
    NSString *fileName = notification.object;
    // 根据文件名称获取文档路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Files/%@", fileName]];
    // 根据文件路径拿到文档数据
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    // 如果文档数据长度为0,则退出方法.
    NSLog(@"AppDelegate: <-[handleWPSDocumentNotification:] fileData.length = %lu>", (unsigned long)fileData.length);
    if (fileData.length == 0) return;
    
    // 文档权限信息
    NSMutableDictionary *filePolicyInfo = [NSMutableDictionary dictionary];
    // 获取权限设置文件的路径
    NSString *rightsFilePath = [documentsPath stringByAppendingPathComponent:@"Settings/iAppOfficeRightsSetting.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:rightsFilePath]) {// 权限设置文件的路径是存在的会进入
        // 将权限设置文件转成字典
        NSDictionary *rightsDict = [NSDictionary dictionaryWithContentsOfFile:rightsFilePath];
        
        // 公共权限
        NSDictionary *publicDict = [rightsDict objectForKey:@"Public"];
        for (NSDictionary *dict in [publicDict objectForKey:@"Rights"]) {
            // 该条配置信息是否有效
            BOOL available = [[dict objectForKey:@"Available"] boolValue];
            if (available) {
                // 如果是有效的，则将该条配置加入到 文档权限信息字典 中
                [filePolicyInfo setObject:[dict objectForKey:@"Value"] forKey:[dict objectForKey:@"Key"]];
            }
        }
        
        // Word权限
        NSDictionary *wordRightsDict = [rightsDict objectForKey:@"Word"];
        for (NSDictionary *dict in [wordRightsDict objectForKey:@"Rights"]) {
            
            BOOL available = [[dict objectForKey:@"Available"] boolValue];
            if (available) {
                
                [filePolicyInfo setObject:[dict objectForKey:@"Value"] forKey:[dict objectForKey:@"Key"]];
            }
        }
        
        // Excel权限
        NSDictionary *excelRightsDict = [rightsDict objectForKey:@"Excel"];
        for (NSDictionary *dict in [excelRightsDict objectForKey:@"Rights"]) {
            
            BOOL available = [[dict objectForKey:@"Available"] boolValue];
            if (available) {
                
                [filePolicyInfo setObject:[dict objectForKey:@"Value"] forKey:[dict objectForKey:@"Key"]];
            }
        }
        
        // PPT权限
        NSDictionary *pptRightsDict = [rightsDict objectForKey:@"PPT"];
        for (NSDictionary *dict in [pptRightsDict objectForKey:@"Rights"]) {
            
            BOOL available = [[dict objectForKey:@"Available"] boolValue];
            if (available) {
                
                [filePolicyInfo setObject:[dict objectForKey:@"Value"] forKey:[dict objectForKey:@"Key"]];
            }
        }
        
        // PDF权限
        NSDictionary *pdftRightsDict = [rightsDict objectForKey:@"PDF"];
        for (NSDictionary *dict in [pdftRightsDict objectForKey:@"Rights"]) {
            
            BOOL available = [[dict objectForKey:@"Available"] boolValue];
            if (available) {
                
                [filePolicyInfo setObject:[dict objectForKey:@"Value"] forKey:[dict objectForKey:@"Key"]];
            }
        }
    }
    // 打印文档权限信息
    NSLog(@"AppDelegate: <-[handleWPSDocumentNotification:] filePolicyInfo: %@>", filePolicyInfo);
    // 启动WPS打开文档
    [[iAppOffice sharedInstance] sendFileData:fileData fileName:fileName callback:nil delegate:self policy:filePolicyInfo completion:^(BOOL result, NSError *error) {
        
        NSLog(@"AppDelegate: <-[handleWPSDocumentNotification:] sendFileData: result = %d, error = %@>", result, error.description);
        
        if (!result && error != nil) {
            if (error.code == -6) {// 服务未完成，WPS被占用
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"打开失败"
                                                                message:@"WPS被占用，请重新启动WPS。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }];
}

#pragma mark - iAppOfficeApi Delegate
// 在WPS中点击保存数据时调用
//- (void)iAppOfficeDidReceivedData:(NSDictionary *)dict{
- (void)officeDidReceivedData:(NSDictionary *)dict {
    // 打印回调信息dict
    NSLog(@"AppDelegate: <-[officeDidReceivedData:] receivedInfo: {");
    for (NSString *key in dict.allKeys) {
        
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSData class]]) {
            
            NSData *data = (NSData *)value;
            
            NSLog(@"    %@: length = %ld", key, (unsigned long)data.length);
        }
        else {
            
            NSLog(@"    %@: %@", key, [dict objectForKey:key]);
        }
    }
    NSLog(@"}>");
    // 获取文档数据、文档类型、文档名称
    NSData *fileData = [dict objectForKey:@"Body"];
    NSString *fileType = [dict objectForKey:@"FileType"];
    NSString *fileName = [dict objectForKey:@"FileName"];
    // 根据文档名称、文档类型获取文档的存储路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Files/%@.%@", fileName, fileType]];
    // 保存数据
    BOOL saveFile = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {// 文档路径存在，则用新数据替换老数据
        
        saveFile = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
    }
    else{// 文档路径不存在，新建并写入数据
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        saveFile = [fileData writeToFile:filePath atomically:YES];
    }
}
// WPS完成编辑，退回到当前App时调用
//- (void)iAppOfficeDidFinished {
- (void)officeDidFinished {
    
    NSLog(@"AppDelegate: <-[officeDidFinished]>");
}
// WPS结束编辑，并退回到后台时调用
//- (void)iAppOfficeDidAbort{
- (void)officeDidAbort {
    
    NSLog(@"AppDelegate: <-[officeDidAbort]>");
    
}
// 和WPS通信传输过程中出现问题调用
//- (void)iAppOfficeDidCloseWithError:(NSError *)error{
- (void)officeDidCloseWithError:(NSError *)error {
    
    NSLog(@"AppDelegate: <-[officeDidCloseWithError:]>");
}



@end
