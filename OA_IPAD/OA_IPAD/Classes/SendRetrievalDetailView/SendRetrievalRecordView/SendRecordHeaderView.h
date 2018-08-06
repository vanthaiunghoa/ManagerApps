//
//  SendRecordHeaderView.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendFileRecord;
@interface SendRecordHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) SendFileRecord *model;

@end
