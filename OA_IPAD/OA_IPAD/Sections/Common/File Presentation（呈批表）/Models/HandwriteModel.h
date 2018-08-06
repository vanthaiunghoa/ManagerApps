//
//  HandwriteModel.h
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//
//  服务器返回的手写轨迹

#import <UIKit/UIKit.h>

@interface HandwriteModel : NSObject

@property (nonatomic) CGPoint origin;
@property (nonatomic, strong) NSData *pngData;
@property (nonatomic, strong) NSString *recordIdentifier; //记录ID；用来区分当前这个用户的信息

@end
