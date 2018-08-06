//
//  CommonDatePicker.m
//  OA_IPAD
//
//  Created by cello on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "CommonDatePicker.h"

@implementation CommonDatePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.comfirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
}


+ (instancetype)showDatePickerAtWindow {
    CommonDatePicker *instance = [[[NSBundle mainBundle] loadNibNamed:@"CommonDatePicker" owner:nil options:nil] firstObject];
    [[UIApplication sharedApplication].keyWindow addSubview:instance];
    instance.frame = [UIScreen mainScreen].bounds;
    return instance;
}


- (void)setMinimumCurrent {
//    _datePicker.minimumDate = [NSDate new];
}

/**
 带动画消失
 */
- (void)dimissAnimated {
    __weak CommonDatePicker *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)confirm:(id)sender {
    if (self.delegate) {
        [self.delegate datePicker:self didTapConfirmButton:sender];
    }
}

- (void)cancel:(id)sender {
    if (self.delegate) {
        [self.delegate datePicker:self didTapCancelButton:sender];
    }
}
@end
