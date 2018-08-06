//
//  AcessAvailability.h
//  OA_IPAD
//
//  Created by cello on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//
//  系统权限统一在这里获取

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface AcessAvailability : NSObject

@property (nonatomic) BOOL cameraAvailable;
@property (nonatomic) BOOL albumAvailable;

/**
 请求相机访问权限
 */
- (RACSignal *)requestCameraAuthorization;
/**
 请求相册访问权限
 */
- (RACSignal *)requestAlbumAutorization;

@end
