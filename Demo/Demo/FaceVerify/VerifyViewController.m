//
//  VerifyViewController.m
//  FaceIdentify
//
//  Created by fantouch on 27/02/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "VerifyViewController.h"
#import "IdcardcompareController.h"
#import "LivegetfourController.h"
#import "LivedetectfourController.h"
#import "IdcardlivedetectfourController.h"

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"照片核身(通过照片和身份证信息)", @"获取唇语验证码, 用于活体核身", @"活体核身(通过视频和照片)", @"活体核身(通过视频和身份证信息)", @"返回"];
    
    CGFloat y = 120;
    for(int i = 0; i <arr.count; ++i)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 50)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor brownColor];
        btn.titleLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:btn];
        btn.tag = i;
        
        y += 100;
        
        [btn addTarget:self action:@selector(btnCall:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)btnCall:(UIButton *)button {
    UIViewController *controller;

    if (button.tag == 0) {
        controller = [[IdcardcompareController alloc] initWithNibName:@"Idcardcompare" bundle:nil];
    } else if (button.tag == 1) {
        controller = [[LivegetfourController alloc] initWithNibName:@"Livegetfour" bundle:nil];
    } else if (button.tag == 2) {
        controller = [[LivedetectfourController alloc] initWithNibName:@"Livedetectfour" bundle:nil];
    } else if (button.tag == 3) {
        controller = [[IdcardlivedetectfourController alloc] initWithNibName:@"Idcardlivedetectfour" bundle:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    if (controller) {
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
