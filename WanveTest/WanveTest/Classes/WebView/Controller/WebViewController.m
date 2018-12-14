#import "WebViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WebViewJavascriptBridge.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic , strong) UIWebView *webview ;
@property (nonatomic , strong) WKWebView *wkwebView ;

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
//    self.webview = webView;
    
    CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarH = self.tabBarController.tabBar.bounds.size.height;
    
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, statusBarH + navigationBarH, SCREEN_WIDTH, SCREEN_HEIGHT - statusBarH - navigationBarH - tabBarH)];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.scrollView.bounces = NO;
    
    if(@available(iOS 11.0, *))
    {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:webView];
    self.wkwebView = webView;

    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [self loadWebView:webView];
}

- (void)goBack
{
    [self.webview goBack];
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
}

- (void)loadWebView:(WKWebView*)webView
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];

//    NSString *urlStr = [NSString stringWithFormat:@"http://121.15.203.82:9210/DMS_Phone/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}", userModel.username, userModel.password];

    NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?UserID=%@&SysID=K7q/DW5GAsVjobMbiMkbI8hKOQn3kb7S1GTM2KaKiCY=&From=APP",[[UrlManager sharedUrlManager] getBaseUrl], userModel.username];
    
//    NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}",[[UrlManager sharedUrlManager] getBaseUrl], userModel.username, userModel.password];

    //url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL*url = [NSURL URLWithString:urlStr];
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


@end


