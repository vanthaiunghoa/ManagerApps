//
//  ReceiveFileHandleViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/2.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveFileHandleViewModel.h"
#import "ReceiveTransactionService.h"
#import "ReceiveFileType.h"
#import "RequestManager.h"
#import "FileTransferCell.h"

@implementation ReceiveFileHandleViewModel

- (NSString *)autoGenerateSentence {
    NSMutableString *advice = [[NSMutableString alloc] init];
    if ([_transferLeaderReceivers count]) {
        [advice appendString:_transferLeaderOperator];
        [advice appendString:[_transferLeaderReceivers mapToNames]];
        [advice appendString:@"批示"];
        [advice appendString:@"；"];
    }
    if ([_transferHostReceivers count]) {
        [advice appendString:_transferOperator2];
        [advice appendString: _transferHostReceivers.mapToNames];
        [advice appendString:@"主办"];
        [advice appendString:@"；"];
    }
    if ([_transferAssistReceivers count]) {
        [advice appendString:_transferOperator2];
        [advice appendString: _transferAssistReceivers.mapToNames];
        [advice appendString:@"协办"];
        [advice appendString:@"；"];
    }
    if ([_transferReadReceivers count]) {
        [advice appendString:_transferOperator2];
        [advice appendString: _transferReadReceivers.mapToNames];
        [advice appendString:@"传阅"];
        [advice appendString:@"。"];
    }
    if (advice.length > 1 && [[advice substringWithRange:NSMakeRange(advice.length-1, 1)] isEqualToString:@"；"]) {
        [advice replaceCharactersInRange:NSMakeRange(advice.length-1, 1) withString:@"。"];
    }
    if (advice.length == 0) {
        [advice appendString:@"已阅。"];
    }
    return advice;
}


- (RACSignal *)receiveFileDetail {
    return [[ReceiveTransactionService shared] receiveFileInfoWithIdentifier:self.mainGUID];
}

- (RACSignal *)hanldedRecords {
    
    RACSignal *fileTypes = [[ReceiveTransactionService shared] receiveFileType];
    RACSignal *requestRecords = [fileTypes flattenMap:^__kindof RACSignal * _Nullable(NSArray *types) {
        RACSignal *original = nil;
        for (ReceiveFileType *t in types) {
            RACSignal *record = [[ReceiveTransactionService shared] receiveFileHandleRecordsByIdentifier:self.mainGUID fileType:t.FlowName];
            
            if (!original) {
                original = record;
            } else {
                original = [original merge:record];
            }
        }
        return original;
    }];
    return requestRecords;
}

- (RACSignal *)saveAdvice {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Where_GUID"] = [self.whereGUID copy];
    params[@"IFOK"] = @(2-self.handled);
    params[@"YiJian"] = self.advice? self.advice: @"";
    params[@"BLTime"] = self.signDate;
    params[@"SignUp"] = self.signature? self.signature: @"";
    params[@"SendUserLastDate"] = self.fileDueDate;
    NSMutableString *receiverIDs = [[NSMutableString alloc] init];
    NSMutableString *receiverTypes = [[NSMutableString alloc] init];
    if ([self.transferLeaderReceivers count]) {
        for (Personel *p in self.transferLeaderReceivers) {
            [receiverIDs appendString:p.UserSNID];
            [receiverIDs appendString:@";"];
            [receiverTypes appendString:@"批示"];
            [receiverTypes appendString:@";"];
        }
    }
//    if (self.transferMainReceiver) {
//        [receiverIDs appendString:self.transferMainReceiver.UserSNID];
//        [receiverIDs appendString:@";"];
//        [receiverTypes appendString:@"主办"];
//        [receiverTypes appendString:@";"];
//    }
    if ([self.transferHostReceivers count]) {
        for (Personel *p in self.transferHostReceivers) {
            [receiverIDs appendString:p.UserSNID];
            [receiverIDs appendString:@";"];
            [receiverTypes appendString:@"主办"];
            [receiverTypes appendString:@";"];
        }
    }
    if ([self.transferAssistReceivers count]) {
        for (Personel *p in self.transferAssistReceivers) {
            [receiverIDs appendString:p.UserSNID];
            [receiverIDs appendString:@";"];
            [receiverTypes appendString:@"协办"];
            [receiverTypes appendString:@";"];
        }
    }
    if ([self.transferReadReceivers count]) {
        for (Personel *p in self.transferReadReceivers) {
            [receiverIDs appendString:p.UserSNID];
            [receiverIDs appendString:@";"];
            [receiverTypes appendString:@"传阅"];
            [receiverTypes appendString:@";"];
        }
    }
    params[@"SendUserSNID"] = receiverIDs;
    params[@"SendUserBLSort"] = receiverTypes;
    
//    PLog(@"param == %@", params);
    
    return [[ReceiveTransactionService shared] saveHandleInfo:params];
}


- (RACSignal *)receiveFileAttachFiles {
    return [[ReceiveTransactionService shared] receiveFileAttatchFilesWithIdentifier:self.mainGUID];
}

@end
