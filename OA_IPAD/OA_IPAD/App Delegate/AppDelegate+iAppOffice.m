//
//  iAppOffice.m
//  OA_IPAD
//
//  Created by cello on 2018/4/18.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "AppDelegate+iAppOffice.h"
#import "AttatchFileDownloader.h"

@implementation AppDelegate(iAppOffice)

- (void)setup_iAppOfficeAfterAppLaunch {
   
    // 到期时间:2018-6-20
    NSString *copyRight = @"SxD/phFsuhBWZSmMVtSjKZmm/c/3zSMrkV2Bbj5tznSkEVZmTwJv0wwMmH/+p6wLiUHbjadYueX9v51H9GgnjUhmNW1xPkB++KQqSv/VKLDsR8V6RvNmv0xyTLOrQoGzAT81iKFYb1SZ/Zera1cjGwQSq79AcI/N/6DgBIfpnlwiEiP2am/4w4+38lfUELaNFry8HbpbpTqV4sqXN1WpeJ7CHHwcDBnMVj8djMthFaapMFm/i6swvGEQ2JoygFU3W8onCO1AgMAD2SkxfJXM/pBqdQrasr/0V0I3SuQ6IFO1VzVwUlmsSQF90/OYTdIhuI7ZTJqU764j1aPQnpiJKKlcojK5xibqEU3P8Tb+28y6lZhbc0wZsYY7F8fGE4DHZs4YOxNd7fnxKM4Dd4Klf1+OBmeDcECRDSxKMJbBZX3aWo8o3k8s1e1an0Z9uqQTtGIYfNWOY83ltjqKjeToDSIzRqZYYUbAtzuYjy8C+3J428pL81nTUNGW4AN04V//v0xyj4RnCbf0HysL0WM8Tm3+KjjXk4eWYscdbEPDzss=";
    // 检测授权码的有效期
    NSUInteger expireDateDays = [iAppOffice checkCopyRight:copyRight];
    if (expireDateDays > 0) {
        // 注册APP
        [iAppOffice registerApp:copyRight wpsKey:nil];
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
    }
}


@end
