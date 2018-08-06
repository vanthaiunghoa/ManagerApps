//
//  LoginViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/3/24.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "LoginViewModel.h"
#import "UserService.h"

@interface LoginViewModel()


@end

@implementation LoginViewModel

// 初始；可以考虑从UserDefaults里面加载信息
- (instancetype)init {
    self = [super init];
    _account = [UserService shared].defaultAccount;
    _password = [UserService shared].defaultPassword;
//    _isLogout = [UserService shared].isLogout;
    return self;
}

- (BOOL)isProperAccount {
    //TODO: 目前不知道这个需求是什么
    return self.account.length > 0;
}

- (BOOL)isProperPassword {
    return self.password.length > 0;
}

#pragma mark - getter and setter

- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc ]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [[UserService shared] loginWithAccount:self.account password:self.password];
        }];
    }
    return _loginCommand;
}

@end
