//
//  SendFileListItem.h
//  Auto Created by CreateModel on 2018-04-04 14:07:47 +0000.
//

#import <Foundation/Foundation.h>
#import "ListCellProtocol.h"

@interface SendFileListItem : NSObject <ListCellDataSource>

/**
 @description: 发送记录GUID
 @note: etc:2CEB6C4158CD44928A30DF49AE7A5D99
*/
@property (nonatomic, copy) NSString *Where_GUID;

/**
 @description: ""操作类型"" [查看(view)、办理(handle)]
 @note: etc:handle
*/
@property (nonatomic, copy) NSString *OperType;

/**
 @description: 交办人
 @note: etc:
*/
@property (nonatomic, copy) NSString *WhoGiveName;

/**
 @description: 发文登记记录GUID
 @note: etc:A81ADE13A7E641CCAF71F20D6C2A95FA
*/
@property (nonatomic, copy) NSString *GUID;

/**
 @description: 主办科室
 @note: etc:
*/
@property (nonatomic, copy) NSString *ZBKS;

/**
 @description: 交办日期"
 @note: etc:2013/10/31 17:01:38
*/
@property (nonatomic, copy) NSString *SendDate;

/**
 @description: 要求办完日期
 @note: etc:2013-11-03
*/
@property (nonatomic, copy) NSString *LastDate;

/**
 @description: ""是否封发标志"",[1(已封发), 0(未封发)]
 @note: etc:1
*/
@property (nonatomic, copy) NSNumber *IfFF;

/**
 @description: 标题
 @note: etc:封发测试
*/
@property (nonatomic, copy) NSString *BT;

/**
 @description: 缓急
 @note: etc:
*/
@property (nonatomic, copy) NSString *HJ;

/**
 @description: ""办完标志"",[0(未办), 1(办完), 2(办理中)]
 @note: etc:2
*/
@property (nonatomic, copy) NSNumber *IFok;

/**
 @description: ""办理类型""
 @note: etc:封发
*/
@property (nonatomic, copy) NSString *BLType;

/**
 @description: 办完日期
 @note: etc:2018-02-01
*/
@property (nonatomic, copy) NSString *FinishDate;

/**
 @description: 发文编号
 @note: etc:FW20130006
*/
@property (nonatomic, copy) NSString *FWBH;

@end
