//
//  UIColor+Scheme.m
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "UIColor+Scheme.h"
#import "UIColor+EasyExtend.h"

@implementation UIColor (Scheme)

+ (UIColor *)lightText {
    return [UIColor fromHex:0x999999];
}
+ (UIColor *)normalText {
    return [UIColor fromHex:0x333333];
}
+ (UIColor *)redText
{
    return [UIColor fromHex:0xF15654];
}
+ (UIColor *)schemeBlue {
    return [UIColor fromHex:0x0093D7];
}
+ (UIColor *)naviColor
{
    return [UIColor fromHex:0x3D98FF];
}
+ (UIColor *)disableButton {
    return [UIColor fromHex:0xD1D1D1];
}

@end
