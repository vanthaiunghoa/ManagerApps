//
// Created by fantouch on 16/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Logger : NSObject

+ (void)log:(NSString *)msg andPrintTo:(UITextView *)textView;

+ (void)to:(UITextView *)textView format:(NSString *)format, ...;

@end