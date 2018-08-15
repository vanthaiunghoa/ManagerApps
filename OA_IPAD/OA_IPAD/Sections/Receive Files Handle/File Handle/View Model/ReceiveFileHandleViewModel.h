//
//  ReceiveFileHandleViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/4/2.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Personel.h"
#import <ReactiveObjC/ReactiveObjC.h>

@class ReceiveFileType;
@interface ReceiveFileHandleViewModel : NSObject

@property (nonatomic, copy) NSString *mainGUID; //MAINGUID
@property (nonatomic, copy) NSString *whereGUID;

#pragma mark - 转发操作
/** 转发操作； 例如: 请 */
@property (nonatomic, copy) NSString *transferLeaderOperator;
/** 转发接收人(领导)  批示 */
@property (nonatomic, copy) NSArray<Personel *> *transferLeaderReceivers;
/** 转发接收人操作：例如阅示 */
@property (nonatomic, copy) NSString *transferLeaderOperation;

/** 转发操作； 例如: 请 */
@property (nonatomic, copy) NSString *transferOperator2;
/** 转发主办人 */
@property (nonatomic, strong) Personel *transferMainReceiver;

// 主办
@property (nonatomic, copy) NSArray<Personel *> *transferHostReceivers;
/** 转发协办人  协办*/
@property (nonatomic, copy) NSArray<Personel *> *transferAssistReceivers;
/** 转发传阅的人 传阅 */
@property (nonatomic, copy) NSArray<Personel *> *transferReadReceivers;

/** 文件办理类型 */
@property (nonatomic, copy) NSString *filetype;
/** 转发要求完成日期 */
@property (nonatomic, copy) NSString *fileDueDate;
/** 办理跟踪 */
@property (nonatomic) BOOL tracking;
/** 自动生成语句 */
@property (nonatomic) BOOL autoGenerateAdvice;
/** 派送文件 */
@property (nonatomic) BOOL postFile;
/** 发送短信 */
@property (nonatomic) BOOL sendMessage;

@property (nonatomic, copy) NSArray<ReceiveFileType *> *recordType;

#pragma mark - 意见信息；需要跟UI绑定
/** 办理意见 */
@property (copy, nonatomic) NSString *advice;
/** 落款人 */
@property (copy, nonatomic) NSString *signature;
/** 落款时间 */
@property (strong, nonatomic) NSString *signDate;
/** NO 办理中， YES 办完 */
@property (assign, nonatomic) BOOL handled;

/**
 自动生成的语句
 */
- (NSString *)autoGenerateSentence;

/**
 获取办理文件的细节

 @return signal next 返回一个ReceiveFileHandleListModel
 */
- (RACSignal *)receiveFileDetail;

/**
 获取办理记录
 
 @return 返回一个RACTuple；
 第一个是[ReceiveFileAttatchFileInfo] 第三个是[ReceiveFileHandleRecord]
 */
- (RACSignal *)hanldedRecords;

/**
 保存意见
 
 @return 成功的时候，返回成功信息
 */
- (RACSignal *)saveAdvice;


/**
 收文附件

 @return 一个ReceiveFileAttatchFileInfo的数组
 */
- (RACSignal *)receiveFileAttachFiles;


@end
