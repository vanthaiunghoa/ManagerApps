//
//  DoublePickerCell.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DoublePickerCellDelegate<NSObject>

- (void)didDoublePickerCellBtnClicked:(NSInteger )tag;

@end

@interface DoublePickerCell : UITableViewCell

@property (nonatomic, weak) id<DoublePickerCellDelegate> delegate;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;

@end
