//
//  RecordHeaderView.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReceiveFileHandleRecord;
@interface RecordHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) ReceiveFileHandleRecord *model;

@end
