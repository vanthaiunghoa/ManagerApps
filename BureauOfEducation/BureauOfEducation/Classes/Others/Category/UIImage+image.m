//
//  UIImage+image.m
//  WanveTest
//
//  Created by wanve on 2017/11/22.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithName:(NSString *)name {
    
    //如果长度为0 ,就直接返回
    if (name.length<=0) {
        
        return nil;
    }
    
    NSString *extension = @"png";
    
    NSArray *components = [name componentsSeparatedByString:@"."];
    
    if ([components count] >= 2) {
        NSUInteger lastIndex = components.count - 1;
        extension = [components objectAtIndex:lastIndex];
        
        name = [name substringToIndex:(name.length-(extension.length+1))];
    }
    
    // 如果为Retina屏幕且存在对应图片，则返回Retina图片，否则查找普通图片
    if ([UIScreen mainScreen].scale == 2.0) {
        name = [name stringByAppendingString:@"@2x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    if ([UIScreen mainScreen].scale == 3.0) {
        
        name = [name stringByAppendingString:@"@3x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        if (path != nil) {
            
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    //先清除之前的@1x,@2x,@3x
    if ([name containsString:@"@1x"]||[name containsString:@"@2x"]||[name containsString:@"@3x"]) {
        
        name = [name substringWithRange:NSMakeRange(0, name.length-3)];
        
    }
    
    
    //没有符合要求的,有啥就用啥
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@3x",name] ofType:extension];
    
    if (path3) {
        
        return [UIImage imageWithContentsOfFile:path3];
    }
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:extension];
    
    if (path2) {
        
        return [UIImage imageWithContentsOfFile:path2];
    }
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@1x",name] ofType:extension];
    
    if (path1) {
        
        return [UIImage imageWithContentsOfFile:path1];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    if (path) {
        
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}

@end
