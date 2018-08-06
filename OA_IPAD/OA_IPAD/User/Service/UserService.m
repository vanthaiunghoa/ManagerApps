//
//  UserService.m
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "UserService.h"
#import "RequestManager.h"
#import "NSDictionary+CreateModel.h"
#import <MJExtension/MJExtension.h>


NSString *const UserServiceActionLogin = @"Login";

@interface UserService()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation UserService

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    return self;
}

- (RACSignal *)loginWithAccount:(NSString *)account
                       password:(NSString *)password {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"UserID"] = account;
        params[@"PSW"] = password;
        
        [[RequestManager shared] requestWithAction:UserServiceActionLogin appendingURL:UserServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                // 永久保存以下数据
                self.defaultPassword = password;
                self.defaultAccount = account;
                self.activeCode = data[@"ActiveCode"];
                [RequestManager shared].activeCode = data[@"ActiveCode"];
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        
        return nil; //使用全局 RACDisposable
    }];
    
    return signal;
}

- (RACSignal *)fetchUserInfo {
    if (self.currentUser) {
        return [RACSignal return:self.currentUser];
    }
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:UserServiceFetchUserInfo appendingURL:UserServiceURL parameters:@{} callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSDictionary *responseDict = data[@"Datas"];
                [responseDict createModelWithName:@"UserInfo"];
                UserInfo *user = [UserInfo new];
                [user mj_setKeyValues:responseDict];
                self.currentUser = user;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
    return signal;
}

#pragma mark - setter and getter

@dynamic defaultAccount, defaultPassword, activeCode;

- (void)setDefaultAccount:(NSString *)defaultAccount {
    [_userDefaults setObject:defaultAccount forKey:@"UserService_defaultAccount"];
}
- (NSString *)defaultAccount {
    return [_userDefaults objectForKey:@"UserService_defaultAccount"];
}

- (void)setDefaultPassword:(NSString *)defaultPassword {
    [_userDefaults setObject:defaultPassword forKey:@"UserService_defaultPassword"];
}

- (NSString *)defaultPassword {
    return [_userDefaults objectForKey:@"UserService_defaultPassword"];
}

- (void)setActiveCode:(NSString *)activeCode {
    [_userDefaults setObject:activeCode forKey:@"UserService_activeCode"];
}

- (NSString *)activeCode {
    return [_userDefaults objectForKey:@"UserService_activeCode"];
}


@end
