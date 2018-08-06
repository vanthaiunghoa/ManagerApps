//
//  iAppOfficeService.h
//  iAppOffice
//
//  Created by A449 on 15/12/29.
//  Copyright © 2015年 com.kinggrid. All rights reserved.
//

/*
 * 更新于：2016-12-20
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class iAppOffice;
@class KGBase64;
@class iMessageServer;

@interface iAppOfficeService : NSObject

/** 单例模式初始化
 * @return : iAppRevisionServices单例对象
 */
+ (instancetype)service;

/** 分解PGF文件
 * @param fileData : PGF文件数据
 * @return : PGF文件信息
 */
- (NSDictionary *)fileInfoWithPGFFileData:(NSData *)fileData;

/** 拼合PGF文件
 * @param fileInfo : PGF文件信息
 * @return : PGF文件数据
 */
- (NSData *)fileDataWithPGFFileInfo:(NSDictionary *)fileInfo DEPRECATED_MSG_ATTRIBUTE("已废弃，使用“-PGFFileDataFromPGFFileInfo:”代替");
- (NSData *)fileDataFromPGFFileInfo:(NSDictionary *)fileInfo;

/** 下载网络文档
 * @param webService : 文件地址
 * @param recordID : 文件号ID
 * @param success : 回调参数，获取成功（fileData : 文档信息）
 * @param failure : 回调参数，获取失败（error : 错误信息）
 */
#warning - The parameter of "success" for callback functions is changed from "message" to "fileData"
- (void)downloadFileWithWebService:(NSString *)webService
                          recordID:(NSString *)recordID
                           success:(void (^)(NSData *fileData))success
                           failure:(void (^)(NSError *error))failure;

/** 上传网络文档
 * @param webService : 文件地址
 * @param fileData : 文件数据
 * @param recordID : 文件号ID
 * @param fileName : 文件名，必须含扩展名
 * @param success : 回调参数，获取成功（fileData : 回调消息）
 * @param failure : 回调参数，获取失败（error : 错误信息）
 */
- (void)uploadFileWithWebService:(NSString *)webService fileData:(NSData *)fileData recordID:(NSString *)recordID fileName:(NSString *)fileName success:(void (^)(NSString *message))success failure:(void (^)(NSError *error))failure;

/** 上传网络文档
 * @param webService : 文件地址
 * @param fileData : 文件数据
 * @param recordID : 文件号ID
 * @param fileName : 文件名，必须含扩展名
 * @param moduleType : 模块类型
 * @param success : 回调参数，获取成功（fileData : 回调消息）
 * @param failure : 回调参数，获取失败（error : 错误信息）
 */
- (void)uploadFileWithWebService:(NSString *)webService fileData:(NSData *)fileData recordID:(NSString *)recordID fileName:(NSString *)fileName moduleType:(NSString *)moduleType success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
@end

UIKIT_EXTERN NSString *const KGPGFFileKeyPrefix;
UIKIT_EXTERN NSString *const KGPGFFileKeyContent;
UIKIT_EXTERN NSString *const KGPGFFileKeyExtern;
UIKIT_EXTERN NSString *const KGPGFFileKeyType;

