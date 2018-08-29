#import "LoginViewController.h"
#import "LoginView.h"
#import "UserModel.h"
#import "UserManager.h"
//#import "WebViewController.h"
#import "VPNSettingViewController.h"
#import "VPNManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UrlManager.h"
//#import "AXWebViewController.h"
//#import "RxWebViewController.h"
#import "SVWebViewController.h"
#import "NetworkManager.h"

@interface LoginViewController ()<LoginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, assign) BOOL isStartVPN;
@property (nonatomic, assign) BOOL isYetVPNLoginSuccess;
@property (nonatomic, assign) BOOL isLoadOnceData;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, assign) BOOL isSend;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;
    self.isStartVPN = NO;
    self.isLoadOnceData = YES;
    self.isYetVPNLoginSuccess = NO;
    
    _isSend = NO;
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
        [self login];
        // vpn登录使用
//        [self loginOrigin];
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
    PLog(@"<handleVPNMessage> %@, errorcode: %ld",message,message.code);
    
    if (message.code == VPN_CB_CONNECTED)
    {
        PLog(@"VPN登录成功");
        [SVProgressHUD showSuccessWithStatus:@"VPN登陆成功"];
        self.isYetVPNLoginSuccess = YES;
//        [self login];
        // vpn登录使用
        [self loginOrigin];
    }
    else if (message.code == VPN_CB_DISCONNECTED)
    {
        self.view.userInteractionEnabled = YES;
        PLog(@"VPN连接失败");
//        [SVProgressHUD showInfoWithStatus:@"MotionProFgo disconnected"];
        [SVProgressHUD showInfoWithStatus:@"MotionProFgo失去连接"];
    }
    else if (message.code == VPN_CB_CONN_FAILED)
    {
        self.view.userInteractionEnabled = YES;
        NSString *aMessage;
        switch (error)
        {
            case ERR_DEVID_APPROVE_PENDING:
//                aMessage = NSLocalizedString(@"Your device is registering, please request manager approval",nil);
                aMessage = @"您的设备正在注册，请请求管理员批准";
                break;
            case ERR_DEVID_APPROVE_DENY:
//                aMessage = NSLocalizedString(@"Register device deny, not allow register device auto approve",nil);
                aMessage = @"注册设备拒绝，不允许注册设备自动批准";
                break;
            case ERR_DEVID_USER_LIMIT:
//                aMessage = NSLocalizedString(@"User for this device has reached his or her limit",nil);
                aMessage = @"此设备的用户已达到他或她的极限";
                break;
            case ERR_DEVID_DEV_LIMIT:
//                aMessage = NSLocalizedString(@"Device has reached its limit",nil);
                aMessage = @"设备已达到极限";
                break;
            case ERR_WRONG_USER_PASS:
//                aMessage = NSLocalizedString(@"Login failed, please check username and password",nil);
                aMessage = @"登录失败，请检查用户名和密码";
                break;
            case ERR_CALLBACK_FAILED:
                aMessage = @"回调失败";
                break;
            case ERR_CERT_NO:
//                aMessage = NSLocalizedString(@"Please select a certificate", nil);
                aMessage = @"请选择证书";
                break;
            case ERR_CERT_INVALID_SIGNTURE:
//                aMessage = NSLocalizedString(@"The certificate of client has an invalid signature", nil);
                break;
            case ERR_CERT_UNTRUSTED:
//                aMessage = NSLocalizedString(@"The certificate of client is untrusted", nil);
                aMessage = @"客户证书具有无效签名";
                break;
            case ERR_CERT_EXPIRED:
//                aMessage = NSLocalizedString(@"The certificate of client is expired", nil);
                aMessage = @"客户证书到期";
                break;
            case ERR_CERT_INVALID:
//                aMessage = NSLocalizedString(@"The certificate of client is invalid", nil);
                aMessage = @"客户证书无效";
                break;
            case ERR_CERT_REVOKED:
//                aMessage = NSLocalizedString(@"The certificate of client is revoked", nil);
                aMessage = @"客户证书被吊销";
                break;
            default:
//                aMessage = NSLocalizedString(@"Connection to server failed",nil);
                aMessage = @"连接到服务器失败";
                break;
        }
        
        aMessage  = [NSString stringWithFormat:@"VPN：%@",aMessage];
        PLog(@"%@", aMessage);
        [SVProgressHUD showInfoWithStatus:aMessage];
    }
    else if (message.code == VPN_CB_DEVID_REG)
    {
        self.view.userInteractionEnabled = YES;
//        [[[UIAlertView alloc] initWithTitle:@"WORING"
//                                    message:@"Your device has not been registered, please register it first"
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil, nil] show];
        [SVProgressHUD showInfoWithStatus:@"VPN：您的设备尚未注册，请先注册"];
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
        [SVProgressHUD showInfoWithStatus:@"VPN：登录失败，请检查用户名和密码"];
    }
    else
    {
        self.view.userInteractionEnabled = YES;
        NSString *mes = [NSString stringWithFormat:@"VPN：未知错误，错误码：%ld", message.code];
//        [SVProgressHUD showInfoWithStatus:mes];
    }
}

- (void)didClickVPNSettingBtn
{
    VPNSettingViewController *vc = [VPNSettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)login
{
    [SVProgressHUD showWithStatus:@"登录中，请稍等..."];
    self.view.userInteractionEnabled = NO;
    
    NSDictionary *param = @{
                            @"username":self.username,
                            @"password":self.password
                            };
    
    [[NetworkManager shared] requestWithURL:@"j_spring_security_check"parameters:param callback:^(BOOL success, id data, NSError *error) {
        self.view.userInteractionEnabled = YES;
        if(success)
        {
            NSString *status = data[@"status"];
            if([status isEqualToString:@"y"])
            {
                [SVProgressHUD dismiss];
                
                UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
                userModel.username = self.username;
                userModel.password = self.password;
                userModel.isLogout = NO;
                [[UserManager sharedUserManager] saveUserModel:userModel];
                
                [self.navigationController pushViewController:[NSClassFromString(@"WebViewController") new] animated:YES];
            }
            else
            {
                NSString *info = data[@"info"];
                [SVProgressHUD showErrorWithStatus:info];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
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
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\",From:\"%@\"}",[[UrlManager sharedUrlManager] getBaseUrl], self.username, self.password, @"APP"];
//                url 编码
                urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
//                NSString *urlStr = @"http://19.104.11.135/?n=1&furl=http://sljoa.dg/wan_data/abc.docx";

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


@end
