//
//  SendFileHandleViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/4/6.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface SendFileHandleViewModel : NSObject

@property (copy, nonatomic) NSString *advice; //办理意见
@property (copy, nonatomic) NSString *signature;//落款人
@property (strong, nonatomic) NSString *identifier; //文件登记的GUID
@property (strong, nonatomic) NSString *recordIdentifier; //当前纪录的ID
@property (strong, nonatomic) NSString *dueDate; //截止日期
@property (assign, nonatomic) BOOL handled; //NO 办理中， YES 办完

/**
 获取页面显示所需要的数据

 @return 返回一个RACTuple；第一个是SendFileDetail对象
 第二个是[SendFileAttatchFileInfo] 第三个是[SendFileRecord]
 */
- (RACSignal *)fileHandleData;

/**
 保存意见

 @return 成功的时候，返回成功信息
 */
- (RACSignal *)saveAdvice;

@end
