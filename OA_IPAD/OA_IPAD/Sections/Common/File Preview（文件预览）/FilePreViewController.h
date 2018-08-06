//
//  FilePreViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/4/14.
//  Copyright © 2018年 icebartech. All rights reserved.
//
//  预览文件

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "AttatchFileModel.h"
#import "FilePreviewViewModel.h"

@interface FilePreViewController : UIViewController

@property (nonatomic) BOOL autoScale;
@property (nonatomic, strong) NSURL *fileURL;
@property (strong, nonatomic) WKWebView *webView;

//会议需要设置
@property (nonatomic, strong) NSString *themeID;
@property (nonatomic) NSInteger maxLength;
@property (nonatomic) BOOL isMeeting; //会议的下载器不一样
@property (nonatomic, strong) FilePreviewViewModel *viewModel; //保存记录需要设置；以及whereID

@property (strong, nonatomic) id<AttatchFileModel> fileModel;

- (BOOL)openWPS; //文件未下载则返回失败

- (void)saveFileToServer;

@end
