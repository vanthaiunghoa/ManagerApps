//
//  NSString+extension.h
//  EIM
//
//  Created by wanve on 2018/1/5.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)

+ (NSString *)urlDecode:(NSString *)stringToDecode;
+ (NSString *)urlEncode:(NSString *)stringToEncode;

+ (CGFloat)calculateRowWidth:(CGFloat)height string:(NSString *)string fontSize:(NSInteger)fontSize;
+ (CGFloat)calculateRowHeight:(CGFloat)width string:(NSString *)string fontSize:(NSInteger)fontSize;

/**
 计算固定宽度的文本显示高度
 
 @param text 文本
 @param width 显示宽度
 @param fontSize 显示字体
 @return 文本显示高度
 */
+ (CGFloat)countTextHeight:(NSString *)text
                     width:(CGFloat)width
                      font:(CGFloat)fontSize;


@end
