//
//  UIColor+EasyExtend.m
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "UIColor+EasyExtend.h"

@implementation UIColor (EasyExtend)

+ (UIColor *)fromHex:(NSInteger)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:alpha];
}

+ (UIColor *)fromHex:(NSInteger)hexValue {
    return [UIColor fromHex:hexValue alpha:1.0];
}

@end
