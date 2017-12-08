//
//  LoginController.m
//  WanveOA
//
//  Created by wanve on 17/11/8.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "AFNetworking.h"
//#import "LoginModel.h"
#import "WebViewController.h"
#import "SVProgressHUD.h"
//#import "Masonry.h"

@interface LoginController ()<UITextFieldDelegate>

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadView
{
    LoginView *loginView = [[LoginView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    loginView.delegate = self;
    self.view = loginView;
}

-(void)post
{
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"UserID":@"cwq",
                           @"UserPsw":@"123456"
                           };
    [manager POST:@"http://121.15.203.82:9210/DMS_Phone/Login/LoginHandler.ashx?Action=Login&cmd=" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
      
        
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSDictionary *dictM = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//        PLog(@"%@",dictM);
//        [dictM writeToFile:@"/Users/xiaomage/Desktop/video.plist" atomically:YES];
//        
//        NSArray *arrayM = dictM[@"videos"];
        
        //字典转模型
        //        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:arrayM.count];
        //
        //        for (NSDictionary *dict in arrayM) {
        //            [arr addObject:[XMGVideo videoWithDict:dict]];
        //        }
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        id obj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        PLog(@"result = %@", obj[@"Result"]);
        PLog(@"Message = %@", obj[@"Message"]);
        
//        self.loginInfo = [LoginInfo objectWithKeyValues:obj];
        

        //字典数组
//        self.loginInfo = [LoginInfo mj_objectWithKeyValues:str];
//
//        PLog(@"----%@",self.videos);
 
//        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
        
    }];
}

-(void)get2
{
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"username":@"520it",
                           @"pwd":@"520it"
                           };
    [manager GET:@"http://120.25.226.186:32812/login" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}

-(void)post2
{
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"username":@"520it",
                           @"pwd":@"520it"
                           };
    [manager POST:@"http://120.25.226.186:32812/login" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}


#pragma mark - LoginViewDelegate

- (void)didClickLoginBtn:(NSString *)username withPwd:(NSString *)pwd
{
//    [self getWithUserName:username AndPassWord:pwd];
    [self post];
//    [self get2];
//    [self post2];
}

-(void)getWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    //    NSDictionary *dict = @{
    //                           @"UserID":@"cwq",
    //                           @"UserPsw":@"123456"
    //                           };
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@", @"http://121.15.203.82:9210/DMS_Phone/Login/LoginHandler.ashx?Action=Login&cmd={UserID:'", username, @"',UserPsw:'", password, @"'}"];
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [manager GET:urlStr parameters: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"请求成功--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *result = dict[@"Result"];
        NSNumber *num = [NSNumber numberWithInt:1];
        if([result isEqualToNumber:num])
        {
            [self save:NO withUserName:username AndPassword:password];
            [SVProgressHUD dismiss];
            
            WebViewController *vc = [[WebViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }
        else
        {
            NSString *mes = dict[@"Message"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (void)save:(BOOL)isAutoLogin withUserName:(NSString *)username AndPassword:(NSString *)password
{
    // 偏好设置存储 NSUserDefaults
    // 什么时候使用偏好设置存储
    // 偏好设置好处,1.快速进行键值对的存储 2.不关系文件名
    //  获取NSUserDefaults单例对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
    [defaults setObject:password forKey:@"password"];
    [defaults setBool:isAutoLogin forKey:@"isAutoLogin"];
}


@end
