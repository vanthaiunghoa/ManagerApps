#import "LoginViewController.h"
#import "LoginView.h"
#import "UserModel.h"
#import "UserManager.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "UrlManager.h"
#import "REFrostedViewController.h"
#import "FilterViewController.h"

@interface LoginViewController ()<LoginViewDelegate, NSXMLParserDelegate>

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isLogout)
    {
        [_loginView reloadData];
    }
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

#pragma mark - LoginViewDelegate

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password
{
    self.username = username;
    self.password = password;
//    [self login];
//    [self loginWebService];
    
    FilterViewController *menuController = [[FilterViewController alloc] init];
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:[NSClassFromString(@"TabBarController") new] menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionRight;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.limitMenuViewSize = true;
    frostedViewController.menuViewSize = CGSizeMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT);

    [UIApplication sharedApplication].keyWindow.rootViewController = frostedViewController;
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
    
//    NSString *sp_id = @"vJo06/qsLDOK5p2FvLqujo8G9eCsjrLJGcg8TGN0QZexSchZjBfneZ1vL4h3BN/EEId5hEBxZWM=";
    
    // 保安工务局
//    NSString *sp_id = @"tKB1F69J4TgRTM7QRN1+NxDaURCluPAAYFaWJfMEdhryuqvuoRIA7sF7CzKsSngLPPpy5gmaOu4=";
    // 勤智资本
    NSString *sp_id = @"ysmi8nF7R3L/64UB2oGK4d7kx3kgvJ4PF2Uwk7k3jLeN1U1O+clGj7Jm0EFZLzYPaJ512P+SE3I=";
    sp_id = [sp_id stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"USER":@"yzdw-gly",
                           @"PASSWORD":sp_id,
                           @"SP_ID":@"ToEIM_PIC"
                           };
    NSString *url = @"http://121.15.203.82:9210/WAN_MPDA_Pic/Handlers/SingleSignOnHandler.ashx?Action=SingleSignOnByXML";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        PLog(@"请求成功--responseObject == %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSNumber *result = dict[@"Result"];
        NSNumber *num = [NSNumber numberWithInt:1];
        if([result isEqualToNumber:num])
        {
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = self.username;
            userModel.password = self.password;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"返回";
            self.navigationItem.backBarButtonItem = backItem;

//            MJTableViewController *vc = [[MJTableViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NSString *mes = dict[@"Message"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error.userInfo);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (void)loginWebService
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"登录中，请稍等..."];
    
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<CheckUserLogin xmlns=\"http://tempuri.org/\">"
                         "<userID>%@</userID>"
                         "<userPSW>%@</userPSW>"
                         "</CheckUserLogin>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", self.username, self.password];
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
    [manager POST:[[UrlManager sharedUrlManager] getLoginUrl] parameters:soapMsg success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        PLog(@"result == %@", result);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLog(@"error == %@", error);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    PLog(@"element == %@", string);
//}

#pragma mark - NSXMLParserDelegate
// 1.开始解析XML文件
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    PLog(@"开始解析XML文件");
}

// 2.解析XML文件中所有的元素
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
//    PLog(@"解析XML文件中所有的元素:elementName:%@,attributeDict:%@",elementName,attributeDict);
//    if ([elementName isEqualToString:@"CheckUserLoginResult"]) {
//        // MJExtension 解析数据
//        Model *model = [Model mj_objectWithKeyValues:attributeDict];
//        [self.dataArrM addObject:model];
//    }
}

// 3.XML文件中每一个元素解析完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
//    PLog(@"XML文件中每一个元素解析完成:elementName:%@, qName:%@",elementName, qName);
    
    if ([elementName isEqualToString:@"CheckUserLoginResult"])
    {
        if([self.value isEqualToString:@"OK"] || [self.value isEqualToString:@"ok"])
        {
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.username = self.username;
            userModel.password = self.password;
            userModel.status = self.value;
            userModel.isLogout = NO;
            [[UserManager sharedUserManager] saveUserModel:userModel];
            [UIApplication sharedApplication].keyWindow.rootViewController = [NSClassFromString(@"TabBarController") new];
            
            // 勤智资本
            
//            [self.navigationController pushViewController:[NSClassFromString(@"MapViewController") new] animated:YES];
        }
        else if([self.value isEqualToString:@"fail"])
        {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
        }
        else if([self.value isEqualToString:@"isLock"])
        {
            [SVProgressHUD showErrorWithStatus:@"账号被锁"];
        }
        else if([self.value isEqualToString:@"noOpenUse"])
        {
            [SVProgressHUD showErrorWithStatus:@"账号被禁用"];
        }
        else if([self.value isEqualToString:@"noExists"])
        {
            [SVProgressHUD showErrorWithStatus:@"账号不存在"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"系统异常"];
        }
    }
}

// 读取标签之间的文本
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.value = string;
}


// 4.XML所有元素解析完毕
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    PLog(@"解析完毕");
}

// 解析出现错误时调用
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    PLog(@"error == %@", validationError.userInfo);
}

@end
