//
//  QuickHandleViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/5/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(NSString *advice);

@interface QuickHandleView : UIView

+ (instancetype)showWithConfirmBlock:(ConfirmBlock)comfirnBlock fromViewController:(UIViewController *)vc;

@end
