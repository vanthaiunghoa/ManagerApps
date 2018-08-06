//
//  AttatchFileDownloadTask.m
//  OA_IPAD
//
//  Created by cello on 2018/4/13.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "AttatchFileDownloadTask.h"

@implementation AttatchFileDownloadTask

- (void)dealloc {
    self.completionBlock = nil;
    self.progressBlock = nil;
    self.receiveData = nil;
    NSLog(@"Task %@ delloc ♻️", self.GUID);
}

- (NSMutableData *)receiveData {
    if (!_receiveData) {
        _receiveData = [NSMutableData data];
    }
    return _receiveData;
}

- (NSUInteger)currentLength {
    return self.receiveData.length;
}

+ (AttatchFileDownloadTask *)taskWithGUID:(NSString *)guid
                          getLengthAction:(NSString *)getLengthAction
                           downloadAction:(NSString *)downloadAction
                             appendingURL:(NSString *)url{
    AttatchFileDownloadTask *task = [AttatchFileDownloadTask new];
    task.GUID = guid;
    task.getLengthAction = getLengthAction;
    task.downloadAction = downloadAction;
    task.appendingURL = url;
    return task;
}
@end
