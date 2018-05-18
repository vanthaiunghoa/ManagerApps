#import "WebViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WebViewJavascriptBridge.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic , strong) UIWebView *webview ;

@end

@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.fd_prefersNavigationBarHidden = YES;
//    self.fd_interactivePopDisabled = YES;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    UIPanGestureRecognizer *swip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [webView addGestureRecognizer:swip];
    self.webview = webView;
    
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

- (void)loadWebView:(UIWebView*)webView
{
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


