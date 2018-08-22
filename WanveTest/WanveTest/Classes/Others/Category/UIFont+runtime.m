//
//  UIFont+runtime.m
//  WanveTest
//
//  Created by wanve on 2017/12/11.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "UIFont+runtime.h"
#import <objc/runtime.h>

@implementation UIFont (runtime)

+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    
    CGFloat w = fontSize/375.f * [UIScreen mainScreen].bounds.size.width;
    CGFloat h = fontSize/667.f * [UIScreen mainScreen].bounds.size.height;
    
    newFont = [UIFont adjustFont:sqrt(w*h)];
    return newFont;
}

@end
