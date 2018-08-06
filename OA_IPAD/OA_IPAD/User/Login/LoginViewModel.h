//
//  LoginViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/3/24.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewModel : NSObject

@property (nonatomic) BOOL vpnSelected;
@property (nonatomic) BOOL isLogout;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
/**
 登录功能；使用 execute: nil；自动会获取 account,password 属性
 */
@property (nonatomic, strong) RACCommand *loginCommand;

/**
 判断账号是否合法； 后台会给规则，比如不允许一些特殊字符

 @return YES代表合法账号，NO则不合法
 */
- (BOOL)isProperAccount;

/**
 判断密码是否合法

 @return YES代表合法，NO则不合法
 */
- (BOOL)isProperPassword;

@end
