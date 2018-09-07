//
//  QRCodeViewController.h
//  Coding_iOS
//
//  Created by Ease on 15/7/2.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController : UIViewController
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (assign, nonatomic, readonly) BOOL isScaning;

- (void)startScan;
- (void)stopScan;

@property (copy, nonatomic) void(^scanResultBlock)(QRCodeViewController *vc, NSString *resultStr);

@end
