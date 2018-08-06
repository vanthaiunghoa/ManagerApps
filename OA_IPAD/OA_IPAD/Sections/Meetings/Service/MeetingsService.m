//
//  MeetingsService.m
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MeetingsService.h"
#import "RequestManager.h"
#import "NSDictionary+CreateModel.h"
#import <MJExtension/MJExtension.h>
#import "URLConfiguration.h"
#import "MeetingsInfo.h"
#import "MeetingAttatchFile.h"
#import "MeetingTheme.h"

@interface MeetingsService()

@property (nonatomic, strong) RequestManager *requestManager;

@end

@implementation MeetingsService

+ (instancetype)shared {
    static MeetingsService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MeetingsService new];
        instance.requestManager = [RequestManager new];
        instance.requestManager.NeedGB2312Decode = YES;
        [instance.requestManager configureHTTPRequestWithBaseURL: kMeetingBaseURL];
        instance.requestManager.logInfo = YES;
    });
    return instance;
}

- (RACSignal *)meetingsInfoForIdentifier:(NSString *)identifier {
    if (!identifier) {
        identifier = @"";
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [self.requestManager requestWithAction:@"GetMeetInfoForView" appendingURL:MeetingsServiceURL parameters:@{@"SNID": identifier} callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSDictionary *modelDict = data[@"datas"];
                [modelDict createModelWithName:@"MeetingsInfo"];
                MeetingsInfo *model = [MeetingsInfo new];
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

- (RACSignal *)otherMeetingsForMeetingIdentifier:(NSString *)identifier {
    if (!identifier) {
        identifier = @"";
    }
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [self.requestManager requestWithAction:@"GetOthenMeetInfo" appendingURL:MeetingsServiceURL parameters:@{@"CurrSNID": identifier, @"MeetNum": @6} callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                NSArray *responseData = data[@"datas"];
                NSArray *models = [MeetingsInfo mj_objectArrayWithKeyValuesArray:responseData];
                [subscriber sendNext:models];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}


- (RACSignal *)meetingThemeInfosForMeetingID:(NSString *)meetingID
                                     themeID:(NSString *)themeID {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
       NSURLSessionDataTask *task = [self.requestManager requestWithAction:@"GetMeetFlowInfoForView" appendingURL:MeetingsServiceURL parameters:@{@"MeetSNID": meetingID, @"MeetFlowSNID": themeID} callback:^(BOOL success, id data, NSError *error) {
            if (success) {
                MeetingTheme *model = [MeetingTheme new];
                NSDictionary *responseData = data[@"datas"];
                [model mj_setKeyValues:responseData];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)saveAttatchFile:(id<AttatchFileModel>)file
                       themeID:(NSString *)themeID
                          data:(NSData *)data {
    NSString *bytes = [data base64EncodedStringWithOptions:0];
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSDictionary *params = @{@"fileSplitPosition": @"0", @"MeetFlowSNID": themeID, @"QWID": file.identifier, @"QWByteBase64": bytes};
        [self.requestManager requestWithAction:@"UpLoadMeetFlowQW" appendingURL:MeetingsServiceURL parameters:params callback:^(BOOL success, id data, NSError *error) {
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
@end
