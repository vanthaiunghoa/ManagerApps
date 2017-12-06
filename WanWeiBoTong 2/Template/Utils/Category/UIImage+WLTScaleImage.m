//
//  UIImage+WLTScaleImage.m
//  ProtectEyesGreatMaster
//
//  Created by Apple on 17/5/15.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "UIImage+WLTScaleImage.h"

@implementation UIImage (WLTScaleImage)

+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    
    
    
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    return compressedImage;
    
    
    
}

+(NSData*)scaleImageReturnData:(UIImage *)image toKb:(NSInteger)kb{

    if (!image) {
        return image;
    }
    if (kb<1) {
        return image;
    }
    
    kb*=1024;
    
    
    
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    return imageData;
    
    
    

}


+ (UIImage *)imageWithFileName:(NSString *)name {
    
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
    NSString *path1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@1x",name] ofType:extension];
    
    if (path1) {
        
        return [UIImage imageWithContentsOfFile:path1];
    }
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:extension];
    
    if (path2) {
        
        return [UIImage imageWithContentsOfFile:path2];
    }
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@3x",name] ofType:extension];
    
    if (path3) {
        
        return [UIImage imageWithContentsOfFile:path3];
    }
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    
    if (path) {
        
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}


+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


// 画水印
/*
- (void) setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    }
    //原图
    [image drawInRect:self.bounds];
    //水印图
    [mark drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}

*/

- (UIImage *)circleImage
{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // 方形变圆形
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    
    

    

}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    //系统默认会忽略isUserInteractionEnabled设置为NO、隐藏、alpha小于等于0.01的视图
//    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
//        return nil;
//    }
//    if ([self pointInside:point withEvent:event]) {
//        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
//            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
//            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
//            if (hitTestView) {
//                return hitTestView;
//            }
//        }
//        return self;
//    }
//    return nil;
//}




@end
