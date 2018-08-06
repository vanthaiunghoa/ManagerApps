//
//  SendFileSearchItem.h
//  Auto Created by CreateModel on 2018-04-06 13:36:49 +0000.
//

#import <Foundation/Foundation.h>
#import "ListCellProtocol.h"

@interface SendFileSearchItem : NSObject <ListCellDataSource>

/**
 @description: 文种
 @note: etc:通知
*/
@property (nonatomic, copy) NSString *WZ;

/**
 @description: 文号
 @note: etc:
*/
@property (nonatomic, copy) NSString *WH;

/**
 @description: 文件登记GUID
 @note: etc:2D0071A07F5643218B500FA3B865B42A
*/
@property (nonatomic, copy) NSString *GUID;

/**
 @description: 办理状态
 @note: etc:流程检查
*/
@property (nonatomic, copy) NSString *BLState;

/**
 @description: 主办科室
 @note: etc:办公室
*/
@property (nonatomic, copy) NSString *ZBKS;

/**
 @description: 信息公开类型
 @note: etc:
*/
@property (nonatomic, copy) NSString *XXGKType;

/**
 @description: 文件所属全宗
 @note: etc:999
*/
@property (nonatomic, copy) NSString *FileQZH;

/**
 @description: 标题
 @note: etc:ddddd
*/
@property (nonatomic, copy) NSString *BT;

/**
 @description: 签发日期
 @note: etc:
*/
@property (nonatomic, copy) NSString *QFDate;

/**
 @description:
 @note: etc:二级管理员
*/
@property (nonatomic, copy) NSString *NGR;

/**
 @description: 发文号
 @note: etc:FW201800104
*/
@property (nonatomic, copy) NSString *FWH;

/**
 @description: 信息公开类目
 @note: etc:
*/
@property (nonatomic, copy) NSString *XXGKCatalog;

@end
