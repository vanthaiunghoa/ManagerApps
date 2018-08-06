//
//  ReceiveFileType.h
//  Auto Created by CreateModel on 2018-04-07 15:03:25 +0000.
//

#import <Foundation/Foundation.h>

@interface ReceiveFileType : NSObject

/**
 @description:
 @note: etc:1.00
*/
@property (nonatomic, copy) NSString *FlowNum;

/**
 @description:
 @note: etc:;拟办;
*/
@property (nonatomic, copy) NSString *FlowName_Lib;

/**
 @description:
 @note: etc:拟办意见
*/
@property (nonatomic, copy) NSString *FlowName;

/**
 @description:
 @note: etc:拟办
*/
@property (nonatomic, copy) NSString *FlowShortName;

/**
 @description:
 @note: etc:999
*/
@property (nonatomic, copy) NSString *QZH;

@end