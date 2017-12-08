//
//  CoverView.m
//  彩票
//
//  Created by xiaomage on 15/9/21.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView

+ (void)show
{
    // 设置父控件的透明度会影响子控件
    
    CoverView *cover = [[CoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.3;
    
    // 在开发中,只要把一个控件显示在最外边,就把他添加到主窗口上.
    // 获取主窗口
    [[UIApplication sharedApplication].keyWindow addSubview:cover];

}

+ (void)hide
{

    // 移除蒙版
    for (UIView *childView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}

@end
