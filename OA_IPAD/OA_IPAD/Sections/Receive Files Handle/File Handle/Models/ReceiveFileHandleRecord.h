//
//  ReceiveFileHandleRecord.h
//  Auto Created by CreateModel on 2018-04-09 07:32:35 +0000.
//

#import <Foundation/Foundation.h>

@interface ReceiveFileHandleRecord : NSObject

/**
 @description: 经办人降级
 @note: etc:A1
*/
@property (nonatomic, copy) NSString *UserJobDuty;

/**
 @description: 要求办完时间
 @note: etc:2018-04-04
*/
@property (nonatomic, copy) NSString *LastDate;

/**
 @description: 主表ID
 @note: etc:1b6b2ab2cd0545b48c4bc472229d1fbb
*/
@property (nonatomic, copy) NSString *MGUID;

/**
 @description: 经办人ID
 @note: etc:hhl
*/
@property (nonatomic, copy) NSString *UserID;

/**
 @description: 办理状态
 @note: etc:1
*/
@property (nonatomic, copy) NSString *IFok;

/**
 @description:
 @note: etc:[{"Yijian":"已阅读。","SignUp":"","ifok":"1","friqi":"2018-4-4 14:20:46","regDate":"2018-04-04 14:20:46"}]
*/
@property (nonatomic, copy) NSString *SWBLYJ_History;

/**
 @description: 经办人单位名
 @note: etc:广东万维博通
*/
@property (nonatomic, copy) NSString *UserQZHName;

/**
 @description: 办理记录GUID
 @note: etc:2CCD704C782E42279175422B13013B6D
*/
@property (nonatomic, copy) NSString *WhereGUID;

/**
 @description: 办理状态描述
 @note: etc:办完
*/
@property (nonatomic, copy) NSString *BLStatus;

/**
 @description: 经办人姓名
 @note: etc:胡红林
*/
@property (nonatomic, copy) NSString *UserName;

/**
 @description: 办理要求
 @note: etc:
*/
@property (nonatomic, copy) NSString *BLYaoQiu;

/**
 @description: 发送短信标识，1表示已发短信.
 @note: etc:
*/
@property (nonatomic, copy) NSString *isSendSMS;

/**
 @description: 经办人单位简称
 @note: etc:
*/
@property (nonatomic, copy) NSString *UserQZHShortName;

/**
 @description: 办理时间
 @note: etc:2018-04-04 14:20:36
*/
@property (nonatomic, copy) NSString *BLDate;

/**
 @description: 办理记录ID
 @note: etc:490620
*/
@property (nonatomic, copy) NSString *HandleID;

/**
 @description: 交办人姓名
 @note: etc:胡红林
*/
@property (nonatomic, copy) NSString *WhoGiveName;

/**
 @description: 办理类型
 @note: etc:文件传阅
*/
@property (nonatomic, copy) NSString *BLType;

/**
 @description: 文件全宗
 @note: etc:999
*/
@property (nonatomic, copy) NSString *FileQZH;

/**
 @description: 科室名
 @note: etc:工程部
*/
@property (nonatomic, copy) NSString *KSName;

/**
 @description:
 @note: etc:传阅
*/
@property (nonatomic, copy) NSString *BLSort;

/**
 @description: 交办时间
 @note: etc:2018-04-04 14:25:04
*/
@property (nonatomic, copy) NSString *SendDate;

/**
 @description: 经办人所在全宗
 @note: etc:999
*/
@property (nonatomic, copy) NSString *JbrQZH;

/**
 @description: 办理意见
 @note: etc:已阅读。
*/
@property (nonatomic, copy) NSString *Yijian;

/**
 @description: SVG图片的签名（暂不处理）
 */
@property (nonatomic, copy) NSString *SVGSignature;

/**
 @description: PNG图片的签名（暂不处理）
 */
@property (nonatomic, copy) NSString *pngSignature;

/**
 @description: 签名坐标原点；格式 x,y
 */
@property (nonatomic, copy) NSString *SignatureCoordinate;

@property (nonatomic, assign) BOOL isSelect;

@end
