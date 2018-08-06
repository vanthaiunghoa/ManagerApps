//
//  ReceiveFileAttatchFileInfo.h
//  Auto Created by CreateModel on 2018-04-14 02:44:50 +0000.
//

#import <Foundation/Foundation.h>
#import "AttatchFileModel.h"

@interface ReceiveFileAttatchFileInfo : NSObject <AttatchFileModel>

/**
 @description: 唯一的标识
 @note: etc:C5E7E92EB8FF4404A469F7CB40503080
*/
@property (nonatomic, copy) NSString *GUID;

/**
 @description: 名称
 @note: etc:东莞市创新创业种子基金绩效评价.pdf
*/
@property (nonatomic, copy) NSString *Name;

/**
 @description: 序号
 @note: etc:02
*/
@property (nonatomic, copy) NSString *XH;

@end
