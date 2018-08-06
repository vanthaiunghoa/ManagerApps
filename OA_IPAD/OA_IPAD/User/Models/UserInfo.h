//
//  UserInfo.h
//  Auto Created by CreateModel on 2018-04-14 11:49:45 +0000.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/**
 @description: 邮箱
 @note: etc:
*/
@property (nonatomic, copy) NSString *Email;

/**
 @description: 家庭电话
 @note: etc:
*/
@property (nonatomic, copy) NSString *HomePhone;

/**
 @description: 全宗号
 @note: etc:999
*/
@property (nonatomic, copy) NSString *QZH;

/**
 @description: 用户真实姓名
 @note: etc:陈伟强
*/
@property (nonatomic, copy) NSString *UserName;

/**
 @description: 单位名
 @note: etc:广东万维博通
*/
@property (nonatomic, copy) NSString *DWName;

/**
 @description: 手机号
 @note: etc:1372793311
*/
@property (nonatomic, copy) NSString *MobilePhone;

/**
 @description: 手机号2
 @note: etc:
*/
@property (nonatomic, copy) NSString *MobilePhone2;

/**
 @description: 地址
 @note: etc:
*/
@property (nonatomic, copy) NSString *Address;

/**
 @description: 手机短号
 @note: etc:
*/
@property (nonatomic, copy) NSString *ShortMessagePhone;

/**
 @description: 办公电话
 @note: etc:
*/
@property (nonatomic, copy) NSString *FixPhone;

/**
 @description: 备注
 @note: etc:
*/
@property (nonatomic, copy) NSString *Memo;

/**
 @description: 用户名
 @note: etc:cwq
*/
@property (nonatomic, copy) NSString *UserID;

@end
