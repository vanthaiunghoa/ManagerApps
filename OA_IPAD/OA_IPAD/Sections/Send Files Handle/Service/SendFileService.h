//
//  SendFileService.h
//  OA_IPAD
//
//  Created by cello on 2018/4/4.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

#define SendFileServiceURL @"Handlers/FWMan/FWHandler.ashx"
#define SendFileHandleListAction @"GetFWHandleList"
#define SendFileSearchListAction @"GetFWSearchList"
#define SendFileAttatchFileGetMaxSizeAction @"GetFWFileRec"
#define SendFileAttatchFileGetStream @"ReadFWFile"

@interface SendFileService : NSObject

+ (instancetype)shared;

/**
 获取具体的文件办理信息

 @param identifier 某个发文登记的GUID
 @return 一个信号。next返回SendFileDetail对象
 */
- (RACSignal *)handleFileDetailForIdentifier:(NSString *)identifier;

/**
 获取收文发送详情

 @param whereID 所处的这条记录
 @return HandleSendRecord
 */
- (RACSignal *)handleFileSendRecordForWhereID:(NSString *)whereID;

/**
 获取发文办理的记录信息（办理情况）

 @param identifier 某发文登记的GUID
 @return 一个信号。next返回[SendFileRecord]
 */
- (RACSignal *)handleFileRecordsForIdentifier:(NSString *)identifier;


/**
 获取附件列表

 @param identifier 某办理文件的GUID
 @return 一个信号，next返回[SendFileAttatchFileItem]
 */
- (RACSignal *)attatchFilesForIdentifier:(NSString *)identifier;


/**
 保存发文办理意见

 @param advice 意见文本
 @param assignment 落款人
 @param recordIdentfier 办理纪录ID（WhereGUID）
 @param finishDate 要求完成日期 2018-03-31 20:48:66
 @param state  1办理完; 2为办理中
 @return next 返回成功信息
 */
- (RACSignal *)saveAdivce:(NSString *)advice
                assigment:(NSString *)assignment
          recordIdentfier:(NSString *)recordIdentfier
               finishDate:(NSString *)finishDate
                    state:(NSInteger)state;

@end
