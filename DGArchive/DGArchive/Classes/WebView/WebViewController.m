#import "WebViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WebViewJavascriptBridge.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic , strong) WKWebView *wkwebView;

@end

@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.fd_prefersNavigationBarHidden = YES;
//    self.fd_interactivePopDisabled = YES;
    
//    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:webView];
//
//    UIPanGestureRecognizer *swip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
//    [webView addGestureRecognizer:swip];
//    self.wkwebview = webView;
//
//    [WebViewJavascriptBridge enableLogging];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
//    [_bridge setWebViewDelegate:self];
//
//    [self loadWebView:webView];
    [self initWKWebView];
}

- (void)goBack
{
//    [self.wkwebview goBack];
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

- (void)initWKWebView
{
    if(self.wkwebView == nil)
    {
        CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
        CGFloat tabBarH = self.tabBarController.tabBar.bounds.size.height;
        
        WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, statusBarH + navigationBarH, SCREEN_WIDTH, SCREEN_HEIGHT - statusBarH - navigationBarH - tabBarH)];
        webView.navigationDelegate = self;
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

- (void)loadWKWebView:(WKWebView *)webView
{
//    NSURL *url = [NSURL URLWithString:self.url];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    PLog(@"webViewDidStartLoad");
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    PLog(@"webViewDidFinishLoad");
//}

- (void)loadWebView:(UIWebView*)webView
{
//    NSDictionary *properties = [[NSMutableDictionary alloc] init];
//    [properties setValue:[share() getSessionKey] forKey:NSHTTPCookieValue];
//    [properties setValue:@"sessionKey" forKey:NSHTTPCookieName];
//    [properties setValue:[url host] forKey:NSHTTPCookieDomain];
//    [properties setValue:[url path] forKey:NSHTTPCookiePath];
//    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
//    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    [_webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15]];

    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];

//    NSString *urlStr = [NSString stringWithFormat:@"http://121.15.203.82:9210/DMS_Phone/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}", userModel.username, userModel.password];

    NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}",[[UrlManager sharedUrlManager] getBaseUrl], userModel.username, userModel.password];

    //url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL*url = [NSURL URLWithString:urlStr];
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest*request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - handler JSCall

- (void)jsCall
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"ClickiOS" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"data == %@", data);
        //        responseCallback(@{ @"status":@"1" });
    }];
}


@end


