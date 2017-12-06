//
//  UIColor+color.h
//  WanveOA
//
//  Created by wanve on 17/11/13.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (color)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;

+ (UIColor *)randomColor;
+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b alphaComponent:(CGFloat)alpha;
+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b;
+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a;
+ (instancetype)rgba:(NSUInteger)rgba;

- (NSUInteger)rgbaValue;


@end
