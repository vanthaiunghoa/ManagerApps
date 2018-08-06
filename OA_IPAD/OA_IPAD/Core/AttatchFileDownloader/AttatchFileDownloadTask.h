//
//  AttatchFileDownloadTask.h
//  OA_IPAD
//
//  Created by cello on 2018/4/13.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloaderProgressBlock)(NSUInteger currentLength, NSUInteger maxLength);
typedef void(^DownloaderCompletionBlock)(BOOL success, NSData *data, NSError *error);

@interface AttatchFileDownloadTask : NSObject

@property (nonatomic, readonly) NSUInteger currentLength;
@property (nonatomic) NSUInteger maxLength;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, copy) NSString *GUID;
@property (nonatomic, copy) NSString *meetingThemeID; //会议需要额外设置
@property (nonatomic, copy) DownloaderProgressBlock progressBlock;
@property (nonatomic, copy) DownloaderCompletionBlock completionBlock;
@property (nonatomic, copy) NSString *getLengthAction;
@property (nonatomic, copy) NSString *appendingURL;
@property (nonatomic, copy) NSString *downloadAction;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileExtension;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *finishDate;

+ (AttatchFileDownloadTask *)taskWithGUID:(NSString *)guid
                          getLengthAction:(NSString *)getLengthAction
                           downloadAction:(NSString *)downloadAction
                             appendingURL:(NSString *)url;

@end
