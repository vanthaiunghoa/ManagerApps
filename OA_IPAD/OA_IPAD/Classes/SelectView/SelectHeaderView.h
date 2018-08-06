//
//  SelectHeaderView.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectHeaderViewDelegate<NSObject>

- (void)didSelectIndexPath:(NSInteger )indexPath;
- (void)didSelectRead:(NSInteger )indexPath;

@end

@class Organization;
@interface SelectHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SelectHeaderViewDelegate> delegate;
@property (nonatomic, strong) Organization *model;
@property (nonatomic, assign) NSInteger indexPath;

@end
