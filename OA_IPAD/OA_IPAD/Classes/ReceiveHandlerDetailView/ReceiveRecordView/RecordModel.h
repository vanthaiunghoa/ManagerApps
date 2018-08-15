//
//  RecordModel.h
//  OA_IPAD
//
//  Created by wanve on 2018/8/13.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReceiveFileHandleRecord;
@interface RecordModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<ReceiveFileHandleRecord *> *records;

@end
