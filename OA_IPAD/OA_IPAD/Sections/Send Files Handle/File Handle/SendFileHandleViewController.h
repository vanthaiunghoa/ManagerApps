//
//  SendFileHandleViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/4/4.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendFileDetail.h"

@interface SendFileHandleViewController : UIViewController

@property (nonatomic, copy) NSString *identifier; //发文登记的ID
@property (nonatomic, copy) NSString *recordIdentfier; //当前纪录的ID
@property (nonatomic) BOOL shouldHiddenAdviseCell; //文件检索时，隐藏提交意见

@end
