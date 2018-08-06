//
//  UserService.h
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//
//  用户相关的操作可以封装成一个Service；比如接口、属性获取等

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UserInfo.h"

static NSString *const UserServiceURL = @"Handlers/DMS_FileMan_Handler.ashx";
static NSString *const UserServiceGetOrganizationListAction = @"Get_QZDWKS_List";
static NSString *const UserServiceGetStaffListAction = @"Get_KSUser";
static NSString *const UserServiceFetchUserInfo = @"GetUserInfo";
static NSString *const UserServiceSearchUser = @"GetUserListOfSearch";

@interface UserService : NSObject

/**
 当前用户；登出的时候，把这个属性设为nil
 */
@property (strong, nonatomic) UserInfo *currentUser;

/**
 一个service可以看做一个服务器，属性的读取时0ms的请求；
 
 @return 单例
 */
+ (instancetype)shared;

/**
 默认用户，缓存到本地
 */
@property (nonatomic, strong, readwrite) NSString *defaultAccount;

/**
 默认用户的密码，不知道是否要保存到本地
 */
@property (nonatomic, strong, readwrite) NSString *defaultPassword;

/**
 一个字符串，需要登录的时候存储下来，下面的接口需要传给后台；退出登录之后，清除这个字段
 */
@property (nonatomic, strong, readwrite) NSString *activeCode;


/**
 登录

 @param account 账号
 @param password 密码
 @return 一个信号；注册以相应网络请求状态的变化
 */
- (RACSignal *)loginWithAccount:(NSString *)account
                       password:(NSString *)password;

/**
 获取当前用户的信息

 @return 一个信号subscribe next返回的是一个userInfo对象；
 */
- (RACSignal *)fetchUserInfo;

@end
