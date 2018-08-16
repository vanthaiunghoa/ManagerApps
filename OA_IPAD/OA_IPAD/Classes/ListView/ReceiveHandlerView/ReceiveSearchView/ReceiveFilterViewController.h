//
//  ReceiveFilterViewController.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SelectType) {
    WHN,
    HandlerBeginTime,
    HandlerEndTime,
};

@class ReceiveFilterViewController;
@protocol ReceiveFilterViewControllerDelegate<NSObject>

- (void)controller:(ReceiveFilterViewController *)controller didConfirmFilter:(NSMutableDictionary *)dict;

@end


@interface ReceiveFilterViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dict;
@property (nonatomic, weak) id<ReceiveFilterViewControllerDelegate> delegate;

@end
