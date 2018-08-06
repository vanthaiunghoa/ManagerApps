//
//  ReceiveFilePresentationViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/4/23.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReceiveFileHandleListModel.h"
#import "FilePresentationViewModel.h"

@interface ReceiveFilePresentationViewModel : NSObject <FilePresentationViewModel>

@property (nonatomic, strong) NSString *mainGuid;
@property (nonatomic, strong) NSString *whereGuid;
@property (nonatomic, strong) ReceiveFileHandleListModel *recordModel;


@end
