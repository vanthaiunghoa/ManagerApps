//
//  RegisterViewController.m
//  PigOnPalm
//
//  Created by wanve on 2018/11/2.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "UserModel.h"
#import "UserManager.h"

@interface RegisterViewController ()<RegisterViewDelegate>

@property(nonatomic, strong) RegisterView *registerView;

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
    self.registerView = registerView;
}

#pragma mark - RegisterViewDelegate

- (void)didRegisterWithUserName:(NSString *)username code:(NSString *)code password:(NSString *)password
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"注册中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"phone":username,
                           @"vcode":code,
                           @"pwd":password
                           };
    NSString *url = @"http://handpig.com/pakTest/api/registerAccount.do";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *result = dict[@"status"];
        if([result isEqualToString:@"y"])
        {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = username;
            userModel.password = password;
            userModel.isAutoLogin = YES;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            [self login:username password:password];
        }
        else
        {
            NSString *mes = dict[@"info"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error.userInfo);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

-(void)login:(NSString *)username password:(NSString *)password
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"登录中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"j_username":username,
                           @"j_password":password,
                           @"vway":@"vp"
                           };
    NSString *url = @"http://handpig.com/pakTest/j_spring_security_check";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *result = dict[@"status"];
        if([result isEqualToString:@"y"])
        {
            [UIApplication sharedApplication].keyWindow.rootViewController = [NSClassFromString(@"WebViewController") new];
        }
        else
        {
            NSString *mes = dict[@"info"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error.userInfo);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didGetCode:(NSString *)num
{
    [self.registerView countDown];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"phone":num,
                           @"op":@"regt"
                           };
    NSString *url = @"http://handpig.com/pakTest/api/sendVcode.do";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        self.view.userInteractionEnabled = YES;
//        [SVProgressHUD dismiss];
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *result = dict[@"status"];
        if([result isEqualToString:@"y"])
        {
            
        }
        else
        {
            NSString *mes = dict[@"info"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error.userInfo);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

@end
