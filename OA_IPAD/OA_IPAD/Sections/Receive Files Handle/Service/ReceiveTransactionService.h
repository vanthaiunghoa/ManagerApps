//
//  ReceiveTransactionService.h
//  OA_IPAD
//
//  Created by cello on 2018/3/28.
//  Copyright © 2018年 icebartech. All rights reserved.
//
// 收文办理相关

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define ReceiveFileServiceURL @"Handlers/SWMan/SWHandler.ashx"
#define ReceiveTransactionListAction @"GetSWHandleList"
#define ReceiveFileSearchListAction @"SWSearchList"
#define AttatchFileGetSizeAction @"GetSWFileInfo"
#define AttatchFileGetStreamAction @"ReadSWFile"

@interface ReceiveTransactionService : NSObject

+ (instancetype)shared;

/**
 获取收文办理记录信息（列表的其中一项；包含手写图片）

 @param Where_GUID 记录ID
 @return next一个ReceiveFileHandleListModel
 */
- (RACSignal *)receiveFileHandleRecordWithIdentifier:(NSString *)Where_GUID;

/**
 查看收文详情
 */
- (RACSignal *)receiveFileInfoWithIdentifier:(NSString *)whereGUID;

/**
 收文附件获取

 @param identifier Main_GUID
 @return 注册这个信号以处理返回信息； next返回[ReceiveFileAttatchFileInfo]
 */
- (RACSignal *)receiveFileAttatchFilesWithIdentifier:(NSString *)identifier;

/**
 返回收文的类型；需要调用这个接口先；然后遍历去请求收文办理纪录

 @return next返回[ReceiveFileType]
 */
- (RACSignal *)receiveFileType;


/**
 获取某办理类型的办理纪录

 @param identifier Main_GUID
 @param fileTypeName 文件类型名字（中文）
 @return 一个RACSignal；next返回[ReceiveFileHandleRecord]
 */
- (RACSignal *)receiveFileHandleRecordsByIdentifier:(NSString *)identifier
                                           fileType:(NSString *)fileTypeName;

/**
 收文办理呈批表

 @return 返回呈批表对象数组
 */
- (RACSignal *)receiveFileHandleAssignmentFile;


/**
 保存办理意见

 @param params 参数
 "{
 ""ActiveCode"":""xxx"" 登录验证码
 ""Where_GUID"":""""//当前办理记录GUID
 ""IFOK"":""""//办理状态，0，1，2
 ""YiJian"":"""",//办理意见.
 ""BLTime"":"""",//办理时间
 ""SignUp"":"""",//办理人落款
 ""SendUserSNID"":"""",//转派人员的UserSNID
 ""SendUserBLSort"":"""",//转派人员的办理类别
 ""SendUserLastDate"":"""",//要求办完时间.
 }"
 "提交值说明：
 如，张三办理时，转派给李四（批示）、王五（主办），要求2018-2-10办完。
 SendUserSNID，记录李四、王五的UserSNID，用英文分号隔开。
 SendUserBLSort，记录批示、主办，同样用分号隔开。
 注：以上两个值需要一一对应。
 SendUserLastDate，记录要求办完时间，只记录一个值就可以"
 @return 一个成功或者失败的signal
 */
- (RACSignal *)saveHandleInfo:(NSDictionary *)params;

/**
 附件批改新记录写入数据库

 @param qwName 附件原名
 @param guid 收文MainGUID
 @param type 附件分类
 @return 返回一个字典；带有QW_GUID字段可以使用
 */
- (RACSignal *)recordSave:(NSString *)qwName
                  recGUID:(NSString *)guid
                   qwType:(NSString *)type;

/**
 一次性上传整个文件

 @param bytesBase64 字节流
 @param guid 附件GUID
 @return 成功或者失败信号
 */
- (RACSignal *)upload:(NSString *)bytesBase64
               qwGUID:(NSString *)guid;

@end
