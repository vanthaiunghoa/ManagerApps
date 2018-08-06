//
//  ReceiveFileHandleViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveFileHandleListModel.h"

@interface ReceiveFileHandleViewController : UIViewController

@property (nonatomic, copy) NSString *mainGUID; //mainGUID
@property (nonatomic, copy) NSString *whereGUID;
@property (nonatomic, strong) ReceiveFileHandleListModel *detail;

@end
