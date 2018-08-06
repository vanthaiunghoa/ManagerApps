//
//  ReceiveFileDetail.h
//  Auto Created by CreateModel on 2018-04-09 09:32:56 +0000.
//

#import <Foundation/Foundation.h>

@interface ReceiveFileDetail : NSObject

/**
 @description: 缓急
 @note: etc:普件
*/
@property (nonatomic, copy) NSString *HJ;

/**
 @description: 文件全宗号
 @note: etc:999
*/
@property (nonatomic, copy) NSString *FileQZH;

/**
 @description: 公开期限？？
 @note: etc:10年
*/
@property (nonatomic, copy) NSString *GJQK;

/**
 @description: 公开类型
 @note: etc:
*/
@property (nonatomic, copy) NSString *GK_Type;

/**
 @description: 主抄送单位
 @note: etc:市府
*/
@property (nonatomic, copy) NSString *ZSDW;

/**
 @description: 对应发文编号
 @note: etc:FW201800062
*/
@property (nonatomic, copy) NSString *DY_FWBH;

/**
 @description: 来文摘要
 @note: etc:测试收文登记20180402测试收文登记20180402测试收文登记20180402测试收文登记20180402
*/
@property (nonatomic, copy) NSString *LWZY;

/**
 @description: 主办科室
 @note: etc:办公室
*/
@property (nonatomic, copy) NSString *ZBKSName;

/**
 @description: 页数
 @note: etc:1
*/
@property (nonatomic, copy) NSString *YS;

/**
 @description: 单位类别
 @note: etc:C
*/
@property (nonatomic, copy) NSString *LWDWLB;

/**
 @description: 主表ID
 @note: etc:a2280d5d1a2b421d90ae26e858d064d1
*/
@property (nonatomic, copy) NSString *Main_GUID;

/**
 @description: 备注
 @note: etc:测试收文登记20180402测试收文登记20180402测试收文登记20180402测试收文登记20180402测试收文登记20180402测试收文登记20180402测试收文登记20180402测试收文登记20180402
*/
@property (nonatomic, copy) NSString *SWMemo;

/**
 @description: 成文日期
 @note: etc:2018-04-03
*/
@property (nonatomic, copy) NSString *CWDate;

/**
 @description: 收文日期
 @note: etc:2018-04-02
*/
@property (nonatomic, copy) NSString *SWDate;

/**
 @description: 分数
 @note: etc:1
*/
@property (nonatomic, copy) NSString *FS;

/**
 @description: 主送
 @note: etc:主送
*/
@property (nonatomic, copy) NSString *LWXZ;

/**
 @description: 文件去向
 @note: etc:测试
*/
@property (nonatomic, copy) NSString *SW_MoveTo;

/**
 @description: 类别编号
 @note: etc:
*/
@property (nonatomic, copy) NSString *LWDWLB_BH;

/**
 @description: 密级
 @note: etc:平件
*/
@property (nonatomic, copy) NSString *MJ;

/**
 @description: 呈批表
 @note: etc:dgs_mczf_02.aspx
*/
@property (nonatomic, copy) NSString *CPB_Name;

/**
 @description: 收文编号
 @note: etc:SW201800057
*/
@property (nonatomic, copy) NSString *SWBH;

/**
 @description: 文号
 @note: etc:001
*/
@property (nonatomic, copy) NSString *WHS;

/**
 @description: 附件提示
 @note: etc:
*/
@property (nonatomic, copy) NSString *QWFlag;

/**
 @description: 通知
 @note: etc:报告
*/
@property (nonatomic, copy) NSString *WZ;

/**
 @description: 文件类型：比如SW（收文）
 @note: etc:SW
*/
@property (nonatomic, copy) NSString *FileType;

/**
 @description: 文件ID
 @note: etc:491616
*/
@property (nonatomic, copy) NSString *FileID;

/**
 @description: 标题
 @note: etc:测试收文登记20180402
*/
@property (nonatomic, copy) NSString *Title;

/**
 @description: 主题词
 @note: etc:123
*/
@property (nonatomic, copy) NSString *ZTC;

/**
 @description: 办理结果
 @note: etc:测试
*/
@property (nonatomic, copy) NSString *BLResult;

/**
 @description: 文号
 @note: etc:万维
*/
@property (nonatomic, copy) NSString *WHT;

/**
 @description: 文件办理类型
 @note: etc:办件
*/
@property (nonatomic, copy) NSString *FileBL_Type;

/**
 @description: 办结标识
 @note: etc:0
*/
@property (nonatomic, copy) NSString *BJFlag;

/**
 @description: 文件安全级别
 @note: etc:1
*/
@property (nonatomic, copy) NSString *SW_Security;

/**
 @description: 部门文件
 @note: etc:收文
*/
@property (nonatomic, copy) NSString *WJML;

/**
 @description: 文号
 @note: etc:2018
*/
@property (nonatomic, copy) NSString *WHN;

/**
 @description: 附件描述
 @note: etc:测试
*/
@property (nonatomic, copy) NSString *QWMemo;

/**
 @description: 来问单位
 @note: etc:市府
*/
@property (nonatomic, copy) NSString *LWDW;

@end
