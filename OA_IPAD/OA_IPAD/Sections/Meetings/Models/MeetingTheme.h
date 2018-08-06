//
//  MeetingTheme.h
//  Auto Created by CreateModel on 2018-04-27 01:32:11 +0000.
//

#import <Foundation/Foundation.h>
#import "MeetingAttatchFile.h"

@interface MeetingTheme : NSObject

/**
 @description:
 @note: etc:办公室
*/
@property (nonatomic, copy) NSString *ZBKS;

/**
 @description:
 @note: etc:3.00
*/
@property (nonatomic, copy) NSString *XH;

/**
 @description:
 @note: etc:
*/
@property (nonatomic, copy) NSString *MFType;

/**
 @description:
 @note: etc:20180223170415625
*/
@property (nonatomic, copy) NSString *MM_SNID;

/**
 @description:
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *isHasFlowRight;

/**
 @description:
 @note: etc:MF_20180223170628687
*/
@property (nonatomic, copy) NSString *MF_SNID;

/** 附件列表 */
@property (nonatomic, strong) NSArray<MeetingAttatchFile *> *QWList;

/**
 @description:
 @note: etc:关于审定2018年全面推行河长制宣传工作方案的问题
*/
@property (nonatomic, copy) NSString *FlowName;

@end
