//
// Created by fantouch on 15/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//
//  获取唇语验证码，用于活体核身

#import "LivegetfourController.h"
#import "Logger.h"
#import "UserInfo.h"
#import <FaceVerifyIdPaaSLib/QCLocalAuthorizationGenerator.h>
#import <FaceVerifyIdPaaSLib/QCHttpEngine.h>

@implementation LivegetfourController {
    __weak IBOutlet UIBarButtonItem *_backBtn;
    __weak IBOutlet UITextField *_seqField;
    __weak IBOutlet UIButton *_sendJsonBtn;
    __weak IBOutlet UIButton *_cancelBtn;
    __weak IBOutlet UITextView *_logText;
    __weak IBOutlet UIButton *_sendFormDataBtn;

    NSURLSessionDataTask *_currentTask;

    NSString *_sign;
    NSString *_url;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_sendJsonBtn addTarget:self action:@selector(onSendJsonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendFormDataBtn addTarget:self action:@selector(onSendFormDataBtn) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setTarget:self];
    [_backBtn setAction:@selector(onBackBtnClick)];

    _url = @"http://recognition.image.myqcloud.com/face/livegetfour";
    _sign = [QCLocalAuthorizationGenerator signWithAppId:APP_ID secretId:SECRET_ID secretKey:SECRET_KEY];
}

- (void)onSendJsonBtnClick {
    //获取唇语验证码，用于活体核身
    // application/json 类型请求
    //参考文档 https://cloud.tencent.com/document/product/641/12431
    _currentTask = [QCHttpEngine postJsonTo:_url
                                    headers:@{@"Authorization": _sign}
                                     params:@{@"appid": APP_ID,
                                             @"seq": [_seqField text]}
                                 onProgress:^(float percent) {
                                     [Logger to:_logText format:@"progress: %.2f%%", percent];
                                 }
                               onCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                                   _currentTask = nil;
                                   if (error) {
                                       [Logger to:_logText format:@"%@", error];
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
                                               [Logger to:_logText format:@"错误码%d, 错误信息%@", code, dic[@"message"]];
                                           } else {//成功, 获取内容
                                               NSString *validate_data = dic[@"data"][@"validate_data"];
                                               [Logger to:_logText format:@"唇语验证码: %@", validate_data];
                                           }
                                       }
                                   }
                               }];
}

- (void)onSendFormDataBtn {
    //获取唇语验证码，用于活体核身
    // multipart/form-data 类型请求
    //参考文档 https://cloud.tencent.com/document/product/641/12431
    _currentTask = [QCHttpEngine postFormDataTo:_url
                                        headers:@{@"Authorization": _sign}
                                         params:@{@"appid": APP_ID,
                                                 @"seq": [_seqField text]}
                                          files:nil
                                     onProgress:^(float percent) {
                                         NSString *msg = [NSString stringWithFormat:@"progress: %.2f%%", percent];
                                         [Logger log:msg andPrintTo:_logText];
                                     }
                                   onCompletion:^(NSData *data, NSURLResponse *response, NSError *error) {
                                       _currentTask = nil;
                                       if (error) {
                                           [Logger to:_logText format:@"%@", error];
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
                                                   [Logger to:_logText format:@"错误码%d, 错误信息%@", code, dic[@"message"]];
                                               } else {//成功, 获取内容
                                                   NSString *validate_data = dic[@"data"][@"validate_data"];
                                                   [Logger to:_logText format:@"唇语验证码: %@", validate_data];
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
