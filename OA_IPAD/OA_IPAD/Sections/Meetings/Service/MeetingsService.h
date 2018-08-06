//
//  MeetingsService.h
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "AttatchFileModel.h"

#define MeetingsServiceURL @"Handlers/HWMSServer_Handler.ashx"
#define MeetingServiceStreamURL @"ReadMeetFlowFile"

@interface MeetingsService : NSObject

+ (instancetype)shared;

/**
 读取会议信息
 @param identifier 会议的SNID；可以为空，为空的时候，读取最近一个会议
 @return 返回一个MeetingInfo对象
 */
- (RACSignal *)meetingsInfoForIdentifier:(NSString *)identifier;

/**
 读取其他会议

 @param identifier 会议的SNID；不能为空
 内部有MeetNum（返回条数控制），默认6
 @return RACSignal；next返回MeetingInfo对象
 */
- (RACSignal *)otherMeetingsForMeetingIdentifier:(NSString *)identifier;

/**
 获取议题的详情信息

 @param meetingID 会议ID
 @param themeID 主题ID
 @return 详情
 */
- (RACSignal *)meetingThemeInfosForMeetingID:(NSString *)meetingID
                                     themeID:(NSString *)themeID;

- (RACSignal *)saveAttatchFile:(id<AttatchFileModel>)file
                       themeID:(NSString *)themeID
                          data:(NSData *)data;


@end
