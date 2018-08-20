//
//  SendRetrievalFilterViewController.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendRetrievalFilterViewController;
@protocol SendRetrievalFilterViewControllerDelegate<NSObject>

- (void)sendRetrievalFilterViewController:(SendRetrievalFilterViewController *)controller didConfirmFilter:(NSMutableDictionary *)dict;

@end


@interface SendRetrievalFilterViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *dict;
@property (nonatomic, weak) id<SendRetrievalFilterViewControllerDelegate> delegate;

@end
