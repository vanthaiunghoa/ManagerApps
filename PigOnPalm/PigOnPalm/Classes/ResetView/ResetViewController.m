//
//  ResetViewController.m
//  PigOnPalm
//
//  Created by wanve on 2018/11/2.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "ResetViewController.h"
#import "ResetView.h"
#import "UserModel.h"
#import "UserManager.h"

@interface ResetViewController ()<ResetViewDelegate>

@property(nonatomic, strong) ResetView *resetView;

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadView
{
    ResetView *resetView = [[ResetView alloc]init];
    resetView.delegate = self;
    self.view = resetView;
    self.resetView = resetView;
}

#pragma mark - ResetViewDelegate

- (void)didRegisterWithUserName:(NSString *)username code:(NSString *)code password:(NSString *)password
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"密码修改中，请稍等..."];
    
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
    NSString *url = @"http://handpig.com/pak/api/findPwd.do";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *result = dict[@"status"];
        if([result isEqualToString:@"y"])
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = username;
            userModel.password = password;
            userModel.isAutoLogin = YES;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];

            [self.navigationController popViewControllerAnimated:YES];
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

- (void)didGetCode:(NSString *)num
{
    [self.resetView countDown];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"phone":num,
                           @"op":@"fpwd"
                           };
    NSString *url = @"http://handpig.com/pak/api/sendVcode.do";
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
