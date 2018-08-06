//
//  iAppOffice.h
//  iAppOffice
//
//  Created by A449 on 15/3/12.
//  Copyright (c) 2015年 com.kinggrid. All rights reserved.
//

/** iAppOffice开发包版本更新信息
 * 版本：V3.1.0.344
 * 日期：2017-09-27
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KGAuthorization;
@class KWOfficeApi;
@class iAppOfficeService;

NS_ASSUME_NONNULL_BEGIN

/** 水印类型 */
typedef NS_ENUM(NSUInteger, KGWPSWatermarkType) {
    
    KGWPSWatermarkTypeDefault,
    KGWPSWatermarkTypeCompact
};

/** 加密类型 */
typedef NS_ENUM(NSUInteger, KGWPSSecurityType)
{
    KGWPSSecurityTypeNone,
    KGWPSSecurityTypeAES256
};


@protocol iAppOfficeDelegate;

/** iAppOffice */
@interface iAppOffice : NSObject

/** 授权是否成功，只读属性 */
@property (nonatomic, assign, readonly) BOOL isAuthorized;

/** 设置打印模式，默认：NO */
@property (assign, nonatomic, getter=isDebugMode) BOOL debugMode;

/** 单例实例化 */
+ (instancetype)sharedInstance;

/** 检测授权码的有效期
 * @param copyRight 授权码
 * @return 剩余授权天数
 */
+ (NSUInteger)checkCopyRight:(NSString *)copyRight;

/** 注册App
 * @param keyStr 授权码
 * @param wpsKey 金山序列号，为空则为试用版WPS
 */
+ (void)registerApp:(NSString *)keyStr  wpsKey:(nullable NSString *)wpsKey;

/** 设置链接端口，默认9616，可选方法
 * @param port 端口
 */
+ (void)setPort:(NSInteger)port;

/** 设置后台模式，可选方法
 * @param backgroundMode YES是强制后台模式，NO则是非强制后台模式（如果设置的是强制后台模式还需要在info.plist当中设置后台请求，详见技术白皮书）
 */
+ (void)setBackgroundMode:(BOOL)backgroundMode;

/** 设置水印
 *  @param text     水印文字
 *  @param red      红色值 范围：0-255
 *  @param green    绿色值 范围：0-255
 *  @param blue     蓝色值 范围：0-255
 *  @param alpha    水印的透明度
 */
+ (void)setWatermarkText:(NSString*)text
            colorWithRed:(CGFloat)red
                   green:(CGFloat)green
                    blue:(CGFloat)blue
                   alpha:(CGFloat)alpha DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“+setWatermarkText:colorWithRed:green:blue:alpha:type:”代替");

/** 设置水印
 *  @param text     水印文字
 *  @param red      红色值 范围：0-255
 *  @param green    绿色值 范围：0-255
 *  @param blue     蓝色值 范围：0-255
 *  @param alpha    水印的透明度
 *  @param type     水印类型
 */
+ (void)setWatermarkText:(nonnull NSString *)text
            colorWithRed:(CGFloat)red
                   green:(CGFloat)green
                    blue:(CGFloat)blue
                   alpha:(CGFloat)alpha
                    type:(KGWPSWatermarkType)type;

/** 检测是否安装了WPS
 * @return  是否已安装WPS
 */
+ (BOOL)isAppStoreWPSInstalled;

/** 检测是否安装了企业版WPS
 * @return 是否已安装企业版WPS
 */
+ (BOOL)isEnterpriseWPSInstalled;

/** 下载WPS */
+ (void)downloadWPS;

/** 是否需要开启服务（如果采用非后台模式即没有设置Required Background modes字段的情况下，在WPS跳转回第三方应用的时候需要调用该方法判断是否需要开启服务，强制后台模式可以忽略）
 * @note 在AppDelegate中的-application:openURL:sourceApplication:annotation:里使用
 * @param url url
 * @param sourceApplication sourceApplication
 * @param annotation annotation
 *
 * @return 是否需要启动服务
 */
+ (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation;

/** 获取授权信息
 *
 * @return 授权信息
 */
- (NSDictionary *)getAuthorziedInfo DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“authorizedInfo”代替");
- (NSDictionary *)authorizedInfo;

/** 开启服务
 * @param delegate 委托
 * @return 打开结果
 */
- (BOOL)iAppOfficeServiceOpenWithDelegate:(id)delegate DEPRECATED_MSG_ATTRIBUTE("已废弃");

/** 设置后台管理
 * @note 在AppDelegate中-applicationDidEnterBackground：方法中使用 
 * @param application UIApplication对象
 *
 * @return 是否设置成功
 */
- (BOOL)setApplicationDidEnterBackground:(UIApplication *)application;

/** 发送文件数据，并启动WPS链接
 * @note 不支持打开PGF格式的文件
 * @param fileData    文件数据
 * @param fileName    文件名，含扩展名
 * @param callback    切换回第三方App的URL名
 * @param delegate    代理
 * @param rightsDict  文件操作权限
 * @param errPtr      错误信息反馈
 *
 * @return            是否成功打开
 */
- (BOOL)sendFileData:(NSData *)fileData
            fileName:(NSString *)fileName
            callback:(nullable NSString *)callback
            delegate:(id<iAppOfficeDelegate>)delegate
              policy:(nullable NSDictionary *)rightsDict
               error:(NSError **)errPtr DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“-sendFileData:fileName:callback:delegate:policy:completion:”代替");

/** 发送文件数据，并启动WPS链接
 * @param fileData      文件数据
 * @param fileName      文件名，含扩展名
 * @param callback      切换回第三方App的URL名
 * @param delegate      代理
 * @param rightsDict    文件操作权限
 * @param completion    完成回调（result：是否发送成功，error：发送失败信息）
 */
- (void)sendFileData:(NSData *)fileData
            fileName:(NSString *)fileName
            callback:(nullable NSString *)callback
            delegate:(id<iAppOfficeDelegate>)delegate
              policy:(NSDictionary *)rightsDict
          completion:(nullable void (^)(BOOL result, NSError *error))completion;

/** 发送文件数据，并启动WPS链接
 * @note 跳转到WPS操作所传输的密文文件
 * @param fileData      文件数据
 * @param fileName      文件名，含扩展名
 * @param callback      切换回第三方App的URL名
 * @param delegate      代理
 * @param rightsDict    文件操作权限
 * @param securityInfo  文件数据的加密信息 (如果发送的文件数据未通过AES加密则传nil即可)
                        @{KGWPSSecurityTypeKey: @(KWOfficeSecurityTypeAES256),
                          KGWPSSecurityKey: @"8213F24ABFAF6DNH212FBA700511D88F"} //256位(32字节)加密KEY
 * @param completion    完成回调（result：是否发送成功，error：发送失败信息）
 */
- (void)sendFileData:(NSData *)fileData
            fileName:(NSString *)fileName
            callback:(nullable NSString *)callback
            delegate:(id<iAppOfficeDelegate>)delegate
              policy:(NSDictionary *)rightsDict
        securityInfo:(nullable NSDictionary *)securityInfo
          completion:(nullable void (^)(BOOL result, NSError *error))completion;

/** 开启共享播放
 * @param data        文件数据（NSData）
 * @param fileName    文件名
 * @param serverHost  第三方App提供的共享播放服务器地址(serverHost：ip:port)
 * @param callback    切换回第三方App的URL名(callback)
 * @param delegate    委托
 * @param errPtr      错误信息
 *
 * @return 开启结果
 */
- (BOOL)startSharePlay:(NSData *)data
          withFileName:(NSString *)fileName
            serverHost:(NSString *)serverHost
              callback:(NSString *)callback
              delegate:(id)delegate
                 error:(NSError **)errPtr;

/** 开启共享播放(传入密文数据)
 * @param fileData     文件数据
 * @param fileName     文件名
 * @param serverHost   第三方App提供的共享播放服务器地址(serverHost：ip:port)
 * @param callback     切换回第三方App的URL名(callback)
 * @param securityInfo 文件数据的加密信息 (如果发送的文件数据未通过AES加密则传nil即可)
                       @{KGWPSSecurityTypeKey: @(KWOfficeSecurityTypeAES256),
                         KGWPSSecurityKey: @"8213F24ABFAF6DNH212FBA700511D88F"} //256位(32字节)加密KEY
 * @param delegate     委托
 * @param errPtr       错误信息
 *
 * @return 开启结果
 */
- (BOOL)startSharePlay:(NSData *)fileData
              fileName:(NSString *)fileName
            serverHost:(NSString *)serverHost
              callback:(nullable NSString *)callback
          securityInfo:(nullable NSDictionary *)securityInfo
              delegate:(id<iAppOfficeDelegate>)delegate
                 error:(NSError * _Nullable *)errPtr;

/** 接入共享播放
 * @param accessCode 接入码
 * @param serverHost 第三方App提供的共享播放服务器地址(serverHost：ip:port)
 * @param callback   切换回第三方App的URL名(callback)
 * @param delegate   委托
 * @param errPtr     错误信息
 *  @return 接入结果
 */
- (BOOL)joinSharePlay:(NSString *)accessCode
           serverHost:(NSString *)serverHost
             callback:(NSString *)callback
             delegate:(id)delegate
                error:(NSError **)errPtr;

@end

@protocol iAppOfficeDelegate <NSObject>

@optional
/** 从WPS回传文件数据
 * @param dict 数据字典
 * @note 回调参数dict键说明
 *       @name Right :
 *       @name Fm : 源App
 *       @name FileLen : 文件数据长度
 *       @name Date : 日期
 *       @name FileName : 文件名
 *       @name FileType : 文件类型
 *       @name Body : 文件数据
 *       @name To : 目的App
 */
- (void) iAppOfficeDidReceivedData:(NSDictionary *)dict DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeDidReceivedData:”代替，强行调用不起作用。");

/** 编辑完成后返回，并结束链接 */
- (void) iAppOfficeDidFinished DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeDidFinished”代替，强行调用不起作用。");

/** WPS编辑结束，并退回到后台时调用该代理
 * @note 在下面3种情况下，会导致该代理被触发
 *       @name 1.WPS按下HOME键退到后台时；
 *       @name 2.WPS用户连续按下两次HOME键，进行App切换时；
 *       @name 3.用户一段时间没有触摸屏幕导致iOS自动锁屏时；
 */
- (void) iAppOfficeDidAbort DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeDidAbort”代替，强行调用不起作用。");

/** 链接错误
 * @param error : 错误信息
 */
- (void) iAppOfficeDidCloseWithError:(NSError *)error DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeDidCloseWithError:”代替，强行调用不起作用。");

@required

- (void)officeDidReceivedData:(NSDictionary *)dict;

- (void)officeDidFinished;

- (void)officeDidAbort;

- (void)officeDidCloseWithError:(NSError *)error;

@optional

/** 共享播放开启成功回调
 * @param accessCode 接入码
 * @param serverHost 接入的主机地址
 */
- (void)iAppOfficeStartSharePlayDidSuccessWithAccessCode:(NSString *)accessCode
                                               serverHost:(NSString *)serverHost  DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeStartSharePlayDidSuccessWithAccessCode:serverHost:”代替，强行调用不起作用。");
- (void)officeStartSharePlayDidSuccessWithAccessCode:(NSString *)accessCode
                                          serverHost:(NSString *)serverHost;

/** 共享播放开启失败回调
 * @param errorMessage 失败信息
 */
- (void)iAppOfficeStartSharePlayDidFailWithErrorMessage:(NSString *)errorMessage  DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeStartSharePlayDidFailWithErrorMessage:”代替，强行调用不起作用。");
- (void)officeStartSharePlayDidFailWithErrorMessage:(NSString *)errorMessage;

/** 共享播放接入成功回调 */
- (void)iAppOfficeJoinSharePlayDidSuccess  DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeJoinSharePlayDidSuccess”代替，强行调用不起作用。");
- (void)officeJoinSharePlayDidSuccess;

/** 共享播放接入失败回调
 * @param errorMessage 失败信息
 */
- (void)iAppOfficeJoinSharePlayDidFailWithErrorMessage:(NSString *)errorMessage  DEPRECATED_MSG_ATTRIBUTE("为与Swift兼容，已废弃此方法，使用“-officeJoinSharePlayDidFailWithErrorMessage:”代替，强行调用不起作用。");
- (void)officeJoinSharePlayDidFailWithErrorMessage:(NSString *)errorMessage;

@end

/** 字段解释
 * WPS_DEPRECATED_IOS(..., ..., ...): 弃用（目前版本还兼容，建议及时更换提示的新权限）
 * WPS_AVAILABLE_IOS(...): 生效
 * 其中字段中的版本号代表WPS客户端的版本号，非本SDK的版本号
*/

/** log错误码说明
 * -1: 启动服务器失败
 * -2: 传输的文件data为空
 * -3: 传输的文件名为空
 * -4: 启动WPS失败，info.plist中没有URL Scheme或未设置白名单
 * -6: 传输服务未完成
 */

/* 公共权限 */

/** 是否自动备份，默认关闭，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsBackup;
/** 是否显示水印，默认不显示，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsWatermark;
/** 自动备份间隔时间，如果打开了自动备份，必须设置该字段，关闭自动备份的情况下可以忽略该字段，该字段单位为秒，建议设置>=120的数值 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicBackupInterval;
/** 是否可以分享（网页、第三方打开、长图片），默认不可分享 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsShare;
/** 是否可以打印，默认不可打印 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsPrint;
/** 是否可以发送邮件，默认不可发送 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsSendMail;
/** 是否可以导出为PDF，默认不可导出 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsExportPDF;
/** 是否可以另存，默认不可另存 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsSaveAs;
/** 是否可以本地保留，默认不可保留 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsLocalization;
/** 是否可以编辑，默认不可编辑（当不允许编辑的情况即只允许在阅读模式下操作，则会忽略其他和编辑相关的权限，例：iAppOfficeRightsPublicIsOpenInEditMode、iAppOfficeRightsPublicIsHandwritingLnkk） */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsEditEnable;
/** 是否以编辑模式打开 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsOpenInEditMode;
/** 是否可以插入手写墨迹，默认不可以插入 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsHandwritingLnk;
/** 是否可以无线投影，默认不可无线投影 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsWirelessProjection;
/** 是否可以使用词典，默认不可使用 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsDictionary;
/** 是否可以使用插线投影，默认不可使用 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsWireProjection;
/** 是否可以复制，默认不可复制 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsCopyEnable;
/** 是否可以截图，默认不可截图 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPublicIsScreenCapture;


/* Word文档权限 */

/** 编辑模式下是否可以插入图片，默认不可插入，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordEditModeIsInsertPicture;
/** 编辑模式下修订按钮是否打开，默认不可修订，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordEditModeIsRevision;
/** 编辑模式下显示修订和标记按钮是否打开，默认不可标记（如果默认以阅读模式打开文档，该字段无效，将取iAppOfficeRightsWordReadModeIsRevision的值来设置开关是否打开），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordEditModeIsMark;
/** 编辑模式下是否可以切换修订按钮，默认不可切换（如果不可切换，则退出修订，按钮也不可点）， */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordEditModeIsRevisionEnable;
/** 编辑模式下是否可以切换标记按钮，默认不可切换，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordEditModeIsMarkEnable;
/** 阅读模式下显示修订与标记按钮是否打开，默认关闭（如果默认以编辑模式打开文档，该字段无效，将取iAppOfficeRightsWordEditModeIsMark的值来设置开关是否打开），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordReadModeIsRevision;
/** 阅读模式下是否可以添加批注，默认不可添加(如果默认打开是阅读模式，并且模式不能切换即iAppOfficeRightsWordIsEditMode值为NO的时候这种情况属于只读，该值会强制设成NO，即不能添加批注)，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordReadModeIsAddCommentEnable;
/** 阅读模式下是否可以编辑批注，默认不可编辑(如果默认打开是阅读模式，并且模式不能切换即iAppOfficeRightsWordIsEditMode值为NO的时候这种情况属于只读，该值会强制设成NO，即不能编辑批注)，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordReadModeIsCommentEditEnable;
/** 阅读模式下是否可以复制，默认不可复制（WPS_DEPRECATED_IOS(1.0, 6.5, "Please use iAppOfficeRightsPublicIsCopyEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordReadModeIsCopyEnable DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsCopyEnable”代替。");
/** 是否可以导出为PDF ，默认不可输出（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsExportPDF")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsExportPDF DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsExportPDF”代替。");
/** 是否可以发送邮件，默认不可发送（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsSendMail")，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsSendMail DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsSendMail”代替。");
/** 是否可以分享（网页、第三方应用打开，长图片），默认不可分享（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsShare")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsShare DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsShare”代替。");
/** 是否可以打印，默认不可打印（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsPrint")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsPrint DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsPrint”代替。");
/** 文档是否本地保留，默认不保留（WPS_DEPRECATED_IOS(1.0, 6.0, "iAppOfficeRightsPublicIsLocalization")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsLocalization DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsLocalization”代替。");
/** 是否以编辑模式打开（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsOpenInEditMode")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsOpenInEditMode DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsOpenInEditMode”代替。");
/** 是否可以另存，默认为关闭（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsSaveAs")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsSaveAs DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsSaveAs”代替。");
/** 文档的修订用户名 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordRevisionUserName;
/** 是否可以无线投影，默认不可投影（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsWirelessProjection")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsWireless DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsWirelessProjection”代替。");
/** 是否可编辑，默认不可编辑（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsEditEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsEditMode DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsEditEnable”代替。");
/** 是否可以插入手写墨迹，默认不可插入（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsHandwritingLnk")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsWordIsHandwritingLnk DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsHandwritingLnk”代替。");


/* Excel表格权限 */

/** 是否可以发送邮件 默认不可发送邮件（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsShare")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsSendMail DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsShare”代替。");
/** 是否可以分享 默认不可分享（第三方应用打开）（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsShare")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsShare DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsShare”代替。");
/** 是否可以导出为PDF ，默认不可输出（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsExportPDF")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsExportPDF DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsExportPDF”代替。");
/** 是否可以打印，默认不可打印（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsPrint")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsPrint DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsPrint”代替。");
/** 文档是否本地保留，默认不保留（WPS_DEPRECATED_IOS(1.0, 6.0, "iAppOfficeRightsPublicIsLocalization")） */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsLocalization DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsLocalization”代替。");
/** 是否可以另存，默认为不可另存（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsSaveAs")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsSaveAs DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsSaveAs”代替。");
/** 是否编辑模式（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsEditEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsEditMode DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsEditEnable”代替。");
/** 是否可以复制，默认不可以复制（WPS_DEPRECATED_IOS(1.0, 6.5, "Please use iAppOfficeRightsPublicIsCopyEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsExcelIsCopyEnable DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsCopyEnable”代替。");

/* PPT演示文稿权限 */

/** 是否可以另存，默认为不可另存（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsSaveAs")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsSaveAs DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsSaveAs”代替。");
/** 文档是否本地保留，默认不保留（WPS_DEPRECATED_IOS(1.0, 6.0, "iAppOfficeRightsPublicIsLocalization")） */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsLocalization DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsLocalization”代替。");
/** 是否可以发送邮件 默认不可发送（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsShare")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsSendMail DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsShare”代替。");
/** 是否可以共享播放 默认不可共享播放，设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsSharePlay;
/** 是否可以无线投影 默认不可投影（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsWirelessProjection")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsWirelessProjection DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsWirelessProjection”代替。");
/** 是否可以打印 默认不可打印（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsPrint")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsPrint DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsPrint”代替。");
/** 是否可以导出为PDF 默认不可导出（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsExportPDF")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsExportPDF DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsExportPDF”代替。");
/** 是否可以分享 默认不可分享（第三方应用打开）（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsShare")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsShare DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsShare”代替。");
/** 是否可编辑，默认不可编辑（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsEditEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsEditMode DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsEditEnable”代替。");
/** 文档是否已编辑模式打开（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsOpenInEditMode")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsOpenInEditMode DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsOpenInEditMode”代替。");
/** 是否可以演讲实录，默认不可演讲实录（WPS_AVAILABLE_IOS(6.1.0)），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPPTIsVoiceRecord;


/* PDF文档权限 */

/** 是否可以分享与发送，默认不可分享与发送（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsShare")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsShareAndSendMail DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsShare”代替。");
/** 是否可以另存，默认为不可另存（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsSaveAs")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsSaveIs DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsSaveAs”代替。");
/** 是否可以打印，默认为不可打印（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsPrint")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsPrint DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsPrint”代替。");
/** 是否可编辑，默认不可编辑（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsEditEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsEidtEnable DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsEditEnable”代替。");
/** 是否可复制，默认不可复制（WPS_DEPRECATED_IOS(1.0, 6.5, "Please use iAppOfficeRightsPublicIsCopyEnable")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsCopyEnable DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsCopyEnable”代替。");
/** 文档是否本地保留，默认不保留（WPS_DEPRECATED_IOS(1.0, 6.0, "iAppOfficeRightsPublicIsLocalization")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsLocalization DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsLocalization”代替。");
/** 文档是否以编辑模式打开（WPS_DEPRECATED_IOS(1.0, 6.0, "Please use iAppOfficeRightsPublicIsOpenInEditMode")），设置值为1或0 */
UIKIT_EXTERN NSString *const iAppOfficeRightsPDFIsOpenInEditMode DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“iAppOfficeRightsPublicIsOpenInEditMode”代替。");

/* 文档权限BOOL值 */
/** YES */
UIKIT_EXTERN NSString *const iAppOfficeRightsBoolValueYES;
/** NO */
UIKIT_EXTERN NSString *const iAppOfficeRightsBoolValueNO;

NS_ASSUME_NONNULL_END
