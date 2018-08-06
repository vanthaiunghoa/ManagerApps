//
//  FilePreviewViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/4/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "AttatchFileModel.h"

@interface FilePreviewViewModel : NSObject

@property (nonatomic, copy) NSString *recordIdentifier;

/**
 保存附件的手写揭露
 override this
 @param attatchFile 附件对象模型
 @param reviseData 附件修改之后的新文件
 @return 成功或者失败
 */
- (RACSignal *)saveAttatchFile:(id<AttatchFileModel>)attatchFile
                          data:(NSData *)reviseData;

@end
