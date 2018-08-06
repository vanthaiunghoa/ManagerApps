//
//  SendFileDetail.h
//  Auto Created by CreateModel on 2018-04-04 16:08:56 +0000.
//

#import <Foundation/Foundation.h>

@interface SendFileDetail : NSObject

/**
 @description: 附件描述
 @note: etc:
*/
@property (nonatomic, copy) NSString *FJMS;

/**
 @description: 页数
 @note: etc:1
*/
@property (nonatomic, copy) NSString *YS;

/**
 @description: 主办科室
 @note: etc:
*/
@property (nonatomic, copy) NSString *ZBKS;

/**
 @description: 安全级别
 @note: etc:1
*/
@property (nonatomic, copy) NSString *AQJB;

/**
 @description: 信息公开类别
 @note: etc:
*/
@property (nonatomic, copy) NSString *XXGKType;

/**
 @description: 缓急
 @note: etc:
*/
@property (nonatomic, copy) NSString *HJ;

/**
 @description: 是否分发
 @note: etc:1
*/
@property (nonatomic, copy) NSNumber *IfFF;

/**
 @description: 文种
 @note: etc:通知
*/
@property (nonatomic, copy) NSString *WZ;

/**
 @description: 校对人
 @note: etc:何柱良
*/
@property (nonatomic, copy) NSString *JDR;

/**
 @description: 信息公开类目
 @note: etc:
*/
@property (nonatomic, copy) NSString *XXGKCatalog;

/**
 @description: 文件记录的ID
 @note: etc:A81ADE13A7E641CCAF71F20D6C2A95FA
*/
@property (nonatomic, copy) NSString *GUID;

/**
 @description: 文号年
 @note: etc:
*/
@property (nonatomic, copy) NSString *WHN;

/**
 @description: 标题
 @note: etc:封发测试
*/
@property (nonatomic, copy) NSString *BT;

/**
 @description: 发出日期
 @note: etc:
*/
@property (nonatomic, copy) NSString *FCDate;

/**
 @description: 抄送单位
 @note: etc:
*/
@property (nonatomic, copy) NSString *CSDW;

/**
 @description: 主题词
 @note: etc:
*/
@property (nonatomic, copy) NSString *ZTC;

/**
 @description: 打印人
 @note: etc:何柱良
*/
@property (nonatomic, copy) NSString *DYR;

/**
 @description: 份数
 @note: etc:1
*/
@property (nonatomic, copy) NSString *FS;

/**
 @description: 文件所属全宗
 @note: etc:999
*/
@property (nonatomic, copy) NSString *FileQZH;

/**
 @description: 文件号
 @note: etc:
*/
@property (nonatomic, copy) NSString *WHT;

/**
 @description: 发文号
 @note: etc:FW20130006
*/
@property (nonatomic, copy) NSString *FWH;

/**
 @description: 会签单位
 @note: etc:
*/
@property (nonatomic, copy) NSString *HQDW;

/**
 @description: 拟稿人
 @note: etc:何柱良
*/
@property (nonatomic, copy) NSString *NGR;

/**
 @description: 对应收文编号
 @note: etc:
*/
@property (nonatomic, copy) NSString *DYSWH;

/**
 @description: 签发日期
 @note: etc:
*/
@property (nonatomic, copy) NSString *QFDate;

/**
 @description: 主送单位
 @note: etc:
*/
@property (nonatomic, copy) NSString *ZSDW;

/**
 @description: 归档情况
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *GJQK;

/**
 @description: 密级
 @note: etc:
*/
@property (nonatomic, copy) NSString *MJ;

/**
 @description: 文号字
 @note: etc:
*/
@property (nonatomic, copy) NSString *WHZ;

/**
 @description: 签发人
 @note: etc:
*/
@property (nonatomic, copy) NSString *QFR;


@end
