//
//  NetworkManager.m
//  OA_IPAD
//
//  Created by cello on 2018/3/24.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

NSString const* serializationErrorMsg = @"序列化出错";
NSInteger const serializationErrorCode = 3202;

@interface NetworkManager()

@property (nonatomic, strong) AFHTTPSessionManager *afManager;

@end

@implementation NetworkManager

+ (instancetype)shared
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        [instance _configureHTTPRequest];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)_configureHTTPRequest
{
    self.logInfo = YES;
    [self configureHTTPRequestWithBaseURL:@"http://192.168.0.60:9998/archivesApp/"];
}

- (void)configureHTTPRequestWithBaseURL:(NSString *)baseURLString
{
    _afManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [responseSerializer custom];
    _afManager.responseSerializer = responseSerializer;
}


- (NSURLSessionDataTask *)requestWithAction:(NSString *)action
                               appendingURL:(NSString *)appendingURL
                                 parameters:(NSDictionary *)params
                     shouldDetectDictionary:(BOOL)shouldDetectDictionary
                                   callback:(RequestCallback)callback {
    if (!appendingURL) {
        NSLog(@"🈚️ 请输入appendingURL！！");
        callback(NO, nil, nil);
        return nil;
    }
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    mutableParams[@"ActiveCode"] = [NetworkManager shared].activeCode;
    NSString *jsonString = [mutableParams mj_JSONString];
    
//    //转成GB3212编码
    NSString *gb3212String = [jsonString UTF8ToGB2312];
    
    if (!gb3212String) jsonString = @""; //无参数情况
    
    NSDictionary *newParamDict = @{@"Action":action,@"jsonRequest": gb3212String};
    NSString *urlString = [self.afManager.baseURL.absoluteString stringByAppendingString:appendingURL];
    if (self.logInfo) {
        NSLog(@"开始请求： %@?Action=%@", urlString, action);
    }
    
    
    __block NSTimeInterval timeStamp = [NSDate new].timeIntervalSince1970;
    __weak typeof(self) weakSelf = self;
    
    return [_afManager POST:appendingURL parameters:newParamDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSData   * _Nullable responseObject) {
        
        NSTimeInterval now = [NSDate new].timeIntervalSince1970;
        NSTimeInterval requestMilliSeconds = (now-timeStamp)*1000;
        
        NSString *responseString;
        if (self.NeedGB2312Decode) {
            responseString = [responseObject GB2312EncodeToUTF8String];
        } else {
            responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        
        if (weakSelf.logInfo) {
            NSLog(@"\n📞---\nurl:%@ action:%@:\n 参数:%@\n 响应时间:%.2fms",urlString, action, [mutableParams mj_JSONString], requestMilliSeconds);
            NSLog(@"\n响应数据：%@\n📞---\n", responseString);
        }
        NSDictionary *responseDict = [responseString mj_JSONObject];
        if ([responseDict isKindOfClass:[NSArray class]]) {
            callback(YES, responseDict, nil); //不按格式来；直接返回数组。。。
            return ;
        }
        BOOL successFlag = [responseDict[@"IsSuccess"] boolValue];
        
        if (responseDict || !shouldDetectDictionary ) {
            if (!responseDict) {
                callback(YES, responseString, nil);
            } else {
                if (successFlag) {
                    callback(YES, responseDict, nil);
                } else {
                    NSInteger errorCode = [responseDict[@"ErrorCode"] integerValue];
                    NSString *errorMsg = responseDict[@"ErrorMessage"];
                    if (!errorMsg) errorMsg = @"未知错误";
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
                    callback(NO, responseDict, error);
                }
            }
            
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:serializationErrorCode userInfo:@{NSLocalizedDescriptionKey: serializationErrorMsg}];
            callback(NO, nil, error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callback(NO, nil, error);
    }];
}

- (NSURLSessionDataTask *)requestWithAction:(NSString *)action
                               appendingURL:(NSString *)appendingURL
                                 parameters:(NSDictionary *)params
                                   callback:(RequestCallback)callback {
    return [self requestWithAction:action appendingURL:appendingURL parameters:params shouldDetectDictionary:YES callback:callback];
}

- (void)requestWithURL:(NSString *)url
            parameters:(NSDictionary *)params
              callback:(RequestCallback)callback
{
    [_afManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress)
    {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        callback(YES, dict, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        PLog(@"请求失败--%@",error.userInfo);
        callback(NO, nil, error);
    }];
}

@end

@implementation NSData(GB2312)

- (NSString *)GB2312EncodeToUTF8String {
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:self encoding:enc];
    return retStr;
}
@end

@implementation NSString(GB2312)

- (NSString *)UTF8ToGB2312 {

    NSData *utf8Data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *newSelf = [[NSString alloc] initWithData:utf8Data encoding:NSUTF8StringEncoding];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [newSelf dataUsingEncoding:enc];
    NSString *ret = [[NSString alloc] initWithData:data encoding:enc];
    return ret;
}

@end

@implementation AFHTTPRequestSerializer(NetworkManager)

- (void)custom {
    // 暂时没自定义
}

@end


@implementation AFHTTPResponseSerializer(NetworkManager)

- (void)custom {
    NSMutableSet *newAcceptContentTypes = [NSMutableSet setWithSet:self.acceptableContentTypes];
    //扩展固定解析响应类型
    [newAcceptContentTypes addObjectsFromArray:@[@"text/plain",
                                                 @"application/json",
                                                 @"text/json",
                                                 @"application/xml",
                                                 @"text/html",
                                                 @"image/tiff",
                                                 @"image/jpeg",
                                                 @"image/gif",
                                                 @"image/png",
                                                 @"image/ico",
                                                 @"image/x-icon",
                                                 @"image/bmp",
                                                 @"image/x-bmp",
                                                 @"image/x-xbitmap",
                                                 @"image/x-win-bitmap"]];
    
    
    self.acceptableContentTypes = newAcceptContentTypes;
}

@end
