#import "WebViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WebViewJavascriptBridge.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) WKWebView *wkwebView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    [self initWKWebView];
    [self initWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UIWebView

- (void)initWebView
{
    if(self.webView == nil)
    {
        UIWebView *webView = [[NSClassFromString(@"UIWebView") alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        webView.delegate = self;
        webView.scrollView.bounces = NO;
        [self.view addSubview:webView];
        self.webView = webView;
    }
    
    if(_bridge == nil)
    {
        [WebViewJavascriptBridge enableLogging];
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
        
        [self logout];
    }
    
    [self loadWebView:self.webView];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
}

- (void)loadWebView:(UIWebView*)webView
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.44:8080/archivesApp/#/index/home"]];
    [webView loadRequest:request];
}

#pragma mark - WKWebView

- (void)initWKWebView
{
    if(self.wkwebView == nil)
    {
        WKUserContentController *userContentController = WKUserContentController.new;
        NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = '%@';", [self getCookie]];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentController;
        

        CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, statusBarH, SCREEN_WIDTH, SCREEN_HEIGHT - statusBarH) configuration:config];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.scrollView.bounces = NO;
        
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
        
        [self logout];
    }
    
    [self loadWKWebView:self.wkwebView];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"wkwebViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"wkwebViewDidFinishLoad");
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

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadWKWebView:(WKWebView*)webView
{
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"FALSE" forKey:NSHTTPCookieSecure];
    [cookieProperties setObject:@"192.168.0.58" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"9998" forKey:NSHTTPCookiePort];
    [cookieProperties setObject:@"/archivesApp" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"http://192.168.0.44:8080/archivesApp/#/index/home" forKey:NSHTTPCookieOriginURL];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *arr =[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    for (NSHTTPCookie *cookie in [cookieJar cookies])
    {
        if([cookie.name isEqualToString:@"JSESSIONID"])
        {
            [cookieProperties setObject:cookie.name forKey:NSHTTPCookieName];
            [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
        }
    }
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.44:8080/archivesApp/#/index/home"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.allHTTPHeaderFields = cookieProperties;
    [request addValue:[self getCookie] forHTTPHeaderField:@"Cookie"];
    [webView loadRequest:request];
}

- (NSString *)getCookie
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *cookie = @"";
    for (NSHTTPCookie *c in [cookieJar cookies])
    {
        if([c.name isEqualToString:@"JSESSIONID"])
        {
            cookie = [NSString stringWithFormat:@"%@=%@", c.name, c.value];
        }
    }
    
    return cookie;
}

#pragma mark - handler JSCall

- (void)logout
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"userLogout" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.username = @"";
        userModel.password = @"";
        userModel.isLogout = YES;
        [[UserManager sharedUserManager] saveUserModel:userModel];

        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end


