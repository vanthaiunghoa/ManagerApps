//
//  ResetViewController.m
//  PigOnPalm
//
//  Created by wanve on 2018/11/2.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "ResetViewController.h"
#import "ResetView.h"

@interface ResetViewController ()<ResetViewDelegate>

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadView
{
    ResetView *resetView = [[ResetView alloc]init];
    resetView.delegate = self;
    self.view = resetView;
}

#pragma mark - ResetViewDelegate

- (void)didRegisterWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    
}

- (void)didGetCode
{
    
}


@end
