//
// Created by fantouch on 16/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import "FileSize.h"
#import "Logger.h"

@implementation FileSize

+ (NSString *)sizeOf:(NSURL *)fileUrl {
    NSString *sizeString = @"UNKNOWN";
    NSError *error = nil;
    NSDictionary *sizeDic = [fileUrl resourceValuesForKeys:@[NSURLFileSizeKey] error:&error];
    //[self log:[NSString stringWithFormat:@"NSDictionary for NSURLFileSizeKey: %@", sizeDic]];
    if (error) {
        NSString *msg = [NSString stringWithFormat:@"%@", error];
        [Logger log:msg andPrintTo:nil];
    } else {
        NSNumber *size = [sizeDic valueForKey:NSURLFileSizeKey];
        long fileSize = [size longValue];
        long KB = 1024l;
        long MB = 1024l * KB;
        if (MB <= fileSize) {
            sizeString = [NSString stringWithFormat:@"%.2fMB", fileSize * 1.0f / MB];
        } else if (0l < fileSize < MB) {
            sizeString = [NSString stringWithFormat:@"%.2fKB", fileSize * 1.0f / KB];
        }
    }
    return sizeString;
}

@end