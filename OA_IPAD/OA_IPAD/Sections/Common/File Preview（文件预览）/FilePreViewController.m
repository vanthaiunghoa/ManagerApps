//
//  FilePreViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/14.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "FilePreViewController.h"
#import <Masonry/Masonry.h>
#import "AttatchFileDownloader.h"
#import "MBProgressHUD+LCL.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "iAppOffice.h"
#import "MBProgressHUD+LCL.h"
#import <MJExtension/MJExtension.h>

@interface FilePreViewController () <WKNavigationDelegate, iAppOfficeDelegate>

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation FilePreViewController

- (void)dealloc {
    NSLog(@"%@ 销毁 ♻️", NSStringFromClass(self.class));
    
    _webView.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_webView];
    [self _setWebViewContaints];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 126, CGRectGetWidth(self.view.frame), 1)];
    _progressView.tintColor = [UIColor greenColor];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(0);
        make.height.mas_equalTo(@1);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    self.webView.navigationDelegate = self;
    
    RAC(self.progressView, progress) = RACObserve(self.webView, estimatedProgress);
    RAC(self.progressView, hidden) = [RACObserve(self.webView, loading) map:^id _Nullable(id  _Nullable value) {
        return @(![value boolValue]);
    }];
    
}

#pragma mark - actions

- (void)openAttatchFile:(id<AttatchFileModel>)file {
    NSURL *url = [[AttatchFileDownloader shared] cacheURLForFileName:file.name];
    self.fileURL = url;
    self.title = [url.lastPathComponent stringByDeletingPathExtension];
}

- (BOOL)openWPS {
    id<AttatchFileModel> file = self.fileModel;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[AttatchFileDownloader shared] cacheURLForFileName:file.name].path]) {
        NSURL *fileURL = [[AttatchFileDownloader shared] cacheURLForFileName:file.name];
        NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"iAppOffice权限" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
        NSDictionary *policy = [jsonData mj_JSONObject];
        [[iAppOffice sharedInstance] sendFileData:fileData fileName:file.name callback:nil delegate:self policy:policy completion:^(BOOL result, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
        }];
        return YES;
    } else {
        return NO;
    }
}

- (void)_setEditItem {
    if (self.viewModel.recordIdentifier)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTintColor:[UIColor whiteColor]];
        [btn setTitle:@"编辑" forState:0];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(openWPS) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

#pragma mark - webview
///*! @abstract Invoked when an error occurs while starting to load data for
// the main frame.
// @param webView The web view invoking the delegate method.
// @param navigation The navigation.
// @param error The error that occurred.
// */
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"didFailProvisionalNavigation withError%@", error);
//}
///*! @abstract Invoked when an error occurs during a committed main frame
// navigation.
// @param webView The web view invoking the delegate method.
// @param navigation The navigation.
// @param error The error that occurred.
// */
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"didFailNavigation withError %@", error);
//}
///*! @abstract Invoked when the web view's web content process is terminated.
// @param webView The web view whose underlying web content process was terminated.
// */
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
//    NSLog(@"webViewWebContentProcessDidTerminate");
//}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

#pragma mark - iAppOffice

- (void)officeDidReceivedData:(NSDictionary *)dict {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 获取文档数据、文档类型、文档名称
    NSData *fileData = [dict objectForKey:@"Body"];
    //    NSString *fileType = [dict objectForKey:@"FileType"];
    //    NSString *fileName = [dict objectForKey:@"FileName"];
    //    if (![fileName containsString:@"."]) {
    //        fileName = [fileName stringByAppendingPathExtension:fileType];
    //    }
    // 覆盖本地的附件数据
    id<AttatchFileModel> file = self.fileModel;
    NSURL *fileURL = [[AttatchFileDownloader shared] cacheURLForFileName:file.name];
    [fileData writeToURL:fileURL atomically:YES];
    self.fileURL = fileURL;
    [self saveFileToServer];
    
}



- (void)officeDidFinished {
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"" atView:self.view];
    [hud showMessage:@"完成编辑"];
}

- (void)officeDidAbort {
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"" atView:self.view];
    [hud showMessage:@"WPS终止"];
}

- (void)officeDidCloseWithError:(NSError *)error {
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"" atView:self.view];
    [hud showMessage:error.localizedDescription];
}

- (void)saveFileToServer {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.fileURL = fileURL; // 设置修改之后的附近
        id<AttatchFileModel> file = self.fileModel;
        NSURL *fileURL = [[AttatchFileDownloader shared] cacheURLForFileName:file.name];
        NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
        
        if (self.viewModel) {
            MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"正在同步.." atView:nil];
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            [[self.viewModel saveAttatchFile:file data:fileData] subscribeNext:^(id  _Nullable x) {
                if ([x isKindOfClass:[NSProgress class]]) {
                    hud.progress = [(NSProgress *)x fractionCompleted];
                } else {
                    NSLog(@"%@", x);
                }
            } error:^(NSError * _Nullable error) {
                NSLog(@"%@", error);
                [hud showMessage:error.localizedDescription];
            } completed:^{
                [hud showMessage:@"同步完成"];
            }];
        } else {
            MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"" atView:nil];
            [hud showMessage:@"信息不全"];
        }
    });
}

#pragma mark - getters and setters


- (void)_setWebViewContaints {
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).with.offset(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)setAutoScale:(BOOL)autoScale {
    if (autoScale && !_autoScale) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [wkWebConfig.userContentController addUserScript:wkUserScript];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        [self.view addSubview:_webView];
        [self _setWebViewContaints];
    }
    _autoScale = autoScale;
}


- (void)setFileURL:(NSURL *)fileURL {
    _fileURL = fileURL;
    [self.webView loadHTMLString:@"<html><p>请稍后...</p></html>" baseURL:nil];
    if (!_fileURL) {
        return;
    }
    [self _setEditItem];
    if (![[self.fileURL.lastPathComponent pathExtension] isEqualToString:@"txt"]) {
        //加载非txt文件
        [self.webView loadFileURL:self.fileURL allowingReadAccessToURL:self.fileURL];
    } else {
        //加载txt文本
        NSError *error = nil;
        NSString *text = [[NSString alloc] initWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSString *htmlStr = [NSString stringWithFormat:@"<html><body><p style=\"font-size:xx-large\">%@</p></body></html>", text];
            [self.webView loadHTMLString:htmlStr baseURL:nil];
        } else {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            text = [[NSString alloc] initWithContentsOfURL:self.fileURL encoding:enc error:&error];
            NSString *htmlStr = [NSString stringWithFormat:@"<html><body><p style=\"font-size:xx-large\">%@</p></body></html>", text];
            [self.webView loadHTMLString:htmlStr baseURL:nil];
        }
    }
}

- (void)setFileModel:(id<AttatchFileModel>)fileModel {
    //    if (_fileModel != fileModel) {
    [self.webView stopLoading];
    _fileModel = fileModel;
    self.navigationItem.rightBarButtonItem = nil; //先清除按钮
    AttatchFileDownloader *downloader = [AttatchFileDownloader shared];
    if (self.isMeeting) {
        downloader = [AttatchFileDownloader meeting];
    }
    
    id<AttatchFileModel> file = self.fileModel;
    MBProgressHUD *hud  = [MBProgressHUD HUDForView:self.view];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[AttatchFileDownloader shared] cacheURLForFileName:file.name].path]) {
        //文件已经存在缓存中
        [hud hideAnimated:YES];
        [self openAttatchFile:file];
        return;
    } else {
        self.fileURL = nil;
    }
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [hud customSettings];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = @"文件下载中..";
    
    AttatchFileDownloadTask *task;
    if (downloader.taskDict[file.identifier]) {
        task = downloader.taskDict[file.identifier];
    } else {
        task = [AttatchFileDownloadTask taskWithGUID:file.identifier getLengthAction:file.getSizeAction downloadAction:file.downloadAction appendingURL:file.serviceURL];
    }
    if (self.isMeeting) {
        task.maxLength = self.maxLength;
        task.meetingThemeID = self.themeID;
    }
    
    @weakify(self);
    [downloader downloadForTask:task progress:^(NSUInteger currentLength, NSUInteger maxLength) {
        if (maxLength > 0) {
            hud.progress = (float)(((double)currentLength)/((double)maxLength));
        }
    } completion:^(BOOL success, NSData *data, NSError *error) {
        @strongify(self);
        if (success) {
            NSLog(@"下载完成");
            [hud showMessage:@"下载完成"];
            [downloader cacheData:data fileName:file.name];
            [self openAttatchFile:file];
            [self _setEditItem];
        } else {
            [hud showMessage:error.localizedDescription];
            [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><h1>%@</html>", error.localizedDescription] baseURL:nil];
        }
    }];
    //    }
    
}

@end

