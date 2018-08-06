//
//  AttatchFileDownloader.h
//  OA_IPAD
//
//  Created by cello on 2018/4/13.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttatchFileDownloadTask.h"


@interface AttatchFileDownloader : NSObject

/**
 key:GUID, value:AttatchFileDownloadTask
 */
@property (nonatomic, strong) NSMutableDictionary *taskDict;

/**
 单例；可以选择不用单例模式

 @return 下载器实例
 */
+ (instancetype)shared;

/**
 会议的网络设置不一样；又得再建立一个单例
 */
+ (instancetype)meeting;

/**
 缓存路径
 */
@property (nonatomic, strong) NSString *cachePath;


/**
 下载某文件；内部是通过RACSubject发送信息给订阅者

 @param task 某任务。需要配置GUID、Action、AppendingURL等信息
 @param progress 下载进度回调
 @param completion 下载完成回调
 */
- (void)downloadForTask:(AttatchFileDownloadTask *)task
               progress:(DownloaderProgressBlock)progress
             completion:(DownloaderCompletionBlock)completion;


/**
 返回指定文件名的缓存URL

 @param fileName 文件名、包含后缀
 @return URL；nil则是不在缓存中
 */
- (NSURL *)cacheURLForFileName:(NSString *)fileName;
/**
 读缓存中的文件

 @param fileName 文件名；包含后缀
 @return 对应的data
 */
- (NSData *)cacheDataForFileName:(NSString *)fileName;

/**
 写入缓存
 @param data 文件流
 @param fileName 文件名；包含后缀
 */
- (void)cacheData:(NSData *)data fileName:(NSString *)fileName;

@end
