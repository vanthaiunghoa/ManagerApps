//
//  RegisterViewController.m
//  PigOnPalm
//
//  Created by wanve on 2018/11/2.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"

@interface RegisterViewController ()<RegisterViewDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户注册";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadView
{
    RegisterView *registerView = [[RegisterView alloc]init];
    registerView.delegate = self;
    self.view = registerView;
}

#pragma mark - RegisterViewDelegate

- (void)didRegisterWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    
}

- (void)didGetCode
{
    
}

@end
