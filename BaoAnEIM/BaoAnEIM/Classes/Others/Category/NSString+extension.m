//
//  NSString+extension.m
//  EIM
//
//  Created by wanve on 2018/1/5.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

//+ (NSString *)URLDecode
//{
//    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
//
//+ (NSString *)URLEncode
//{
//    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
//
//}
//
//
//+ (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
//{
//    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
//                                                                                 NULL,
//                                                                                 (__bridge CFStringRef)self,
//                                                                                 NULL,
//                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
//                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
//}

//static NSString * urlDecode(NSString *stringToDecode) {
//    NSString *result = [stringToDecode stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return result;
//}

+ (NSString *)urlDecode:(NSString *)stringToDecode
{
    NSString *result = [stringToDecode stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


+ (NSString *)urlEncode:(NSString *)stringToEncode
{
    @autoreleasepool {
        NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                 NULL,
                                                                                                 (CFStringRef)stringToEncode,
                                                                                                 NULL,
                                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                 kCFStringEncodingUTF8
                                                                                                 ));
        result = [result stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
        return result;
    }
}

@end
