#import "WebViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WebViewJavascriptBridge.h"
#import "UIColor+color.h"
#import "KxMenu.h"
#import "UnitModel.h"

@interface WebViewController()

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) UIBarButtonItem *homeBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *moreBarButtonItem;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor colorWithRGB:63 green:166 blue:207];
    
    [self initTopView];
//    [self initWebView];
    
    // 自动化办公
    [self initWKWebView];
//    [self updateToolbarItems];
    
    [self updateApp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
   
//    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.toolbarHidden = YES;
   
    [super viewWillDisappear:animated];
}

- (void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatusbarHeight)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithRGB:63 green:166 blue:207];
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
    
    [self jsCall];
    
    [self loadWebView:self.webView];
}

- (void)loadWebView:(UIWebView *)webView
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?UserID=%@&SysID=K7q/DW5GAsVjobMbiMkbI8hKOQn3kb7S1GTM2KaKiCY=&From=APP",[[UrlManager sharedUrlManager] getBaseUrl], userModel.username];
    //                url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
}

#pragma mark - handler JSCall

- (void)jsCall
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"callPhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        PLog(@"data == %@", data);
        if([data[@"type"] isEqualToString:@"logout"])
        {
            [self switchClicked:nil];
        }
        else if([data[@"type"] isEqualToString:@"quit"])
        {
            [self exitClicked:nil];
        }
        else if([data[@"type"] isEqualToString:@"phonebook"])
        {
            [self addressClicked:nil];
        }
    }];
}

- (void)addressClicked:(id)sender
{
    [self.navigationController pushViewController:[NSClassFromString(@"AddressViewController") new] animated:YES];
}

- (void)switchClicked:(id)sender
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.isLogout = YES;
    userModel.isAutoLogin = NO;
    userModel.isRememberUsername = NO;
    [[UserManager sharedUserManager] saveUserModel:userModel];
    
    //    [[VPNManager sharedVPNManager] stopVPN];
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - WKWebView

- (void)initWKWebView
{
    CGFloat h = SCREEN_HEIGHT - StatusbarHeight;
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, StatusbarHeight, SCREEN_WIDTH, h)];

    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.scrollView.bounces = NO;

    [self.view addSubview:webView];
    self.wkWebView = webView;
    
    if(@available(iOS 11.0, *))
    {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    
    [self jsCall];
    
    [self loadWKWebView:self.wkWebView];
}

- (void)loadWKWebView:(WKWebView *)webView
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    NSString *urlStr = [NSString stringWithFormat:@"%@/Login/QuickLogin.aspx?UserID=%@&SysID=K7q/DW5GAsVjobMbiMkbI8hKOQn3kb7S1GTM2KaKiCY=&From=APP",[[UrlManager sharedUrlManager] getBaseUrl], userModel.username];
    //                url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
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

#pragma mark - Toolbar

- (void)updateToolbarItems
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
    // 自动化
    {
        NSArray *items = [NSArray arrayWithObjects:
                          flexibleSpace,
                          self.moreBarButtonItem,
                          flexibleSpace,
                          self.homeBarButtonItem,
                          //                          self.actionBarButtonItem,
                          flexibleSpace,
                          nil];
        
        self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
        self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.toolbarItems = items;
    }
}

- (UIBarButtonItem *)homeBarButtonItem {
    if (!_homeBarButtonItem) {
        _homeBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(homeTapped:)];
    }
    return _homeBarButtonItem;
}

- (UIBarButtonItem *)moreBarButtonItem {
    if (!_moreBarButtonItem) {
        _moreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more.png"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(moreTapped:)];
    }
    return _moreBarButtonItem;
}

- (void)homeTapped:(UIBarButtonItem *)sender
{
    [self loadWKWebView:self.wkWebView];
}

- (void)moreTapped:(UIBarButtonItem *)sender {
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"切换账号"
                     image:nil
                    target:self
                    action:@selector(switchClicked:)],
      
      [KxMenuItem menuItem:@"退出应用"
                     image:nil
                    target:self
                    action:@selector(exitClicked:)],
      ];
    

    for(KxMenuItem *item in menuItems)
    {
        item.alignment = NSTextAlignmentCenter;
    }
    
    // 自动化
    CGFloat x = (SCREEN_WIDTH - 88)/3.0 + 5;
    
    CGFloat y;
    
    if(IS_IPHONEX)
    {
        y = SCREEN_HEIGHT - 85;
    }
    else
    {
        y = SCREEN_HEIGHT - 50;
    }
    
    CGRect frame = CGRectMake(x, y, 44, 44);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)updateApp
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"Action"] = @"search";
    param[@"keyword"] = @"交通投资";
    param[@"maxnum"] = @"10";
    NSString *url = @"http://wx.wanve.com/DMSPhoneAppService/AppConfigHandler.ashx";
    
    [manager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"请求成功--%@",responseObject);
        NSDictionary *dictArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in dictArray)
        {
            UnitModel *model = [UnitModel unitWithDict:dict];
            [arr addObject:model];
        }

        UnitModel *model = arr[0];
        [self getVersionNum:model.SNID];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}

- (void)getVersionNum:(NSString *)snid
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"Action"] = @"getappinfo";
    param[@"SNID"] = snid;
    NSString *url = @"http://wx.wanve.com/DMSPhoneAppService/AppConfigHandler.ashx";
    
    [manager GET:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"请求成功--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *newVersion = dict[@"AppVersionIOS"];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        if([self compareVersion:newVersion to:oldVersion] == 1)
        {
            [self showAlertView:dict[@"UpdateMemo"]];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}

- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++)
    {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

- (void)showAlertView:(NSString *)mes
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新"
                                                                             message:mes
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
        // 交投
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pgyer.com/JtZ6"]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}


@end


