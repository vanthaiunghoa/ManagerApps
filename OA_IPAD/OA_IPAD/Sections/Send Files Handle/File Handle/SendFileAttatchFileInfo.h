//
//  SendFileAttatchFileInfo.h
//  Auto Created by CreateModel on 2018-04-07 02:22:04 +0000.
//

#import <Foundation/Foundation.h>
#import "AttatchFileModel.h"

@interface SendFileAttatchFileInfo : NSObject<AttatchFileModel>

/**
 @description: 发文号
 @note: etc:FW201800100
*/
@property (nonatomic, copy) NSString *FWH;

/**
 @description: 文件GUID
 @note: etc:C4049229B819495EA9D50B42F2236CFB
*/
@property (nonatomic, copy) NSString *FileGUID;

/**
 @description: 序号
 @note: etc:01
*/
@property (nonatomic, copy) NSString *FileNum;

/**
 @description: 文件名字
 @note: etc:movie2.mp4
*/
@property (nonatomic, copy) NSString *FileName;

/**
 @description: 文件全宗号
 @note: etc:999
*/
@property (nonatomic, copy) NSString *FileQZH;

@end
