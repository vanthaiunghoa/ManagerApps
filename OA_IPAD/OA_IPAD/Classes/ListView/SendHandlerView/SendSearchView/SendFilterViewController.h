//
//  SendFilterViewController.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendFilterViewController;
@protocol SendFilterViewControllerDelegate<NSObject>

- (void)controller:(SendFilterViewController *)controller didConfirmFilter:(NSMutableDictionary *)dict;

@end


@interface SendFilterViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dict;
@property (nonatomic, weak) id<SendFilterViewControllerDelegate> delegate;

@end
