//
//  Organization.h
//  Auto Created by CreateModel on 2018-04-07 08:21:33 +0000.
//

#import <Foundation/Foundation.h>

@class Personel;
@interface Organization : NSObject<NSCopying, NSMutableCopying>

/**
 @description: 科室名字
 @note: etc:局领导
*/
@property (nonatomic, copy) NSString *KSName;

/**
 @description: 科室号
 @note: etc:01
*/
@property (nonatomic, copy) NSString *KSCode;

/**
 @description: 序号
 @note: etc:1.00
*/
@property (nonatomic, copy) NSString *XH;

/**
 @description: 科室曾用名
 @note: etc:
*/
@property (nonatomic, copy) NSString *KSHisName;

/**
 @description: 分管领导名字
 @note: etc:领导
*/
@property (nonatomic, copy) NSString *ParkLeaderName;

/**
 @description: 收文员名
 @note: etc:
*/
@property (nonatomic, copy) NSString *SWYName;

/**
 @description: 科长名字
 @note: etc:依林
*/
@property (nonatomic, copy) NSString *KSMasterName;

/**
 @description: 科室所的单位全宗号
 @note: etc:999
*/
@property (nonatomic, copy) NSString *QZH;

/**
 @description: 科长分管领导ID
 @note: etc:lindao
*/
@property (nonatomic, copy) NSString *ParkLeaderID;

/**
 @description: 收文员ID
 @note: etc:
*/
@property (nonatomic, copy) NSString *SWYID;

/**
 @description: 科长ID
 @note: etc:yl
*/
@property (nonatomic, copy) NSString *KSMasterUserID;

@property (nonatomic, strong) NSMutableArray<Personel *> *staff;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) BOOL isSelect;

@end
