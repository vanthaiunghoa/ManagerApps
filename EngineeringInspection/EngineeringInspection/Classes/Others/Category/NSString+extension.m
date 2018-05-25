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

+ (CGFloat)calculateRowWidth:(CGFloat)height string:(NSString *)string fontSize:(NSInteger)fontSize
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

+ (CGFloat)calculateRowHeight:(CGFloat)width string:(NSString *)string fontSize:(NSInteger)fontSize
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height + 20;
}

/**
 计算高度
 
 @param text
 @return 高度
 */
+ (CGFloat)countTextHeight:(NSString *)text
                     width:(CGFloat) width
                      font:(CGFloat) fontSize
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - width, CGFLOAT_MAX) options:options context:nil];
    return rect.size.height;
}


@end
