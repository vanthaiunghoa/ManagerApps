#import "LoginViewController.h"
#import "LoginView.h"
#import "UserModel.h"
#import "UserManager.h"
//#import "WebViewController.h"
#import "MJTableViewController.h"
#import "VPNSettingViewController.h"
#import "VPNManager.h"
#import "HomePageViewController.h"
#import "iconv.h"

@interface LoginViewController ()<LoginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, assign) BOOL isStartVPN;
@property (nonatomic, assign) BOOL isLoadOnceData;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isStartVPN = NO;
    self.isLoadOnceData = YES;
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
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isLogout)
    {
        if(self.isLoadOnceData)
        {
            self.isLoadOnceData = NO;
            self.isStartVPN = NO;
            [_loginView reloadData];
        }
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVPNMessageNotification object:nil];
}

#pragma mark - LoginViewDelegate

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    self.view.userInteractionEnabled = NO;
    
    self.username = username;
    self.password = password;
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isVPNLogin)
    {
        [self loginVPN];
    }
    else
    {
        [self login];
//        [self loginWebService];
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
    
    if (message.code == VPN_CB_CONNECTED)
    {
        PLog(@"VPN登录成功");
        [SVProgressHUD showSuccessWithStatus:@"VPN登陆成功"];
        [self login];
    }
    else if (message.code == VPN_CB_DISCONNECTED)
    {
        PLog(@"VPN连接失败");
        [SVProgressHUD showInfoWithStatus:@"MotionProFgo disconnected"];
    }
    else if (message.code == VPN_CB_CONN_FAILED)
    {
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
    }
    else if (message.code == VPN_CB_DEVID_REG)
    {
//        [[[UIAlertView alloc] initWithTitle:@"WORING"
//                                    message:@"Your device has not been registered, please register it first"
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil, nil] show];
        [SVProgressHUD showInfoWithStatus:@"Your device has not been registered, please register it first"];
    }
    else if (message.code == VPN_CB_LOGIN)
    {
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
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // 2.发送请求
    NSString *str = [NSString stringWithFormat:@"{\"UserID\":\"%@\",\"PSW\":\"%@\"}", self.username, self.password];
    NSDictionary *dict = @{
                           @"Action":@"Login",
                           @"jsonRequest":str
                           };
    PLog(@"dict == %@", dict);

    NSString *url = @"http://202.104.110.143:8009/oasystem/Handlers/DMS_FileMan_Handler.ashx?";
    
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        // 转码
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* utf8Str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
        PLog(@"utf8Str == %@", utf8Str);
        NSData *data = [utf8Str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       
        NSNumber *isSuccess = dict[@"IsSuccess"];
        PLog(@"isSuccess == %@", isSuccess);
        NSNumber *num = [NSNumber numberWithInt:1];
        if([isSuccess isEqualToNumber:num])
        {
            self.isLoadOnceData = YES;
            
            NSString *activeCode = dict[@"ActiveCode"];
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = self.username;
            userModel.password = self.password;
            userModel.activeCode = activeCode;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];

            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"返回";
            self.navigationItem.backBarButtonItem = backItem;

//            MJTableViewController *vc = [[MJTableViewController alloc]init];
            HomePageViewController *vc = [[HomePageViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NSString *mes = dict[@"Status"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)loginWebService
{
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetSWBLInfo xmlns=\"DMS_Client_WebService\">"
                         "<UserID>%@</UserID>"
                         "</GetSWBLInfo>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", self.username];
    PLog(@"soapMsg == %@", soapMsg);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60;
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapMsg.length] forHTTPHeaderField:@"Content-Length"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error)
     {
         return soapMsg;
     }];
    [manager POST:@"http://202.104.110.143:8009/oasystem/WebServices/DMS_Client_WebService.ASMX" parameters:soapMsg success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        PLog(@"result == %@", result);
        //使用自己写的请求方法resultWithDiction进行解析
//        NSDictionary * dic = [self resultWithDiction:result];
//        //通过Block传回数据
//        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        PLog();
    }];

}


@end
