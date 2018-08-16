//
//  SinglePickerCell.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SinglePickerCellDelegate<NSObject>

- (void)didSinglePickerCellBtnClicked:(NSString *)valueOfKey;

@end

@interface SinglePickerCell : UITableViewCell

@property (nonatomic, weak) id<SinglePickerCellDelegate> delegate;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end
