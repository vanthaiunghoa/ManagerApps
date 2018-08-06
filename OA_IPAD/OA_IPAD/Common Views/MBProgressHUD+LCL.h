//
//  MBProgressHUD+LCL.h
//  OA_IPAD
//
//  Created by cello on 2018/4/11.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (LCL)

/**
 展示加载页面

 @param msg 信息
 @param view 展示在某个视图上；传nil则展示在window上
 @return 一个MBProgressHUB实例；而后再用它来展示成功或者失败信息
 */
+ (instancetype)makeActivityMessage:(NSString *)msg atView:(UIView *)view;

/**
 展示某信息；2s后消失

 @param msg 信息
 */
- (void)showMessage:(NSString *)msg;

/**
 定制化界面 
 */
- (void)customSettings;

@end
