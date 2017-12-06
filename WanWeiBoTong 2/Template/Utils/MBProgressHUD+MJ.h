//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

typedef NS_ENUM(NSInteger,AniType){
   AniTypeDefault=0,
    AniTypeOne,
    AniTypeTwo,
    AniTypeThree,
    AniTypeFour,
    AniTypeFive
};

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;

+(MBProgressHUD*)showSomeThingAniType:(AniType)AniType;

+(MBProgressHUD*)showTextView:(NSString*)message;

+(MBProgressHUD*)showDetail:(NSString*)title Detail:(NSString*)detalText;







#pragma mark 自定义分享成功弹框
+(MBProgressHUD*)showAddexp:(NSString*)exep andMoney:(NSString*)money  andCoin:(NSString*)coin andType:(NSInteger)type icon:(NSString *)icon view:(UIView *)view;

@end
