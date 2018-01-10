#import "WebDetailViewController.h"
#import "WebViewJavascriptBridge.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface WebDetailViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.fd_prefersNavigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWebView) name:LoadWebViewAgain object:nil];
    
    if (_bridge) { return; }
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [self loadWebView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoadWebViewAgain object:nil];
//    [self cleanCacheAndCookie];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
}

- (void)loadWebView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlStr = [defaults objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

@end


