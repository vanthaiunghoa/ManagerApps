//
//  AttatchFileDownloader.m
//  OA_IPAD
//
//  Created by cello on 2018/4/13.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "AttatchFileDownloader.h"
#import "RequestManager.h"
#import "MeetingsService.h"

@interface AttatchFileDownloader()


@property (strong, nonatomic) RequestManager *requestManager;

@end

@implementation AttatchFileDownloader

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

/**
 会议的网络设置不一样；又得再建立一个单例
 */
+ (instancetype)meeting {
    static AttatchFileDownloader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
        instance.requestManager.NeedGB2312Decode = YES;
        [instance.requestManager configureHTTPRequestWithBaseURL:kMeetingBaseURL];
        instance.requestManager.logInfo = YES;
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    self.cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Attatch Files"];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.cachePath withIntermediateDirectories:YES attributes:@{NSFileProtectionKey: NSFileProtectionNone} error:nil];
    return self;
}


- (void)downloadForTask:(AttatchFileDownloadTask *)task
               progress:(DownloaderProgressBlock)progress
             completion:(DownloaderCompletionBlock)completion {
    if (!task.GUID) {
        completion(NO, nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:@{NSLocalizedDescriptionKey: @"GUID不能为空！"}]);
    }
    task.completionBlock = completion;
    task.progressBlock = progress;
    self.taskDict[task.GUID] = task;
    [self _startTask:task];
}

- (NSURL *)cacheURLForFileName:(NSString *)fileName {
    NSString *filePath = [self.cachePath stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:filePath];
}

- (NSData *)cacheDataForFileName:(NSString *)fileName {
    NSString *filePath = [self cacheURLForFileName:fileName].path;
    return [NSData dataWithContentsOfFile:filePath];
}

- (void)cacheData:(NSData *)data fileName:(NSString *)fileName {
    NSString *filePath = [self cacheURLForFileName:fileName].path;
    [data writeToFile:filePath atomically:YES];
}

#pragma mark - private

- (void)_startTask:(AttatchFileDownloadTask *)task {
    //获取大小
    task.startDate = [NSDate new];
    __weak AttatchFileDownloader *weakSelf = self;
    
    if (task.maxLength) {
        [self _streamingTask:task];
    } else {
        [self.requestManager requestWithAction:task.getLengthAction appendingURL:task.appendingURL parameters:@{@"GUID": task.GUID} callback:^(BOOL success, id data, NSError *error) {
            AttatchFileDownloader *strongSelf = weakSelf;
            if (success) {
                task.maxLength = [data[@"fileLength"] unsignedIntegerValue];
                task.fileName = data[@"WebFileName"];
                task.fileExtension = data[@"Extension"];
                [strongSelf _streamingTask:task];
            } else {
                task.completionBlock(NO, nil, error);
            }
        }];
    }
    
}

- (void)_streamingTask:(AttatchFileDownloadTask *)task {
    __weak AttatchFileDownloader *weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"GUID": task.GUID, @"startPosition": @(task.currentLength), @"getLenght": @(1024*256)}];
    if (task.meetingThemeID) {
        params[@"MeetFlowSNID"] = task.meetingThemeID;
        params[@"QWSNID"] = task.meetingThemeID;
        params[@"QWID"] = task.GUID;
    }
    NSInteger nextLength = MIN(1024*256, task.maxLength-task.currentLength);
    params[@"getLength"] = @(nextLength);
    
    [self.requestManager requestWithAction:task.downloadAction appendingURL:task.appendingURL parameters:params callback:^(BOOL success, id data, NSError *error) {
        AttatchFileDownloader *strongSelf = weakSelf;
        if (success) {
            NSString *byteString = data[@"QWBytes"];
            NSData *responseData = [[NSData alloc] initWithBase64EncodedString:byteString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            if (responseData) {
                [task.receiveData appendData:responseData];
                task.progressBlock(task.currentLength, task.maxLength);
                if (task.currentLength < task.maxLength) {
                    [strongSelf _streamingTask:task]; //继续拼接
                } else {
                    task.finishDate = [NSDate new];
                    NSLog(@"下载耗时 %f秒", task.startDate.timeIntervalSinceNow * -1);
                    task.completionBlock(YES, task.receiveData, nil);
                    [strongSelf _removeTask:task];
                }
            } else {
                task.receiveData = nil;
                task.completionBlock(NO, nil, error);
                [strongSelf _removeTask:task];
            }
        } else {
            task.completionBlock(NO, nil, error);
        }
    }];
}

- (void)_removeTask:(AttatchFileDownloadTask *)task {
    self.taskDict[task.GUID] = nil;
}

- (void)_cancelTask:(AttatchFileDownloadTask *)task {
    //暂时不需实现
}

#pragma mark - getter and setter
- (NSMutableDictionary *)taskDict {
    if (!_taskDict) {
        _taskDict = [NSMutableDictionary dictionary];
    }
    return _taskDict;
}

- (RequestManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [RequestManager new];
        _requestManager.activeCode = [RequestManager shared].activeCode;
        [_requestManager configureHTTPRequestWithBaseURL:kBaseURL];
        _requestManager.logInfo = NO;
    }
    return _requestManager;
}
@end
