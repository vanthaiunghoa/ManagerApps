//
//  SendFileHandleViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/6.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendFileHandleViewModel.h"
#import "SendFileService.h"

@implementation SendFileHandleViewModel

- (RACSignal *)fileHandleData {
    // 三个请求并行
    RACSignal *requestDetail = [[SendFileService shared] handleFileDetailForIdentifier:self.identifier];
    RACSignal *requestAttatchedFiles = [[SendFileService shared] attatchFilesForIdentifier:self.identifier];
    RACSignal *requestRecords = [[SendFileService shared] handleFileRecordsForIdentifier:self.identifier];
    
    RACSignal *response = [RACSignal zip:@[requestDetail, requestAttatchedFiles, requestRecords]];
    
    return response;
}

- (RACSignal *)saveAdvice {
    return [[SendFileService shared] saveAdivce:_advice
                                      assigment:_signature
                                recordIdentfier:_recordIdentifier
                                     finishDate:_dueDate
                                          state:(2 - _handled)];
}

@end
