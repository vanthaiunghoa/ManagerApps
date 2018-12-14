//
// Created by fantouch on 14/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCHttpEngine : NSObject

/**
 * 发送 multipart/form-data 格式的 POST 请求
 * @param apiUrl like @"http://…"
 * @param headers like @{@"key": @"value", …}
 * @param params like @{@"key": @"value", …}
 * @param files like @{@"key": @"fileUrl", …}
 */
+ (NSURLSessionDataTask *)postFormDataTo:(NSString *)apiUrl
                                 headers:(NSDictionary<NSString *, NSString *> *)headers
                                  params:(NSDictionary<NSString *, NSString *> *)params
                                   files:(NSDictionary<NSString *, NSString *> *)files
                              onProgress:(void(^)(float percent))progressBlock
                            onCompletion:(void (^)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error))completionBlock;

/**
 * 发送 application/json 格式的 POST 请求
 * @param apiUrl like @"http://…"
 * @param headers like @{@"key": @"value", …}
 * @param params like @{@"key": @"value", …}
 * @return nil if error occurred while JSON Serialization
 */
+ (NSURLSessionDataTask *_Nullable)postJsonTo:(NSString *)apiUrl
                             headers:(NSDictionary<NSString *, NSString *> *)headers
                              params:(NSDictionary<NSString *, NSString *> *)params
                          onProgress:(void(^)(float percent))progressBlock
                        onCompletion:(void (^)(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error))completionBlock;
@end

