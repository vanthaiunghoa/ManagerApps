//
//  SelectViewController.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectViewController, Organization;
@protocol SelectViewControllerDelegate<NSObject>

- (void)controller:(SelectViewController *)controller didConfirmPensonel:(NSMutableArray<Organization *> *)organizations;

@end


@interface SelectViewController : UIViewController

@property (strong, nonatomic) NSMutableArray<Organization *> *organizations;
@property (nonatomic, weak) id<SelectViewControllerDelegate> delegate;

@end
