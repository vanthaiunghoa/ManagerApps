//
//  ReceiveFileHandleListModel.h
//  Auto Created by CreateModel on 2018-03-28 18:04:00 +0000.
//

#import <Foundation/Foundation.h>
#import "ListCellProtocol.h"

@interface ReceiveFileHandleListModel : NSObject <ListCellDataSource>

/**
 @description: 文号
 @note: etc:〔〕号
*/
@property (nonatomic, copy) NSString *WH;

/**
 @description: 要求办完时间
 @note: etc:2015-03-23
*/
@property (nonatomic, copy) NSString *LastDate;

/**
 @description:主记录ID
 @note: etc:A28731ECA0694A08B8F0616EF8E1BD9C
*/
@property (nonatomic, copy) NSString *MGUID;

/**
 @description: 收文标题
 @note: etc:接待来函
*/
@property (nonatomic, copy) NSString *Title;

/**
 @description: 文件收文时间
 @note: etc:2015-03-18
*/
@property (nonatomic, copy) NSString *SWDate;

/**
 @description: 缓急
 @note: etc:普件
*/
@property (nonatomic, copy) NSString *HJ;

/**
 @description: 经办人全宗
 @note: etc:999
*/
@property (nonatomic, copy) NSString *jbrQZH;

/**
 @description: 来文单位
 @note: etc:
*/
@property (nonatomic, copy) NSString *LWDW;

/**
 @description: 办理记录GUID
 @note: etc:501060A152ED4F0E940520959DC382D7
*/
@property (nonatomic, copy) NSString *WhereGUID;

/**
 @description: 办理描述
 @note: etc:待办
*/
@property (nonatomic, copy) NSString *BLStatus;

/**
 @description: 意见
 @note: etc:acascacascasc
*/
@property (nonatomic, copy) NSString *YiJian;

/**
 @description: 办理落款人
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *Signup;

/**
 @description: 文号年
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *WHN;

/**
 @description: 备注
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *Memo;

/**
 @description: ？？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *XH;

/**
 @description: 文件主录ID
 @note: etc:490701
*/
@property (nonatomic, copy) NSString *FileID;

/**
 @description: 文号数
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *WHS;

/**
 @description: ？？
 @note: etc:
*/
@property (nonatomic, copy) NSString *StarMark;

/**
 @description: 办理时间
 @note: etc:2018-02-08 15:25:25
*/
@property (nonatomic, copy) NSString *BLDate;

/**
 @description: ？？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *SW_GRGZ;

/**
 @description: 办理记录ID
 @note: etc:488753
*/
@property (nonatomic, copy) NSString *HandleID;

/**
 @description: 办理类型
 @note: etc:拟办意见
*/
@property (nonatomic, copy) NSString *BLType;

/**
 @description: 交办人姓名
 @note: etc:二级管理员
*/
@property (nonatomic, copy) NSString *WhoGiveName;

/**
 @description: 文件全宗号
 @note: etc:999
*/
@property (nonatomic, copy) NSString *FileQZH;

/**
 @description: 文号头
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *WHT;

/**
 @description: ？？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *BLYQ;

/**
 @description: ？？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *JBRName;

/**
 @description: 办理类别
 @note: etc:拟办
*/
@property (nonatomic, copy) NSString *BLSort;

/**
 @description: 文件流水编号
 @note: etc:SW20140008
*/
@property (nonatomic, copy) NSString *SWBH;

/**
 @description: 发送日期
 @note: etc:2015-03-18 12:07:21
*/
@property (nonatomic, copy) NSString *SendDate;

/**
 @description: ？？
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *JBRUserID;

/**
 @description: 办理标识
 @note: etc:0
*/
@property (nonatomic, copy) NSString *IFok;

#pragma mark ----------------------------- 呈批表 -----------------------------------

/**
 呈批表名字
 */
@property (nonatomic, copy) NSString *CPB_Name;
/**
 手写坐标，格式x,y
 */
@property (nonatomic, copy) NSString *SighatureCoordinate;

/**
 png手写内容
 */
@property (nonatomic, copy) NSString *pngSighature;

/**
 svg手写内容
 */
@property (nonatomic, copy) NSString *SVGSighature;

@end
