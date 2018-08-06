//
//  SendFileRecord.h
//  Auto Created by CreateModel on 2018-04-07 01:59:08 +0000.
//

#import <Foundation/Foundation.h>

@interface SendFileRecord : NSObject

/**
 @description: 发送记录GUID
 @note: etc:7F0F9343F3164FCBA50F71B59BF6A1D2
*/
@property (nonatomic, copy) NSString *Where_GUID;

/**
 @description: 办理意见
 @note: etc:
*/
@property (nonatomic, copy) NSString *YiJian;

/**
 @description: 交办日期
 @note: etc:2018/2/28 17:11:43
*/
@property (nonatomic, copy) NSString *SendDate;

/**
 @description: 经办科室
 @note: etc:办公室
*/
@property (nonatomic, copy) NSString *JBKS;

/**
 @description: "退回标志"[0(否), 1(是), 2(不发文)]}
 @note: etc:0
*/
@property (nonatomic, copy) NSNumber *BackTo;

/**
 @description: 办理序号
 @note: etc:1.00
*/
@property (nonatomic, copy) NSString *BLXH;

/**
 @description: 办完标志",[0(未办), 1(办完), 2(办理中)]
 @note: etc:0
*/
@property (nonatomic, copy) NSNumber *IFok;

/**
 @description: 办理类型
 @note: etc:流程检查
*/
@property (nonatomic, copy) NSString *BLType;

/**
 @description: 交办人名称
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *WhoGiveUserName;

/**
 @description: 经办人
 @note: etc:胡红林
*/
@property (nonatomic, copy) NSString *JBR;

/**
 @description: 办完日期
 @note: etc:
*/
@property (nonatomic, copy) NSString *FinishDate;

/**
 @description: 交办人用户ID
 @note: etc:system
*/
@property (nonatomic, copy) NSString *WhoGiveUserID;

/**
 PNG签名图
 */
@property (nonatomic, copy) NSString *pngSignature;

/**
 签名坐标
 */
@property (nonatomic, copy) NSString *SignatureCoordinate;

/**
 SVG图片签名；暂不实现
 */
@property (nonatomic, copy) NSString *SVGSignature;


/**
 @description:
 @note: etc:999
 */
@property (nonatomic, copy) NSString *FileQZH;

/**
 @description:
 @note: etc:FW20170011
 */
@property (nonatomic, copy) NSString *FWBH;

@end
