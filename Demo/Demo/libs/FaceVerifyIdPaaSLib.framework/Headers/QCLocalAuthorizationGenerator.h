//
// Created by fantouch on 06/12/2017.
// Copyright (c) 2017 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 这是一个本地实现，代码中包含 secretKey，为免被破解，实际产品中请把这部分实现放在服务器中，以保护 secretKey */
@interface QCLocalAuthorizationGenerator : NSObject

+ (NSString *)signWithAppId:(NSString *)appId
                   secretId:(NSString *)secretId
        secretKey:(NSString *)secretKey;

+ (NSString *)signWithAppId:(NSString *)appId
                   secretId:(NSString *)secretId
                  secretKey:(NSString *)secretKey
                 bucketName:(NSString *)bucketName
  effectiveDurationInSecond:(int64_t)second;

@end
