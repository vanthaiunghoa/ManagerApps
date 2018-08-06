//
//  MBProgressHUD+LCL.m
//  OA_IPAD
//
//  Created by cello on 2018/4/11.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MBProgressHUD+LCL.h"

@implementation MBProgressHUD (LCL)

+ (instancetype)makeActivityMessage:(NSString *)msg atView:(UIView *)view {
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *instance = [MBProgressHUD HUDForView:view];
    if (!instance) {
        instance = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    [instance customSettings];
    instance.label.text = msg;
    instance.mode = MBProgressHUDModeIndeterminate;
    
//    instance.backgroundView.color = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    return instance;
}

- (void)showMessage:(NSString *)msg {
    if (![msg isKindOfClass:[NSString class]]) {
        msg = @"未知错误";
    }
    [self customSettings];
    self.mode = MBProgressHUDModeText;
    self.label.text = msg;
    self.backgroundView.color = [UIColor colorWithWhite:1.0 alpha:0.0];
    [self hideAnimated:YES afterDelay:2.0];
}

- (void)customSettings {
    self.contentColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:22];
    self.animationType = MBProgressHUDAnimationZoom;
    self.removeFromSuperViewOnHide = YES;
    self.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.65];
}

@end
