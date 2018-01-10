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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)loadView
{
    _loginView = [[LoginView alloc]init];
    _loginView.delegate = self;
    self.view = _loginView;
    [_loginView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    
//    if(userModel.isAutoLogin)
//    {
//        [self didLoginWithUserName:userModel.username AndPassWord:userModel.password];
//    }
}

#pragma mark - LoginViewDelegate

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    self.username = username;
    self.password = password;
    [self login];
//    [self loginWebService];
    
//    [self.navigationController pushViewController:[NSClassFromString(@"WebViewController") new] animated:YES];
//    [UIApplication sharedApplication].keyWindow.rootViewController = [NSClassFromString(@"EIMTabBarController") new];
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
                           @"j_password":self.password
                           };
    NSString *url = @"http://www.e-yixi.com:8088/atake/j_spring_security_check";
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
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            [JPUSHService setAlias:self.username completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq)
             {
                 switch (iResCode) {
                     case 0:
                         PLog(@"设置别名成功");
                         break;
                     case 6003:
                         PLog(@"alias 字符串不合法  有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字");
                         [SVProgressHUD showInfoWithStatus:@"alias字符串不合法，有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字"];
                         break;
                     case 6004:
                         PLog(@"alias超长。最多 40个字节  中文 UTF-8 是 3 个字节");
                         [SVProgressHUD showInfoWithStatus:@"alias超长。最多40个字节，中文UTF-8是3个字节"];
                         break;
                     default:
                         PLog(@"设置别名失败");
                         break;
                 }
            } seq:[self getRandomNumber:0 to:RAND_MAX]];
            
            UIViewController *vc = [NSClassFromString(@"WebViewController") new];
            [self.navigationController pushViewController:vc animated:YES];
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
