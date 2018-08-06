//
//  SendFilePresentationViewModel.h
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//
//  发文呈批表的处理

#import <Foundation/Foundation.h>
#import "FilePresentationViewModel.h"
#import "HandleSendRecord.h"

@interface SendFilePresentationViewModel : NSObject <FilePresentationViewModel>

@property (nonatomic, strong) HandleSendRecord *recordModel;

/**
 主表ID
 */
@property (strong, nonatomic) NSString *mainGuid;

/**
 当前纪录ID
 */
@property (strong, nonatomic) NSString *whereGuid;

/**
 纪录
 
 @return <FileRecordModel>
 */
- (RACSignal *)requestRecord;

/**
 附件
 
 @return [<AttatchFileModel>]
 */
- (RACSignal *)requestAttatchFiles;

/**
 请求主表
 
 @return <FileRecordModel>
 */
- (NSString *)cpbURLString;


/**
 上传呈批表Action
 */
- (NSString *)uploadCPBAction;

/**
 上传呈批表URL
 */
- (NSString *)uploadCPBURL;

/**
 获取手写轨迹
 
 @return 一个或者多个HandwriteModel；注意区分处理
 */
- (RACSignal *)handwrittenRecords;


@end
