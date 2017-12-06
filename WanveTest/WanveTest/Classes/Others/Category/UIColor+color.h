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

@end
