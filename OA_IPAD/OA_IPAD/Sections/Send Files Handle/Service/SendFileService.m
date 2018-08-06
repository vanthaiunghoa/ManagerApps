//
//  SendFileService.m
//  OA_IPAD
//
//  Created by cello on 2018/4/4.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendFileService.h"
#import "RequestManager.h"
#import "NSDictionary+CreateModel.h"
#import "SendFileListItem.h"
#import "SendFileDetail.h"
#import "MJExtension.h"
#import "SendFileSearchItem.h"
#import "SendFileRecord.h"
#import "HandleSendRecord.h"
#import "SendFileAttatchFileInfo.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation SendFileService

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (RACSignal *)handleFileDetailForIdentifier:(NSString *)identifier {
    if (!identifier) {
        return [RACSignal error:nil];
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"GUID":identifier}];
        [[RequestManager shared] requestWithAction:@"GetFWRecordInfoByGUID" appendingURL:SendFileServiceURL parameters:dict callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSDictionary *modelDict = data[@"RecInfo"];
                [modelDict createModelWithName:@"SendFileDetail"];
                SendFileDetail *model = [SendFileDetail new];
                [model mj_setKeyValues:modelDict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)handleFileRecordsForIdentifier:(NSString *)identifier {
    if (!identifier) {
        return [RACSignal error:nil];
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"GUID":identifier}];
        [[RequestManager shared] requestWithAction:@"GetFW_BLQK" appendingURL:SendFileServiceURL parameters:dict callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSDictionary *modelDict = [data[@"Datas"] firstObject];
                [modelDict createModelWithName:@"SendFileRecord"];
                NSArray *models = [SendFileRecord mj_objectArrayWithKeyValuesArray:data[@"Datas"]];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)attatchFilesForIdentifier:(NSString *)identifier {
    if (!identifier) {
        return [RACSignal error:nil];
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"GUID":identifier}];
        [[RequestManager shared] requestWithAction:@"GetFWFileList" appendingURL:SendFileServiceURL parameters:dict callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSDictionary *modelDict = [data[@"Datas"] firstObject];
                [modelDict createModelWithName:@"SendFileAttatchFileInfo"];
                NSArray *models = [SendFileAttatchFileInfo mj_objectArrayWithKeyValuesArray:data[@"Datas"]];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)saveAdivce:(NSString *)advice assigment:(NSString *)assignment recordIdentfier:(NSString *)recordIdentfier finishDate:(NSString *)finishDate state:(NSInteger)state {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:8];
    params[@"Where_GUID"] = recordIdentfier? recordIdentfier: @"";
    params[@"YiJian"] = advice? advice: @"";
    params[@"Signup"] = assignment? assignment: @"";
    params[@"FinishDate"] = finishDate? finishDate: @"";
    params[@"IFok"] = @(state);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"SaveFWHandleInfo" appendingURL:SendFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                [subscriber sendNext:@"发送成功"];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)handleFileSendRecordForWhereID:(NSString *)whereID {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    params[@"Where_GUID"] = whereID? whereID: @"";
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[RequestManager shared] requestWithAction:@"GetFWHandleSendRecord" appendingURL:SendFileServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSDictionary *modelDict = data[@"RecInfo"];
                [modelDict createModelWithName:@"HandleSendRecord"];
                HandleSendRecord *model = [HandleSendRecord new];
                [model mj_setKeyValues:modelDict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

@end
