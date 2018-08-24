#import "CenterViewController.h"
#import "WebViewJavascriptBridge.h"
#import "KxMenu.h"
#import "UIImage+image.h"
#import "NSString+extension.h"
#import "UrlManager.h"
#import "UserManager.h"
#import "UserModel.h"

@interface CenterViewController ()<NSXMLParserDelegate>

@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *openType;
@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation CenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = TITLE;
    [self setTitle];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setupNavBtn];
    self.openType = @"zszx_bzgf";
    [self loginWebService];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification) name:@"LoadCenterViewAgain" object:nil];
}

- (void)setTitle
{
    NSString *title = TITLE;
    UILabel *labTitle = [UILabel new];
    [labTitle setText:title];
    [labTitle setFont:[UIFont systemFontOfSize:16]];
    self.navigationItem.titleView = labTitle;
}

- (void)handleNotification
{
    self.openType = @"zszx_bzgf";
    [self loginWebService];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoadCenterViewAgain" object:nil];
}

- (void)loginWebService
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"验证中，请稍等..."];
    
    NSString *password = [[UrlManager sharedUrlManager] getPassword];
    password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    password = [NSString urlEncode:password];
    PLog(@"password == %@", password);
    
    UserModel *model = [[UserManager sharedUserManager] getUserModel];
    
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\" ?>"
                         "<REQUEST>"
                         "<USER>%@</USER>"
                         "<PASSWORD>%@</PASSWORD>"
                         "<SP_ID>%@</SP_ID>"
                         "</REQUEST>", model.username, password, [[UrlManager sharedUrlManager] getSPID]];
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
    
    CGRect frame = CGRectMake(6, TOP_HEIGHT - 44, 44, 44);
    
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
//      路桥去掉
//      [KxMenuItem menuItem:@"内部资料"
//                     image:nil
//                    target:self
//                    action:@selector(infoClicked:)],
      
      [KxMenuItem menuItem:@"图书期刊"
                     image:nil
                    target:self
                    action:@selector(booksClicked:)],
      
      [KxMenuItem menuItem:@"常用表格"
                     image:nil
                    target:self
                    action:@selector(formClicked:)],
      // 单位规章（除路桥外）
      [KxMenuItem menuItem:@"企业规章"
                     image:nil
                    target:self
                    action:@selector(rulesClicked:)],
      
      [KxMenuItem menuItem:@"标准规范"
                     image:nil
                    target:self
                    action:@selector(standardClicked:)],
      ];
    
    //    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    for(KxMenuItem *item in menuItems)
    {
        item.alignment = NSTextAlignmentCenter;
    }
    
    CGRect frame = CGRectMake(SCREEN_WIDTH - 50, TOP_HEIGHT - 44, 44, 44);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)infoClicked:(id)sender
{
    self.openType = @"zszx_nbzl";
    [self loginWebService];
}

- (void)booksClicked:(id)sender
{
    self.openType = @"zszx_tsqk";
    [self loginWebService];
}

- (void)formClicked:(id)sender
{
    self.openType = @"zszx_cybg";
    [self loginWebService];
}

- (void)rulesClicked:(id)sender
{
    self.openType = @"zszx_dwgz";
    [self loginWebService];
}

- (void)standardClicked:(id)sender
{
    self.openType = @"zszx_bzgf";
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
                [self loadWKWebView:self.wkwebView];
            }
            else
            {
                [self initWKWebView];
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

- (void)initWKWebView
{
    if(self.wkwebView == nil)
    {
        CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
        CGFloat tabBarH = self.tabBarController.tabBar.bounds.size.height;
        
        WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, statusBarH + navigationBarH, SCREEN_WIDTH, SCREEN_HEIGHT - statusBarH - navigationBarH - tabBarH)];
        webView.navigationDelegate = self;
        
        if(@available(iOS 11.0, *))
        {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        [self.view addSubview:webView];
        self.wkwebView = webView;
    }
    
    if(_bridge == nil)
    {
        [WebViewJavascriptBridge enableLogging];
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkwebView];
        [_bridge setWebViewDelegate:self];
        
        [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSLog(@"testObjcCallback called: %@", data);
            responseCallback(@"Response from testObjcCallback");
        }];
        
        [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    }
    
    [self loadWKWebView:self.wkwebView];
}

#pragma mark - wkwebView delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

// 处理拨打电话以及Url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)loadWKWebView:(WKWebView *)webView
{
    NSURL *url = [NSURL URLWithString:self.url];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
