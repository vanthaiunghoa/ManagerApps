//
//  UIColor+color.m
//  WanveOA
//
//  Created by wanve on 17/11/13.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "UIColor+color.h"

@implementation UIColor (color)

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length Case:(int) ARGB{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    switch (ARGB) {
        case 0://alpha
            return hexComponent / 255.0;
            
            break;
        case 1://red
            
            return ( hexComponent )/ 255.0;
            
            break;
        case 2://green
            return (hexComponent)/ 255.0;
            
            break;
        case 3://blue
            return (hexComponent) / 255.0;
            
            break;
        default:
            break;
    }
    return 0;
}

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b alphaComponent:(CGFloat)alpha {
    return [[self r:r g:g b:b] colorWithAlphaComponent:alpha];
}

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b {
    return [self r:r g:g b:b a:0xff];
}

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a {
    return [self colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a / 255.];
}

+ (instancetype)rgba:(NSUInteger)rgba {
    return [self r:(rgba >> 24)&0xFF g:(rgba >> 16)&0xFF b:(rgba >> 8)&0xFF a:rgba&0xFF];
}

+ (instancetype)colorWithHexString:(NSString *)hexString {
    if (!hexString)
        return nil;
    
    NSString* hex = [NSString stringWithString:hexString];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    
    if (hex.length == 6)
        hex = [hex stringByAppendingString:@"FF"];
    else if (hex.length != 8)
        return nil;
    
    uint32_t rgba;
    NSScanner* scanner = [NSScanner scannerWithString:hex];
    [scanner scanHexInt:&rgba];
    return [UIColor rgba:rgba];
}

- (NSUInteger)rgbaValue {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        NSUInteger rr = (NSUInteger)(r * 255 + 0.5);
        NSUInteger gg = (NSUInteger)(g * 255 + 0.5);
        NSUInteger bb = (NSUInteger)(b * 255 + 0.5);
        NSUInteger aa = (NSUInteger)(a * 255 + 0.5);
        
        return (rr << 24) | (gg << 16) | (bb << 8) | aa;
    } else {
        return 0;
    }
}

@end
