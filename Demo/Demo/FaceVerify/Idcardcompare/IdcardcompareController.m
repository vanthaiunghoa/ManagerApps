//
//  idcardcompareController.m
//  FaceIdentify
//
//  Created by fantouch on 14/03/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//
//  照片核身（通过本地照片文件和身份证信息）
//  照片核身（通过网络图片和身份证信息）

#import <Foundation/Foundation.h>
#import "IdcardcompareController.h"
#import "Logger.h"
#import "FileSize.h"
#import "UserInfo.h"
#import <FaceVerifyIdPaaSLib/QCMediaPicker.h>
#import <FaceVerifyIdPaaSLib/QCLocalAuthorizationGenerator.h>
#import <FaceVerifyIdPaaSLib/QCHttpEngine.h>

@implementation IdcardcompareController {
    __weak IBOutlet UITextField *_nameField;
    __weak IBOutlet UITextField *_idNumberField;
    __weak IBOutlet UIButton *_chooseImgBtn;
    __weak IBOutlet UIButton *_captureImgBtn;
    __weak IBOutlet UITextField *_urlField;
    __weak IBOutlet UITextField *_seqField;
    __weak IBOutlet UIButton *_sendBtn;
    __weak IBOutlet UIButton *_cancelBtn;
    __weak IBOutlet UITextView *_logText;
    __weak IBOutlet UIBarButtonItem *_backBtn;

    QCMediaPicker *_picker;
    NSURLSessionDataTask *_currentTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_backBtn setTarget:self];
    [_backBtn setAction:@selector(onBackBtnClick)];
    [_chooseImgBtn addTarget:self action:@selector(onChooseImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_captureImgBtn addTarget:self action:@selector(onCaptureImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn addTarget:self action:@selector(onSendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _picker = [[QCMediaPicker alloc] initWithController:self];
}

- (void)onSendBtnClick {
    [self.view endEditing:YES];//收起键盘

    NSString *apiUrl = @"http://recognition.image.myqcloud.com/face/idcardcompare";
    NSString *sign = [QCLocalAuthorizationGenerator signWithAppId:APP_ID secretId:SECRET_ID secretKey:SECRET_KEY];
    NSString *idNumber = [_idNumberField text];
    NSString *name = [_nameField text];
    NSString *imgUrl = [_urlField text];
    NSString *seq = [_seqField text];

    if ([imgUrl hasPrefix:@"file"]) {
        // 照片核身（通过本地照片文件和身份证信息）
        // 参考文档 https://cloud.tencent.com/document/product/641/12433
        _currentTask = [QCHttpEngine postFormDataTo:apiUrl
                                            headers:@{@"Authorization": sign}
                                             params:@{@"appid": APP_ID,
                                                     @"idcard_number": idNumber,
                                                     @"idcard_name": name,
                                                     @"seq": seq}
                                              files:@{@"image": imgUrl}
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
                                                       CGFloat similarity = [dic[@"data"][@"similarity"] floatValue];
                                                       [Logger to:_logText format:@"相似度: %f", similarity];
                                                   }
                                               }
                                           }
                                       }];

    } else if ([imgUrl hasPrefix:@"http"]) {
        // 照片核身（通过网络图片和身份证信息）
        // 参考文档 https://cloud.tencent.com/document/product/641/12433
        _currentTask = [QCHttpEngine postJsonTo:apiUrl
                                        headers:@{@"Authorization": sign}
                                         params:@{@"appid": APP_ID,
                                                 @"idcard_number": idNumber,
                                                 @"idcard_name": name,
                                                 @"url": imgUrl,
                                                 @"seq": seq}
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
                                                   CGFloat similarity = [dic[@"data"][@"similarity"] floatValue];
                                                   [Logger to:_logText format:@"相似度: %f", similarity];
                                               }
                                           }
                                       }
                                   }];
    }
}

- (void)onChooseImgBtnClick {
    [_picker imageFromLibrary:^(NSURL *fileUrl) {
        NSString *urlStr = [fileUrl absoluteString];
        [_urlField setText:urlStr];

        NSString *size = [FileSize sizeOf:fileUrl];
        [Logger log:[NSString stringWithFormat:@"%@, %@", urlStr, size] andPrintTo:_logText];
    }];
}

- (void)onCaptureImgBtnClick {
    [_picker imageFromCamera:^(NSURL *fileUrl) {
        NSString *urlStr = [fileUrl absoluteString];
        [_urlField setText:urlStr];

        NSString *size = [FileSize sizeOf:fileUrl];
        [Logger log:[NSString stringWithFormat:@"%@, %@", urlStr, size] andPrintTo:_logText];
    }];
}

- (void)onCancelBtnClick {
    [_currentTask cancel];
}

- (void)onBackBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
