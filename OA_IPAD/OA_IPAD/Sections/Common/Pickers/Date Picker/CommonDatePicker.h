//
//  CommonDatePicker.h
//  OA_IPAD
//
//  Created by cello on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommonDatePicker;
@protocol CommonDatePickerDelegate<NSObject>

- (void)datePicker:(CommonDatePicker *)datePicker didTapConfirmButton:(UIButton *)button;
- (void)datePicker:(CommonDatePicker *)datePicker didTapCancelButton:(UIButton *)button;

@end

@interface CommonDatePicker : UIView

@property (copy, nonatomic) NSString *identifier; //一个标识
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) id<CommonDatePickerDelegate> delegate;

/**
 默认使用的方法；加载时间选择器到当前的window上

 @return 实例
 */
+ (instancetype)showDatePickerAtWindow;

// 需要更改模式的话；设置这个datePicker的mode
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/**
 设置当前时间是最小时间
 */
- (void)setMinimumCurrent;
/**
 带动画消失
 */
- (void)dimissAnimated;

@end
