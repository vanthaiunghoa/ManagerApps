//
//  AttatchFileModel.h
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/23.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@protocol AttatchFileModel <NSObject>

@property (nonatomic, strong) NSString *name;
- (NSString *)identifier;

- (NSString *)getSizeAction;
- (NSString *)downloadAction;
- (NSString *)serviceURL;


@end
