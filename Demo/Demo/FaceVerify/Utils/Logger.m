//
// Created by fantouch on 16/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import "Logger.h"

@implementation Logger

static NSDateFormatter *_formatter;

+ (void)log:(NSString *)msg andPrintTo:(UITextView *)textView {
    // 打印到控制台
    NSLog(msg);

    // 打印到UI
    if (!_formatter) {// 这样够了, 没必要写严格的单例
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss:SSS "];
    }
    [textView insertText:[_formatter stringFromDate:[NSDate date]]];
    [textView insertText:msg];
    [textView insertText:@"\n"];
    // 滚到底部
    NSUInteger lastIndex = [[textView text] length];
    [textView scrollRangeToVisible:NSMakeRange(lastIndex, lastIndex)];
}

+ (void)to:(UITextView *)textView format:(NSString *)format, ... {
    va_list ap;
    va_start (ap, format);
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end (ap);

    [self log:body andPrintTo:textView];
}

@end