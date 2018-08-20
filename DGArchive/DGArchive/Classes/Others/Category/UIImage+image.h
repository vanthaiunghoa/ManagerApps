//
//  UIImage+image.h
//  WanveTest
//
//  Created by wanve on 2017/11/22.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
