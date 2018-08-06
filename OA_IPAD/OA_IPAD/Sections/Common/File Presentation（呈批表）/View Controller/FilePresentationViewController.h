//
//  FilePresentationViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/4/3.
//  Copyright © 2018年 icebartech. All rights reserved.
//
//  呈批表处理

#import <UIKit/UIKit.h>
#import "FilePresentationViewModel.h"

@interface FilePresentationViewController : UIViewController

- (instancetype)initWithViewModel:(id<FilePresentationViewModel>)viewModel
                         mainGuid:(NSString *)mainGUID
                        whereGUID:(NSString *)whereGUID;

@end
