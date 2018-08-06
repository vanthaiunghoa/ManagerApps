//
//  UIColor+EasyExtend.h
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef HEX_RGB
#define HEX_RGB(v) [UIColor fromHex:v]
#endif

@interface UIColor (EasyExtend)


+ (UIColor *)fromHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)fromHex:(NSInteger)hexValue;

@end
