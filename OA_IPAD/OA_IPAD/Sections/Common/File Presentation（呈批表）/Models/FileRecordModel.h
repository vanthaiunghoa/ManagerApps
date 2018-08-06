//
//  FileRecordModel.h
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/23.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol FileRecordModel <NSObject>

- (NSString *)cpbName; //呈批表名字
- (NSString *)handleID; //办理记录ID
- (NSString *)number; //收文编号/发文编号
- (NSString *)qzh; //文件全宗号
- (CGPoint)origin;
- (NSString *)pngSignature; //PNG签名图Base64
- (NSString *)svgSignature; //SVG签名图Base64

@end
