//
//  MeetingAttatchFile.h
//  Auto Created by CreateModel on 2018-04-27 01:36:43 +0000.
//

#import <Foundation/Foundation.h>
#import "AttatchFileModel.h"

@interface MeetingAttatchFile : NSObject <AttatchFileModel>

/**
 @description: 没用的字段
 @note: etc:0
*/
@property (nonatomic, copy) NSNumber *pngNum;

/**
 @description: 附件ID
 @note: etc:175
*/
@property (nonatomic, copy) NSString *ID;

/**
 @description: 编号
 @note: etc:01
*/
@property (nonatomic, copy) NSString *Num;

/**
 @description: 长度
 @note: etc:220454
*/
@property (nonatomic, copy) NSNumber *fileLength;

/**
 @description: 文件服务器存的名称
 @note: etc:MF_20180223170436609_01.pdf
*/
@property (nonatomic, copy) NSString *WebName;

/**
 @description: 文件名
 @note: etc:东莞市三防指挥部桌面应急演练方案(1.14)2.pdf
*/
@property (nonatomic, copy) NSString *Name;

/**
 @description:
 @note: etc:<null>
*/
@property (nonatomic, copy) NSString *WebNameForMobile;

/** 文件保存到服务器 */
- (RACSignal *)saveFileWithRecords:(NSDictionary *)records;


@end
