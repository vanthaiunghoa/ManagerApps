//
// Created by fantouch on 15/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import "LivedetectfourController.h"
#import "Logger.h"
#import "FileSize.h"
#import "UserInfo.h"
#import <FaceVerifyIdPaaSLib/QCMediaPicker.h>
#import <FaceVerifyIdPaaSLib/QCLocalAuthorizationGenerator.h>
#import <FaceVerifyIdPaaSLib/QCHttpEngine.h>

@implementation LivedetectfourController {
    __weak IBOutlet UITextField *_validateDataField;
    __weak IBOutlet UITextField *_seqField;
    __weak IBOutlet UIBarButtonItem *_backBtn;
    __weak IBOutlet UIButton *_chooseImgBtn;
    __weak IBOutlet UIButton *_captureImgBtn;
    __weak IBOutlet UITextField *_imgPathField;
    __weak IBOutlet UIButton *_chooseVideoBtn;
    __weak IBOutlet UIButton *_captureVideoBtn;
    __weak IBOutlet UITextField *_videoPathField;
    __weak IBOutlet UIButton *_sendBtn;
    __weak IBOutlet UIButton *_cancelBtn;
    __weak IBOutlet UITextView *_logText;

    NSURLSessionDataTask *_currentTask;
    QCMediaPicker *_picker;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [_backBtn setTarget:self];
    [_backBtn setAction:@selector(onBackBtnClick)];
    [_chooseImgBtn addTarget:self action:@selector(onChooseImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_captureImgBtn addTarget:self action:@selector(onCaptureImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_chooseVideoBtn addTarget:self action:@selector(onChooseVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_captureVideoBtn addTarget:self action:@selector(onCaptureVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn addTarget:self action:@selector(onSendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _picker = [[QCMediaPicker alloc] initWithController:self];
}

- (void)onChooseImgBtnClick {
    [_picker imageFromLibrary:^(NSURL *fileUrl) {
        NSString *urlStr = [fileUrl absoluteString];
        [_imgPathField setText:urlStr];

        NSString *size = [FileSize sizeOf:fileUrl];
        [Logger log:[NSString stringWithFormat:@"%@, %@", urlStr, size] andPrintTo:_logText];
    }];
}

- (void)onCaptureImgBtnClick {
    [_picker imageFromCamera:^(NSURL *fileUrl) {
        NSString *urlStr = [fileUrl absoluteString];
        [_imgPathField setText:urlStr];

        NSString *size = [FileSize sizeOf:fileUrl];
        [Logger log:[NSString stringWithFormat:@"%@, %@", urlStr, size] andPrintTo:_logText];
    }];
}

- (void)onChooseVideoBtnClick {
    [_picker videoFromLibrary:^(NSURL *fileUrl) {
        NSString *urlStr = [fileUrl absoluteString];
        [_videoPathField setText:urlStr];

        NSString *size = [FileSize sizeOf:fileUrl];
        [Logger log:[NSString stringWithFormat:@"%@, %@", urlStr, size] andPrintTo:_logText];
    }];
}

- (void)onCaptureVideoBtnClick {
    [_picker videoFromCamera:^(NSURL *fileUrl) {
        NSString *urlStr = [fileUrl absoluteString];
        [_videoPathField setText:urlStr];

        NSString *size = [FileSize sizeOf:fileUrl];
        [Logger log:[NSString stringWithFormat:@"%@, %@", urlStr, size] andPrintTo:_logText];
    }];
}


- (void)onSendBtnClick {
    [self.view endEditing:YES];//收起键盘
    
    NSString *apiUrl = @"http://recognition.image.myqcloud.com/face/livedetectfour";
    NSString *sign = [QCLocalAuthorizationGenerator signWithAppId:APP_ID secretId:SECRET_ID secretKey:SECRET_KEY];
    NSString *validate_data = [_validateDataField text];
    NSString *videoFilePath = [_videoPathField text];
    NSString *imgFilePath = [_imgPathField text];
    NSString *seq = [_seqField text];
    NSString *compare_flag = [[imgFilePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0 ? @"true" : @"false";

    _currentTask = [QCHttpEngine postFormDataTo:apiUrl
                                      headers:@{@"Authorization": sign}
                                       params:@{@"appid": APP_ID,
                                               @"validate_data": validate_data,
                                               @"compare_flag": compare_flag,
                                               @"seq": seq}
                                        files:@{@"video": videoFilePath,
                                                @"card": imgFilePath}
                                   onProgress:^(float percent) {
                                       NSString *msg = [NSString stringWithFormat:@"progress: %.2f%%", percent];
                                       [Logger log:msg andPrintTo:_logText];
                                   }
                                 onCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                                     _currentTask = nil;
                                     if (error) {
                                         //错误处理
                                         [Logger to:_logText format:@"onCompletion: error = %@", error];
                                     } else {
                                         //结果转换成 NSString
                                         NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                         [Logger to:_logText format:@"%@", string];
                                         //结果转换成 NSDictionary
                                         NSError *e = nil;
                                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                                         if (!dic) {//转换 NSDictionary 失败
                                             [Logger to:_logText format:@"%@ 转换 NSDictionary 失败, error = %@", string, e];
                                         } else {
                                             NSInteger code = [dic[@"code"] integerValue];
                                             if (code != 0) {//返回码不是0
                                                 [Logger to:_logText format:@"错误码: %d, 错误信息: %@", code, dic[@"message"]];
                                             } else {//成功, 获取内容
                                                 NSInteger live_status = [dic[@"data"][@"live_status"] integerValue];
                                                 [Logger to:_logText format:@"活体核身: %@", live_status == 0 ? @"通过" : @"不通过"];
                                             }
                                         }
                                     }
                                 }];

}

- (void)onCancelBtnClick {
    [_currentTask cancel];
}

- (void)onBackBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
