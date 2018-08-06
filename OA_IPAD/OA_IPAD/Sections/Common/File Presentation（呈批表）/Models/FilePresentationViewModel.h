//
//  FilePresentationViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/4/23.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "FileRecordModel.h"
#import "AttatchFileModel.h"

@protocol FilePresentationViewModel <NSObject>

- (Class)previewViewModelClass;


@property (nonatomic, strong) id recordModel;

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
