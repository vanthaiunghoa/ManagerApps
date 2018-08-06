//
//  UIImage+EasyExtend.h
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EasyExtend)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithView:(UIView *)view;

- (UIImage*)clipWithRect:(CGRect)rect;

@end
