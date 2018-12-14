//
// Created by fantouch on 16/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileSize : NSObject


/**
 * @return "UNKNOWN", "1MB", "2GB", …
 */
+ (NSString *)sizeOf:(NSURL *)fileUrl;

@end