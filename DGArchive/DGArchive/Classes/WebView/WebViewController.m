#import "WebViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WebViewJavascriptBridge.h"
#import "UIColor+color.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initTopView];
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

- (void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatusbarHeight)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithRGB:69 green:124 blue:228];
}

#pragma mark - UIWebView

- (void)initWebView
{
    CGFloat h = SCREEN_HEIGHT - StatusbarHeight;
    UIWebView *webView = [[NSClassFromString(@"UIWebView") alloc] initWithFrame:CGRectMake(0, StatusbarHeight, SCREEN_WIDTH, h)];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    [self logout];
    [self printLog];
    
    [self loadWebView:self.webView];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
}

- (void)loadWebView:(UIWebView *)webView
{
    NSURLRequest *request = nil;
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isRegister)
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://daj.dg.gov.cn/archApp/#/register"]];
//        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.47:8080/archApp/#/register"]];
    }
    else
    {
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://daj.dg.gov.cn/archApp/#/index/home"]];
    }
    [webView loadRequest:request];
}

#pragma mark - handler JSCall

- (void)logout
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"userLogout" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        PLog(@"data == %@", data);
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isLogout = YES;
        if(data == nil)
        {
            userModel.username = @"";
            userModel.password = @"";
        }
        else
        {
            userModel.username = data[@"username"];
            userModel.password = data[@"password"];
        }
        [[UserManager sharedUserManager] saveUserModel:userModel];

        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)printLog
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"print" handler:^(id data, WVJBResponseCallback responseCallback) {
        
//        PLog(@"data == %@", data);
    }];
}



@end


