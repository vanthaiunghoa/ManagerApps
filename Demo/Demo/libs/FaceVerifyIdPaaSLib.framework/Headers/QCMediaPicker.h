//
// Created by fantouch on 16/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QCMediaPicker : NSObject

- (instancetype)initWithController:(UIViewController *)controller;

- (void)imageFromLibrary:(void(^)(NSURL *fileUrl))finishBlock;

- (void)imageFromCamera:(void (^)(NSURL *fileUrl))finishBlock;

- (void)videoFromLibrary:(void(^)(NSURL *fileUrl))finishBlock;

- (void)videoFromCamera:(void(^)(NSURL *fileUrl))finishBlock;


@end
