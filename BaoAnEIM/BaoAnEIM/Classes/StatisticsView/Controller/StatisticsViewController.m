#import "StatisticsViewController.h"
#import "WebViewJavascriptBridge.h"
#import "KxMenu.h"
#import "UIImage+image.h"
#import "NSString+extension.h"
#import "UrlManager.h"
#import "UserManager.h"
#import "UserModel.h"

@interface StatisticsViewController ()<NSXMLParserDelegate>

@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *openType;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation StatisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"深圳市宝安区建筑工务局";
    
    [self setupNavBtn];
    self.openType = @"tjbb_hztj";
    [self loginWebService];
}

- (void)loginWebService
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"验证中，请稍等..."];
    
//    NSString *sp_id = @"vJo06/qsLDOK5p2FvLqujo8G9eCsjrLJGcg8TGN0QZexSchZjBfneZ1vL4h3BN/EEId5hEBxZWM=";
    // 保安工务局
    NSString *sp_id = @"tKB1F69J4TgRTM7QRN1+NxDaURCluPAAYFaWJfMEdhryuqvuoRIA7sF7CzKsSngLPPpy5gmaOu4=";
    sp_id = [sp_id stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    sp_id = [NSString urlEncode:sp_id];
    PLog(@"sp_id == %@", sp_id);
    
    UserModel *model = [[UserManager sharedUserManager] getUserModel];
//    NSString *SP_ID = @"ToWanPic";
    NSString *SP_ID = @"ToEIM_PIC";
    
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\" ?>"
                         "<REQUEST>"
                         "<USER>%@</USER>"
                         "<PASSWORD>%@</PASSWORD>"
                         "<SP_ID>%@</SP_ID>"
                         "</REQUEST>", model.username, sp_id, SP_ID];
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

    [manager POST:[[UrlManager sharedUrlManager] getSingleUrl] parameters:soapMsg success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        PLog(@"result == %@", result);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLog(@"error == @%", error.userInfo);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
    
}

#pragma mark - nav item
- (void)setupNavBtn
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClicked:)];
}

#pragma mark - clicked

- (void)logoutClicked:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"切换账号"
                     image:nil
                    target:self
                    action:@selector(switchClicked:)],
      
      [KxMenuItem menuItem:@"退出"
                     image:nil
                    target:self
                    action:@selector(exitClicked:)],
      ];
    
    for(KxMenuItem *item in menuItems)
    {
        item.alignment = NSTextAlignmentCenter;
    }
    
    CGRect frame = CGRectMake(6, 20, 44, 44);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)switchClicked:(id)sender
{
    [[UserManager sharedUserManager] logout];
}

- (void)exitClicked:(id)sender
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0)
    {
        //退出
        exit(0);
    }
}

- (void)moreClicked:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"汇总统计"
                     image:nil
                    target:self
                    action:@selector(statisticsClicked:)],
      
      [KxMenuItem menuItem:@"项目状态"
                     image:nil
                    target:self
                    action:@selector(statusClicked:)],
      
      [KxMenuItem menuItem:@"项目科室"
                     image:nil
                    target:self
                    action:@selector(departmentClicked:)],
      
      [KxMenuItem menuItem:@"项目类别"
                     image:nil
                    target:self
                    action:@selector(categoryClicked:)],
      
      [KxMenuItem menuItem:@"项目投资"
                     image:nil
                    target:self
                    action:@selector(investmentClicked:)],
      
//      [KxMenuItem menuItem:@"品牌公开"
//                     image:nil
//                    target:self
//                    action:@selector(brandClicked:)],
      ];
    
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    for(KxMenuItem *item in menuItems)
    {
        item.alignment = NSTextAlignmentCenter;
    }
    
    CGRect frame = CGRectMake(SCREEN_WIDTH - 50, 20, 44, 44);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)statisticsClicked:(id)sender
{
    self.openType = @"tjbb_hztj";
    [self loginWebService];
}

- (void)statusClicked:(id)sender
{
    self.openType = @"tjbb_xmzt";
    [self loginWebService];
}

- (void)departmentClicked:(id)sender
{
    self.openType = @"tjbb_xmks";
    [self loginWebService];
}

- (void)categoryClicked:(id)sender
{
    self.openType = @"tjbb_xmlb";
    [self loginWebService];
}

- (void)investmentClicked:(id)sender
{
    self.openType = @"tjbb_xmtz";
    [self loginWebService];
}

- (void)brandClicked:(id)sender
{
    self.openType = @"tjbb_ppgk";
    [self loginWebService];
}

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
    
    if ([elementName isEqualToString:@"RESP_CODE"])
    {
        if([self.content isEqualToString:@"0000"])
        {
            NSString *tmpUrl = [[UrlManager sharedUrlManager] getWebUrl];
            tmpUrl = [tmpUrl stringByAppendingString:@"&SessionId="];
            tmpUrl = [tmpUrl stringByAppendingString:self.sessionId];
            tmpUrl = [tmpUrl stringByAppendingString:@"&OpenType="];
            self.url = [tmpUrl stringByAppendingString:self.openType];
            PLog(@"url == %@", self.url);
            
            if (_bridge)
            {
                [self loadWebView:self.webView];
            }
            else
            {
                [self initWebView];
            }
        }
        else if([self.content isEqualToString:@"1001"])
        {
            [SVProgressHUD showErrorWithStatus:@"非法交易类型"];
        }
        else if([self.content isEqualToString:@"1002"])
        {
            [SVProgressHUD showErrorWithStatus:@"非法接入账号"];
        }
        else if([self.content isEqualToString:@"1003"])
        {
            [SVProgressHUD showErrorWithStatus:@"接入密码错误"];
        }
        else if([self.content isEqualToString:@"1004"])
        {
            [SVProgressHUD showErrorWithStatus:@"登录用户无效"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"系统内部错误"];
        }
    }
    
    if([elementName isEqualToString:@"WEBSESSION"])
    {
        self.sessionId = self.content;
    }
}

// 读取标签之间的文本
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.content = string;
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

- (void)initWebView
{
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (_bridge) { return; }
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    //    [self renderButtons:webView];
    [self loadWebView:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(0, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(90, 400, 100, 35);
    reloadButton.titleLabel.font = font;
    
    UIButton* safetyTimeoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [safetyTimeoutButton setTitle:@"Disable safety timeout" forState:UIControlStateNormal];
    [safetyTimeoutButton addTarget:self action:@selector(disableSafetyTimeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:safetyTimeoutButton aboveSubview:webView];
    safetyTimeoutButton.frame = CGRectMake(190, 400, 120, 35);
    safetyTimeoutButton.titleLabel.font = font;
}

- (void)disableSafetyTimeout {
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadWebView:(UIWebView*)webView
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
}

@end
