#import "LoginViewController.h"
#import "LoginView.h"
#import "UserModel.h"
#import "UserManager.h"
//#import "WebViewController.h"
#import "MJTableViewController.h"
#import "VPNSettingViewController.h"
#import "VPNManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UrlManager.h"
//#import "AXWebViewController.h"
//#import "RxWebViewController.h"
#import "SVWebViewController.h"
#import <SKPSMTPMessage.h>
#import <NSData+Base64Additions.h>

@interface LoginViewController ()<LoginViewDelegate, SKPSMTPMessageDelegate>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, assign) BOOL isStartVPN;
@property (nonatomic, assign) BOOL isYetVPNLoginSuccess;
@property (nonatomic, assign) BOOL isLoadOnceData;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;
    self.isStartVPN = NO;
    self.isLoadOnceData = YES;
    self.isYetVPNLoginSuccess = NO;
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
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isLogout)
    {
        if(self.isLoadOnceData)
        {
            self.isLoadOnceData = NO;
//            self.isStartVPN = NO;
//            self.isYetVPNLoginSuccess = NO;
            [_loginView reloadData];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kVPNMessageNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    
    if(userModel.isAutoLogin)
    {
        [self didLoginWithUserName:userModel.username AndPassWord:userModel.password];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVPNMessageNotification object:nil];
}

#pragma mark - LoginViewDelegate

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    self.view.userInteractionEnabled = NO;
    
    self.username = username;
    self.password = password;
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isVPNLogin && !_isYetVPNLoginSuccess)
    {
        [self loginVPN];
    }
    else
    {
//        [self login];
        // vpn登录使用
        [self loginOrigin];
    }
}

- (void)loginVPN
{
//    NSString *host = [NSString string];
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"Setting.plist" ofType:nil];
//
//    if (path)
//    {
//        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
//        if ([dict.allKeys containsObject:@"vpnHost"])
//        {
//            host = dict[@"vpnHost"];
//        }
//        else
//        {
//            host = @"mobile.dg.cn";
//        }
//    }
    
    //  mobile.dg.cn  13728179021  612691
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    NSString *host = @"mobile.dg.cn";
    VPNAccount *accout = [[VPNAccount alloc] initWithHost:host userName:userModel.vpnAccount passWord:userModel.vpnPassword];

    [[VPNManager sharedVPNManager] setLogLevel:0];
//  accout.certificatePath = [[NSBundle mainBundle] pathForResource:@"client2" ofType:@"p12"];
    
    if(self.isStartVPN)
    {
        [[VPNManager sharedVPNManager] loginWithAccount:accout];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"VPN登录中..."];
        [[VPNManager sharedVPNManager] startVPN:accout];
        self.isStartVPN = YES;
    }
}

/**
 vpn 事件处理
 
 @param n 通知
 */
- (void)handleMessage:(NSNotification *)n
{
    [self handleVPNMessage:n.object];
}

- (void)handleVPNMessage:(VPNMessage *)message
{
    VPNManager *manager = [VPNManager sharedVPNManager];
    int error = manager.errorCode;
    PLog(@"<handleVPNMessage> %@, errorcode: %d",message,[VPNManager sharedVPNManager].errorCode);
    
    NSString *mes = nil;
    
    if (message.code == VPN_CB_CONNECTED)
    {
        PLog(@"VPN登录成功");
        [SVProgressHUD showSuccessWithStatus:@"VPN登陆成功"];
        self.isYetVPNLoginSuccess = YES;
//        [self login];
        // vpn登录使用
//        [self loginOrigin];
        mes = @"vpn登陆成功";
    }
    else if (message.code == VPN_CB_DISCONNECTED)
    {
        self.view.userInteractionEnabled = YES;
        PLog(@"VPN连接失败");
        [SVProgressHUD showInfoWithStatus:@"MotionProFgo disconnected"];
        mes = @"MotionProFgo disconnected";
    }
    else if (message.code == VPN_CB_CONN_FAILED)
    {
        self.view.userInteractionEnabled = YES;
        NSString *aMessage;
        switch (error)
        {
            case ERR_DEVID_APPROVE_PENDING:
                aMessage = NSLocalizedString(@"Your device is registering, please request manager approval",nil);
                break;
            case ERR_DEVID_APPROVE_DENY:
                aMessage = NSLocalizedString(@"Register device deny, not allow register device auto approve",nil);
                break;
            case ERR_DEVID_USER_LIMIT:
                aMessage = NSLocalizedString(@"User for this device has reached his or her limit",nil);
                break;
            case ERR_DEVID_DEV_LIMIT:
                aMessage = NSLocalizedString(@"Device has reached its limit",nil);
                break;
            case ERR_WRONG_USER_PASS:
                aMessage = NSLocalizedString(@"Login failed, please check username and password",nil);
                break;
            case ERR_CALLBACK_FAILED:
                break;
            case ERR_CERT_NO:
                aMessage = NSLocalizedString(@"Please select a certificate", nil);
                break;
            case ERR_CERT_INVALID_SIGNTURE:
                aMessage = NSLocalizedString(@"The certificate of client has an invalid signature", nil);
                break;
            case ERR_CERT_UNTRUSTED:
                aMessage = NSLocalizedString(@"The certificate of client is untrusted", nil);
                break;
            case ERR_CERT_EXPIRED:
                aMessage = NSLocalizedString(@"The certificate of client is expired", nil);
                break;
            case ERR_CERT_INVALID:
                aMessage = NSLocalizedString(@"The certificate of client is invalid", nil);
                break;
            case ERR_CERT_REVOKED:
                aMessage = NSLocalizedString(@"The certificate of client is revoked", nil);
                break;
            default:
                aMessage = NSLocalizedString(@"Connection to server failed",nil);
                break;
        }
        
        aMessage  = [NSString stringWithFormat:@"VPN %@",aMessage];
        PLog(@"%@", aMessage);
        [SVProgressHUD showInfoWithStatus:aMessage];
        mes = aMessage;
    }
    else if (message.code == VPN_CB_DEVID_REG)
    {
        self.view.userInteractionEnabled = YES;
//        [[[UIAlertView alloc] initWithTitle:@"WORING"
//                                    message:@"Your device has not been registered, please register it first"
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil, nil] show];
        [SVProgressHUD showInfoWithStatus:@"Your device has not been registered, please register it first"];
        mes = @"Your device has not been registered, please register it first";
    }
    else if (message.code == VPN_CB_LOGIN)
    {
        self.view.userInteractionEnabled = YES;
//        if (error == ERR_WRONG_USER_PASS)
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:NSLocalizedString(@"Login failed, please check vpn username and password",nil)
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"OK",nil)
//                                                  otherButtonTitles:nil, nil];
//            [alert show];
//        }
        //when the login account wrong and try count less max count, or register succeful and redirct to login again or the register wrong.
        [SVProgressHUD showInfoWithStatus:@"Login failed, please check vpn username and password"];
        mes = @"Login failed, please check vpn username and password";
    }
    else
    {
        self.view.userInteractionEnabled = YES;
        mes = @"未知错误";
    }
    
    if(mes)
    {
        [self sendEmail:mes];
    }
}

- (void)sendEmail:(NSString *)mes
{
    //设置基本参数：
    SKPSMTPMessage *mail = [[SKPSMTPMessage alloc] init];
    [mail setSubject:@"vpn错误信息"]; // 设置邮件主题
    [mail setToEmail:@"2575551606@qq.com"]; // 目标邮箱
    [mail setFromEmail:@"541062603@qq.com"]; // 发送者邮箱
    [mail setRelayHost:@"smtp.qq.com"]; // 发送邮件代理服务器
    [mail setRequiresAuth:YES];
    [mail setLogin:@"541062603@qq.com"]; // 发送者邮箱账号
    [mail setPass:@"-wbm563-"]; // 发送者邮箱密码
    [mail setWantsSecure:YES]; // 需要加密
    [mail setDelegate:self];
    //设置邮件正文内容：
//    NSString *content = [NSString stringWithCString:"测试内容" encoding:NSUTF8StringEncoding];
    NSDictionary *plainPart = @{kSKPSMTPPartContentTypeKey : @"text/plain; charset=UTF-8", kSKPSMTPPartMessageKey : mes, kSKPSMTPPartContentTransferEncodingKey : @"8bit"};
    //添加附件（以下代码可在SKPSMTPMessage库的DMEO里找到）：
//    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"EmptyPDF" ofType:@"pdf"];
//    NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
//    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"EmptyPDF.pdf\"",kSKPSMTPPartContentTypeKey, @"attachment;\r\n\tfilename=\"EmptyPDF.pdf\"",kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    //执行发送邮件代码
    [mail setParts:@[plainPart]]; // 邮件首部字段、邮件内容格式和传输编码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [mail send];
    });
}

- (void)didClickVPNSettingBtn
{
    VPNSettingViewController *vc = [VPNSettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)login
{
    [SVProgressHUD showWithStatus:@"登录中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    //2.发送请求
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"Action"] = @"Login";
    param[@"cmd"] = [NSString stringWithFormat:@"{UserID:\'%@\',UserPsw:\'%@\'}",self.username, self.password];
//    param[@"appName"] = @"iOS";
    NSString *url = [NSString stringWithFormat:@"%@/Login/LoginHandler.ashx", [[UrlManager sharedUrlManager] getBaseUrl]];

    [manager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求成功--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSNumber *result = dict[@"Result"];
        NSNumber *num = [NSNumber numberWithInt:1];
        if([result isEqualToNumber:num])
        {
            self.isLoadOnceData = YES;
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = self.username;
            userModel.password = self.password;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            [SVProgressHUD dismiss];

//            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//            backItem.title = @"返回";
//            self.navigationItem.backBarButtonItem = backItem;

//            MJTableViewController *vc = [[MJTableViewController alloc]init];
            UIViewController *vc = [NSClassFromString(@"WebViewController") new];
//            UIViewController *vc = [NSClassFromString(@"AddressViewController") new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NSString *mes = dict[@"Message"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (void)loginOrigin
{
    [SVProgressHUD showWithStatus:@"登录中，请稍等..."];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/Login/LoginHandler.ashx?Action=Login&cmd={UserID:\'%@\',UserPsw:\'%@\'}", [[UrlManager sharedUrlManager] getBaseUrl], self.username, self.password];
    NSString *newUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(connectionError)
        {
            self.view.userInteractionEnabled = YES;
            PLog(@"请求失败--%@", connectionError);
            [SVProgressHUD showInfoWithStatus:@"网络异常"];
        }
        else
        {
            self.view.userInteractionEnabled = YES;
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber *result = dict[@"Result"];
            PLog(@"loginResult == %@", dict);
            NSNumber *num = [NSNumber numberWithInt:1];
            if([result isEqualToNumber:num])
            {
                self.isLoadOnceData = YES;
                UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
                userModel.username = self.username;
                userModel.password = self.password;
                userModel.isLogout = NO;
                [[UserManager sharedUserManager] saveUserModel:userModel];
                [SVProgressHUD dismiss];

                //    MJTableViewController *vc = [[MJTableViewController alloc]init];
//                UIViewController *vc = [NSClassFromString(@"WebViewController") new];
                //            UIViewController *vc = [NSClassFromString(@"AddressViewController") new];
//                [self.navigationController pushViewController:[NSClassFromString(@"WebViewController") new] animated:YES];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\",From:\"%@\"}",[[UrlManager sharedUrlManager] getBaseUrl], self.username, self.password, @"APP"];

                //url 编码
                urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:urlStr];
//                webVC.showsToolBar = NO;
//                webVC.navigationController.navigationBar.translucent = NO;
//                self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.100f green:0.100f blue:0.100f alpha:0.800f];
//                self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.996f green:0.867f blue:0.522f alpha:1.00f];
//                [self.navigationController pushViewController:webVC animated:YES];
                
//                RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
                SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
                [self.navigationController pushViewController:webViewController animated:YES];
            }
            else
            {
                NSString *mes = dict[@"Message"];
                [SVProgressHUD showInfoWithStatus:mes];
            }
        }
    }];
}

#pragma mark - SKPSMTPMessageDelegate

-(void)messageSent:(SKPSMTPMessage *)message{
    [SVProgressHUD showInfoWithStatus:@"发送email成功"];
    PLog(@"%@", message);
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:@"发送email失败"];
    PLog(@"message - %@\nerror - %@", message, error);
}


@end
