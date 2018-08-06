//
//  AcessAvailability.m
//  OA_IPAD
//
//  Created by cello on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "AcessAvailability.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@implementation AcessAvailability

- (RACSignal *)requestCameraAuthorization {
    //TODO: 待实现
    return nil;
}

- (RACSignal *)requestAlbumAutorization {
    if (self.albumAvailable) {
        return [RACSignal return:@(YES)];
    }
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            @strongify(self);
            if (status == PHAuthorizationStatusAuthorized) {
                self.albumAvailable = YES;
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            }
            else if (status == PHAuthorizationStatusDenied) {
                self.albumAvailable = NO;
                [subscriber sendError:[NSError errorWithDomain:NSOSStatusErrorDomain code:499 userInfo:@{NSLocalizedDescriptionKey: @"用户拒绝访问相册"}]];
            }
            else {
                self.albumAvailable = NO;
                [subscriber sendNext:@(NO)];
            }
        }];
        return nil;
    }];
}

@end
