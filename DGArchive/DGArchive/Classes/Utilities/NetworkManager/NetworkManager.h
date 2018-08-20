//
//  NetworkManager.h
//  OA_IPAD
//
//  Created by cello on 2018/3/24.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^RequestCallback)(BOOL success, id data, NSError *error);


FOUNDATION_EXPORT NSString const *serializationErrorMsg;
FOUNDATION_EXPORT NSInteger const serializationErrorCode;

@interface NetworkManager : NSObject

@property (nonatomic, copy) NSString *activeCode; //登录成功后，需要设置这个属性

@property (nonatomic) BOOL NeedGB2312Decode;
/**
 设置这个属性、YES则打印信息、NO则不打印信息；有些太多了
 */
@property (nonatomic) BOOL logInfo;

/**
 单例创建；最好使用单例来请求，因为单例会在app生命周期中一直存在
 不会因为某个ViewController销毁而销毁

 @return 返回一个内存中唯一的实例
 */
+ (instancetype)shared;

/**
 实例化之后调用；可以实现配置不同的URL

 @param baseURLString 请求的基址
 */
- (void)configureHTTPRequestWithBaseURL:(NSString *)baseURLString;


/**
 像后台请求非媒体数据

 @param action 后台需要具体的请求操作；比如 Login
 @param appendingURL baseURL后面拼接的路径；比如用户相关有用户相关的appendingurl
 @param params 具体的参数
 @param callback 回调； 后台返回的错误需要转化成NSError, 方便RAC操作
 @return 当前的请求任务；返回这个值可以做一些cancel的处理
 */
- (NSURLSessionDataTask *)requestWithAction:(NSString *)action
                               appendingURL:(NSString *)appendingURL
                                 parameters:(NSDictionary *)params
                                   callback:(RequestCallback)callback;

/**
 像后台请求非媒体数据
 
 @param action 后台需要具体的请求操作；比如 Login
 @param appendingURL baseURL后面拼接的路径；比如用户相关有用户相关的appendingurl
 @param params 具体的参数
 @param shouldDetectDictionary 是否要检测返回数据是否为字典；传NO，则遇到字符串也会返回成功
 @param callback 回调； 后台返回的错误需要转化成NSError, 方便RAC操作
 @return 当前的请求任务；返回这个值可以做一些cancel的处理
 */
- (NSURLSessionDataTask *)requestWithAction:(NSString *)action
                               appendingURL:(NSString *)appendingURL
                                 parameters:(NSDictionary *)params
                     shouldDetectDictionary:(BOOL)shouldDetectDictionary
                                   callback:(RequestCallback)callback;

- (void)requestWithURL:(NSString *)url
            parameters:(NSDictionary *)params
              callback:(RequestCallback)callback;


@end

@interface NSData(GB2312)

- (NSString *)GB2312EncodeToUTF8String;

@end

@interface NSString(GB2312)

- (NSString *)UTF8ToGB2312;

@end

@interface AFHTTPRequestSerializer(NetworkManager)

- (void)custom;

@end


@interface AFHTTPResponseSerializer(NetworkManager)

- (void)custom;

@end
