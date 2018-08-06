//
//  SendFilePresentationViewModel.m
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendFilePresentationViewModel.h"
#import "SendFileService.h"
#import "URLConfiguration.h"
#import "RequestManager.h"
#import "SendFileRecord.h"
#import "HandwriteModel.h"
#import "FilePreviewViewModel.h"

@implementation SendFilePresentationViewModel

- (Class)previewViewModelClass {
    return [FilePreviewViewModel class];
}

/**
 纪录
 
 @return <FileRecordModel>
 */
- (RACSignal *)requestRecord {
    return [[SendFileService shared] handleFileSendRecordForWhereID:self.whereGuid];
}

/**
 附件
 
 @return [<AttatchFileModel>]
 */
- (RACSignal *)requestAttatchFiles {
    return [[SendFileService shared] attatchFilesForIdentifier:self.mainGuid];
}

/**
 请求主表
 */
- (NSString *)cpbURLString {
    return SendFileCPBURL(_recordModel.CPB_Name, _recordModel.FileQZH, _recordModel.FWBH, _recordModel.HandleID);
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
    return [kBaseURL stringByAppendingString:SendFileServiceURL];
}

/**
 获取手写轨迹
 
 @return 一个或者多个HandwriteModel；注意区分处理
 */
- (RACSignal *)handwrittenRecords {
    RACSignal *records = [[SendFileService shared] handleFileRecordsForIdentifier:self.mainGuid];
    return [records map:^id _Nullable(NSArray *records) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:records.count];
        for (SendFileRecord *r in records) {
            if ([r.pngSignature length] > 0) {
                HandwriteModel *m = [HandwriteModel new];
                m.pngData = [[NSData alloc] initWithBase64EncodedString:r.pngSignature options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSArray *components = [r.SignatureCoordinate componentsSeparatedByString:@","];
                if (components.count == 2) { //坐标有
                    m.origin = CGPointMake([components[0] doubleValue], [components[1] doubleValue]);
                    m.recordIdentifier = r.Where_GUID;
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
}

@end
