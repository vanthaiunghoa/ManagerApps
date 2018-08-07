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

@end
