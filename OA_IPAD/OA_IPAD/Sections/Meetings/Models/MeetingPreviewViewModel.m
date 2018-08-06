//
//  MeetingPreviewViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MeetingPreviewViewModel.h"
#import "RequestManager.h"
#import "MeetingsService.h"
#import <MJExtension/MJExtension.h>

@implementation MeetingPreviewViewModel

- (RACSignal *)saveAttatchFile:(id<AttatchFileModel>)attatchFile data:(NSData *)reviseData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    [responseSerializer custom];
    manager.responseSerializer = responseSerializer;
    NSString *requestURL = [NSString stringWithFormat:@"%@Handlers/QWUpLoaderHandler.ashx?MeetFlowQWID=%@", kMeetingBaseURL, attatchFile.identifier];
    NSLog(@"\n上传接口：%@; 文件： %@ %@\n", requestURL, attatchFile.name, attatchFile.identifier);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [manager POST:requestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:reviseData name:attatchFile.name fileName:attatchFile.name mimeType:@"application/pdf"];;
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:uploadProgress];
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id obj = [responseObject mj_JSONObject];
            if (obj) {
                [subscriber sendNext:obj];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:NSURLErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: [responseObject mj_JSONString]}]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

@end
