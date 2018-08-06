//
//  ReceiveTransactionService.m
//  OA_IPAD
//
//  Created by cello on 2018/3/28.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveTransactionService.h"
#import "RequestManager.h"
#import <MJExtension/MJExtension.h>
#import "ReceiveFileHandleListModel.h"
#import "NSDictionary+CreateModel.h"
#import "ReceiveFileType.h"
#import "ReceiveFileHandleRecord.h"
#import "ReceiveFileDetail.h"
#import "ReceiveFileAttatchFileInfo.h"
#import "AdviseCell.h"

@implementation ReceiveTransactionService

+  (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

/**
 获取收文办理记录信息（列表的其中一项；包含手写图片）
 
 @param Where_GUID 记录ID
 @return next一个ReceiveFileHandleListModel
 */
- (RACSignal *)receiveFileHandleRecordWithIdentifier:(NSString *)Where_GUID {
    if (!Where_GUID) {
        Where_GUID = @"";
    }
    NSDictionary *params = @{@"Where_GUID": Where_GUID};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"GetSWHandleMainRec" appendingURL:ReceiveFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                ReceiveFileHandleListModel *model = [ReceiveFileHandleListModel new];
                [model mj_setKeyValues:data[@"Datas"]];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

/**
 查看收文详情
 */
- (RACSignal *)receiveFileInfoWithIdentifier:(NSString *)whereGUID {
    if (!whereGUID) {
        whereGUID = @"";
    }
    NSDictionary *params = @{@"Main_GUID": whereGUID};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"GetSWMain" appendingURL:ReceiveFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                ReceiveFileDetail *model = [ReceiveFileDetail new];
                [data[@"Datas"] createModelWithName:@"ReceiveFileDetail"];
                [model mj_setKeyValues:data[@"Datas"]];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)receiveFileAttatchFilesWithIdentifier:(NSString *)identifier {
    if (!identifier) {
        identifier = @"";
    }
    NSDictionary *params = @{@"GUID": identifier};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"GetSWQWList" appendingURL:ReceiveFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSArray *responseData = data[@"Datas"];
                [[responseData firstObject] createModelWithName:@"ReceiveFileAttatchFileInfo"];
                NSArray *models = [ReceiveFileAttatchFileInfo mj_objectArrayWithKeyValuesArray:responseData];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
    
}

- (RACSignal *)receiveFileType {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"GetSWBLFlowList" appendingURL:ReceiveFileServiceURL parameters:@{} callback:^(BOOL success, id data, NSError *error) {
            if ([data[@"Datas"] isKindOfClass:[NSArray class]]) {
                //这个傻吊接口返回的失败、但是数据又返回了
                NSArray *responseData = data[@"Datas"];
                NSArray *models = [ReceiveFileType mj_objectArrayWithKeyValuesArray:responseData];
                [[responseData firstObject] createModelWithName:@"ReceiveFileType"];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

/**
 获取某办理类型的办理纪录
 
 @param identifier Main_GUID
 @param fileTypeName 文件类型名字（中文）
 @return 一个RACSignal；next返回[ReceiveFileType]
 */
- (RACSignal *)receiveFileHandleRecordsByIdentifier:(NSString *)identifier
                                           fileType:(NSString *)fileTypeName {
    if (!identifier) {
        identifier = @"";
    }
    if (!fileTypeName) {
        fileTypeName = @"";
    }
    NSDictionary *params = @{@"Main_GUID": identifier, @"FlowName": fileTypeName};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"GetSWBLHandleForFlow" appendingURL:ReceiveFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSArray *responseData = data[@"Datas"];
                [[responseData firstObject] createModelWithName:@"ReceiveFileHandleRecord"];
                NSArray *models = [ReceiveFileHandleRecord mj_objectArrayWithKeyValuesArray:responseData];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)receiveFileHandleAssignmentFile {
//    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [[RequestManager shared] requestWithAction:@"GetSW_CPB_List" appendingURL:ReceiveFileServiceURL parameters:@{} callback:^(BOOL success, id data, NSError *error) {
//            if (success) {
//                NSArray *responseData = data[@"Datas"];
////                [[responseData firstObject] createModelWithName:@"ReceiveFileSignatureFile"];
//                NSArray *models = [ReceiveFileSignatureFile mj_objectArrayWithKeyValuesArray:responseData];
//                [subscriber sendNext:models];
//                [subscriber sendCompleted];
//            } else {
//                [subscriber sendError:error];
//            }
//        }];
//        return nil;
//    }];
    return nil;
}

- (RACSignal *)saveHandleInfo:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"SWHandleSave" appendingURL:ReceiveFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

/**
 附件批改新记录写入数据库
 
 @param qwName 附件原名
 @param guid 收文MainGUID
 @param type 附件分类
 @return 返回一个字典；带有QW_GUID字段可以使用
 */
- (RACSignal *)recordSave:(NSString *)qwName
                  recGUID:(NSString *)guid
                   qwType:(NSString *)type {
    NSDictionary *params = @{@"QWName": qwName, @"recGUID": guid, @"QWType": type};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"InsertSWWhereQWInfo" appendingURL:ReceiveFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

/**
 一次性上传整个文件
 
 @param bytesBase64 字节流
 @param guid 附件GUID
 @return 成功或者失败信号
 */
- (RACSignal *)upload:(NSString *)bytesBase64
               qwGUID:(NSString *)guid {
    NSDictionary *params = @{@"fileSplitPosition": @"0", @"QW_GUID": guid, @"QWByteBase": bytesBase64, @"isLast": @"1"};
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"UpLoadSWWhereQW" appendingURL:ReceiveFileServiceURL parameters:params shouldDetectDictionary:NO callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                [subscriber sendNext:data];
                NSLog(@"上传成功");
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}
@end
