//
//  Personel.h
//  Auto Created by CreateModel on 2018-04-07 08:40:44 +0000.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SelectMode) {
    SelectNone = -1,
    SelectRead = 0,
    SelectHelp = 1,
    SelectHost = 2,
    SelectComment = 3,
};

@interface Personel : NSObject<NSCopying, NSMutableCopying>

/**
 @description: 任务？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *JobDuty;

/**
 @description: 密码？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *UserPsw;

/**
 @description: 用户全宗
 @note: etc:999
*/
@property (nonatomic, copy) NSString *QZH;

/**
 @description: 用户姓名
 @note: etc:孔方彬
*/
@property (nonatomic, copy) NSString *UserName;

/**
 @description: 用户唯一ID
 @note: etc:20110514150818_95
*/
@property (nonatomic, copy) NSString *UserSNID;

/**
 @description: 登录时间
 @note: etc:0001-01-01T00:00:00
*/
@property (nonatomic, copy) NSString *LoginTime;

/**
 @description: 单位名
 @note: etc:广东万维博通
*/
@property (nonatomic, copy) NSString *DWName;

/**
 @description:
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *isKSJR;

/**
 @description: 科室号
 @note: etc:01
*/
@property (nonatomic, copy) NSString *KSCode;

/**
 @description: 称谓
 @note: etc:副局长
*/
@property (nonatomic, copy) NSString *Title;

/**
 @description:
 @note: etc:
*/
@property (nonatomic, copy) NSString *vacInfo;

/**
 @description: 用户ID
 @note: etc:kfb
*/
@property (nonatomic, copy) NSString *UserID;

/**
 @description: 科室名
 @note: etc:局领导
*/
@property (nonatomic, copy) NSString *KSName;

@property (nonatomic, assign) SelectMode selectMode;

@end
