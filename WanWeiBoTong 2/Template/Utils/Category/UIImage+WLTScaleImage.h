//
//  UIImage+WLTScaleImage.h
//  ProtectEyesGreatMaster
//
//  Created by Apple on 17/5/15.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WLTScaleImage)
+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;

+(NSData*)scaleImageReturnData:(UIImage *)image toKb:(NSInteger)kb;

+ (UIImage *)imageWithFileName:(NSString *)name;

+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

- (UIImage *)circleImage;




@end
