//
//  ReceiveFilePresentationViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/23.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveFilePresentationViewModel.h"
#import "ReceiveTransactionService.h"
#import "ReceiveFileAttatchFileInfo.h"
#import "URLConfiguration.h"
#import "ReceiveFileType.h"
#import "ReceiveFileHandleRecord.h"
#import "HandwriteModel.h"
#import "FilePreviewViewModel.h"

@implementation ReceiveFilePresentationViewModel

- (Class)previewViewModelClass {
    return [FilePreviewViewModel class];
}


- (NSString *)cpbURLString {
    return ReceiveFileCPBURL(_recordModel.CPB_Name, _recordModel.FileQZH, _recordModel.SWBH, _recordModel.HandleID);
}

- (RACSignal *)requestAttatchFiles {
    return [[ReceiveTransactionService shared] receiveFileAttatchFilesWithIdentifier:self.mainGuid];
}

- (RACSignal *)requestRecord {
    return [[ReceiveTransactionService shared] receiveFileHandleRecordWithIdentifier:self.whereGuid];
}

- (RACSignal *)handwrittenRecords {
    
    RACSignal *fileTypes = [[ReceiveTransactionService shared] receiveFileType];
    RACSignal *requestRecords = [fileTypes flattenMap:^__kindof RACSignal * _Nullable(NSArray *types) {
        RACSignal *original = nil;
        for (ReceiveFileType *t in types) {
            RACSignal *record = [[ReceiveTransactionService shared] receiveFileHandleRecordsByIdentifier:self.mainGuid fileType:t.FlowName];
            
            if (!original) {
                original = record;
            } else {
                original = [original merge:record];
            }
        }
        return original;
    }];
    
    // 转成需要的Model
    RACSignal *mapValue = [requestRecords map:^id _Nullable(NSArray *records) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:records.count];
        for (ReceiveFileHandleRecord *r in records) {
            if ([r.pngSignature length] > 0) {
                HandwriteModel *m = [HandwriteModel new];
                m.pngData = [[NSData alloc] initWithBase64EncodedString:r.pngSignature options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSArray *components = [r.SignatureCoordinate componentsSeparatedByString:@","];
                if (components.count == 2) { //坐标有
                    m.origin = CGPointMake([components[0] doubleValue], [components[1] doubleValue]);
                    m.recordIdentifier = r.WhereGUID;
                    [array addObject:m];
                }
            }
        }
        if ([array count]) {
            return array;
        } else {
            return nil;
        }
    }];
    return mapValue;
}


/**
 上传呈批表Action
 */
- (NSString *)uploadCPBAction {
    return @"UpdataHtmlIsignature";
}

/**
 上传呈批表URL
 */
- (NSString *)uploadCPBURL {
    return [kBaseURL stringByAppendingString:ReceiveFileServiceURL];
}
@end
