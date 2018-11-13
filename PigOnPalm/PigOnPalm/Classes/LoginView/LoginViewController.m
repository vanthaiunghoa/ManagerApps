#import "LoginViewController.h"
#import "LoginView.h"
#import "UserModel.h"
#import "UserManager.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "JPushService.h"

@interface LoginViewController ()<LoginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *value;

@end

@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"ReloadData" object:nil];
}

- (void)refresh
{
    [_loginView reloadData];
}

- (void)loadView
{
    _loginView = [[LoginView alloc]init];
    _loginView.delegate = self;
    self.view = _loginView;
    
    [_loginView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];

    if(userModel.isAutoLogin)
    {
        userModel.isAutoLogin = NO;
        [self didLoginWithUserName:userModel.username AndPassWord:userModel.password];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *isOpenWebView = [defaults objectForKey:@"isOpenWebView"];
        if([isOpenWebView isEqualToString:@"YES"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"NO" forKey:@"isOpenWebView"];

            UIViewController *vc = [NSClassFromString(@"WebDetailViewController") new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - LoginViewDelegate

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    self.username = username;
    self.password = password;
    
//    self.username = @"15920231598";
//    self.password = @"123456";
    [self login];
//    [self loginWebService];
    
//    [self.navigationController pushViewController:[NSClassFromString(@"WebViewController") new] animated:YES];
//    [UIApplication sharedApplication].keyWindow.rootViewController = [NSClassFromString(@"EIMTabBarController") new];
}

- (void)didClickRegister
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"http://xin.xinkozi.com:8088/xds/app/register/index.do" forKey:@"url"];
//
//    // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
//    [defaults synchronize];
//
//    [self.navigationController pushViewController:[NSClassFromString(@"WebDetailViewController") new] animated:YES];
    
    [self.navigationController pushViewController:[NSClassFromString(@"RegisterViewController") new] animated:YES];
}

- (void)didClickForgotPassword
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"http://xin.xinkozi.com:8088/xds/app/register/findPwdPage.do" forKey:@"url"];
//
//    // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
//    [defaults synchronize];
    
    [self.navigationController pushViewController:[NSClassFromString(@"ResetViewController") new] animated:YES];
}

-(void)login
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
                           @"j_username":self.username,
                           @"j_password":self.password,
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
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = self.username;
            userModel.password = self.password;
            userModel.isAutoLogin = YES;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            [JPUSHService setAlias:self.username completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq)
             {
                 switch (iResCode) {
                     case 0:
                         PLog(@"设置别名成功");
//                         [SVProgressHUD showInfoWithStatus:@"设置别名成功"];
                         break;
                     case 6003:
                         PLog(@"alias 字符串不合法  有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字");
//                         [SVProgressHUD showInfoWithStatus:@"alias字符串不合法，有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字"];
                         break;
                     case 6004:
                         PLog(@"alias超长。最多 40个字节  中文 UTF-8 是 3 个字节");
//                         [SVProgressHUD showInfoWithStatus:@"alias超长。最多40个字节，中文UTF-8是3个字节"];
                         break;
                     default:
                         PLog(@"设置别名失败");
//                         [SVProgressHUD showInfoWithStatus:@"设置别名失败"];
                         break;
                 }
            } seq:[self getRandomNumber:0 to:RAND_MAX]];
            
//            UIViewController *vc = [NSClassFromString(@"WebViewController") new];
//            [self.navigationController pushViewController:vc animated:YES];
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[NSClassFromString(@"WebViewController") new]];

            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
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

// 获取随机数
- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
