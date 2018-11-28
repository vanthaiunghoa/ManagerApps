#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"
#import <UINavigationController+FDFullscreenPopGesture.h>
#import "QRCodeViewController.h"
#import "HHBluetoothPrinterManager.h"
#import "BluetoothViewController.h"
#import "PrintModel.h"
#import <LeoPayManager/LeoPayManager.h>
#import "UserModel.h"
#import "UserManager.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "ShareView.h"
#import "OpenShareHeader.h"

@interface WebViewController()<UIGestureRecognizerDelegate, NSURLSessionDelegate>

@property WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIImageView *testView;
@property (nonatomic, strong) NSMutableArray *printDatas;
@property (nonatomic, strong) PrintModel *printModel;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *staffNo;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.fd_prefersNavigationBarHidden = NO;
    self.fd_interactivePopDisabled = YES;
    
    //设置状态栏颜色
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    statusBarView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:statusBarView];
//    _printDatas = [NSMutableArray array];
//    [NSTimer scheduledTimerWithTimeInterval:(float)0.02 target:self selector:@selector(sendDataTimer:) userInfo:nil repeats:YES];
//    [self addLeftButton];
    [self addRightButton];
}

- (void)addLeftButton
{
    if(self.webView.canGoBack)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"arrow_back_black"] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
//        [btn sizeToFit];
//        [btn addTarget:self action:@selector(logoutCall) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

- (void)addRightButton
{
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [btnShare sizeToFit];
    [btnShare addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
}

- (void)back
{
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}

- (void)logoutCall
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
//    userModel.username = @"";
//    userModel.password = @"";
    userModel.isAutoLogin = NO;
    userModel.isLogout = YES;
    [[UserManager sharedUserManager] saveUserModel:userModel];
    
    [self cleanCacheAndCookie];
    //            [self.navigationController popViewControllerAnimated:YES];
    LoginViewController *vc = [LoginViewController new];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

#pragma mark - share

- (void)share
{
    NSMutableArray *titarray = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"推荐下载", nil];
    NSMutableArray *picarray = [NSMutableArray arrayWithObjects:@"wechat",@"friend",@"download", nil];
    ShareView *shareView = [[ShareView alloc]initWithTitleArray:titarray picarray:picarray];
    
    @weakify(self);
    [shareView selectedWithIndex:^(NSInteger index,id shareType) {
        @strongify(self);
        switch (index) {
            case 0:
                [self wechatShare];
                break;
            case 1:
                [self friendShare];
                break;
            case 2:
                [self downloadShare];
                break;
                
            default:
                break;
        }
    }];
    
    [shareView CLBtnBlock:^(UIButton *btn) {
        PLog(@"你点了选择/取消按钮");
    }];
    
    [shareView show];
}

- (void)qqShare
{
    id data = @{ @"qq": @"qqShare" };
    [_bridge callHandler:@"qqShare" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)wechatShare
{
    id data = @{ @"wechat": @"wechatShare" };
    [_bridge callHandler:@"getAppShareInfo" data:data responseCallback:^(id response) {
        NSString *shareLink = response[@"shareLink"];
        NSString *shareImgUrl = response[@"shareImgUrl"];
        NSString *shareDesc = response[@"shareDesc"];
        NSString *shareTitle = response[@"shareTitle"];
        
        OSMessage *msg = [[OSMessage alloc]init];
        msg.title = shareTitle;
        msg.desc = shareDesc;
        msg.link = shareLink;
        msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]];

        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
            PLog(@"微信分享到会话成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            PLog(@"微信分享到会话失败：\n%@\n%@",error,message);
        }];
    }];
}

- (void)friendShare
{
    id data = @{ @"friend": @"friendShare" };
    [_bridge callHandler:@"getAppShareInfo" data:data responseCallback:^(id response) {
        NSString *shareLink = response[@"shareLink"];
        NSString *shareImgUrl = response[@"shareImgUrl"];
        NSString *shareDesc = response[@"shareDesc"];
        NSString *shareTitle = response[@"shareTitle"];
        
        OSMessage *msg = [[OSMessage alloc]init];
        msg.title = shareTitle;
        msg.desc = shareDesc;
        msg.link = shareLink;
        msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]];

        [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
            PLog(@"微信分享到朋友圈成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            PLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
        }];
    }];
}

- (void)downloadShare
{
    id data = @{ @"download": @"downloadShare" };
    [_bridge callHandler:@"getAppDownloadInfo" data:data responseCallback:^(id response) {
        NSString *shareLink = response[@"shareLink"];
        NSString *shareImgUrl = response[@"shareImgUrl"];
        NSString *shareDesc = response[@"shareDesc"];
        NSString *shareTitle = response[@"shareTitle"];
        
        OSMessage *msg = [[OSMessage alloc]init];
        msg.title = shareTitle;
        msg.desc = shareDesc;
        msg.link = shareLink;
        msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgUrl]];
        
        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
            PLog(@"微信分享到会话成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            PLog(@"微信分享到会话失败：\n%@\n%@",error,message);
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [self.navigationController setNavigationBarHidden:YES];
//    self.manager.delegate = self;
//    [self.manager cancelScan];
    
    if (_bridge) { return; }
    
    CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarH = self.navigationController.navigationBar.frame.size.height;

    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, statusBarH + navigationBarH, SCREEN_WIDTH, SCREEN_HEIGHT - navigationBarH - statusBarH)];
    _webView.scrollView.bounces = NO;
    
    [self.view addSubview:_webView];
    
    // 避免WebView最下方出现黑线
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    
    // 去掉webView的滚动条
    for (UIView *subView in [_webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            // 不显示竖直的滚动条
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:NO];
        }
    }

    
    UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressed.delegate = self;
    [_webView addGestureRecognizer:longPressed];

    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
//    [self openScan];
//    [self printFeeList];
//    [self printQrcode];
//    [self bindQrcodeOrder];
    
    [self logout];
    [self callPhone];
//    [self renderButtons:webView];
    [self goPay];
    [self loadWebView:_webView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isOpenWebView = [defaults objectForKey:@"isOpenWebView"];
    if([isOpenWebView isEqualToString:@"YES"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"NO" forKey:@"isOpenWebView"];
        
        UIViewController *vc = [NSClassFromString(@"WebDetailViewController") new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)renderButtons:(UIWebView*)webView
{
    self.testView = [UIImageView new];
    self.testView.backgroundColor = [UIColor redColor];
    [self.view insertSubview:self.testView aboveSubview:webView];
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(100);
        make.width.height.equalTo(@200);
    }];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie
{
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

#pragma mark - handler JSCall

- (void)goPay
{
    [_bridge registerHandler:@"goPay" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"goPay == %@", data);
        if(data)
        {
            NSString *userId = data[@"userId"];
            NSString *amount = data[@"amount"];
            NSString *type = data[@"payType"];
            
            [self aliPay:userId amount:amount type:type];
        }
    }];
}

- (void)callPhone
{
    [_bridge registerHandler:@"callPhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"callPhone == %@", data);
        if(data)
        {
            NSString *num = data[@"phone"];
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@", num];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
    }];
}

- (void)aliPay:(NSString *)userId amount:(NSString *)amount type:(NSString *)type
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"支付中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"userId":userId,
                           @"amount":amount,
                           @"payType":type
                           };
    NSString *url = @"http://handpig.com/pakTest/api/alipay/gateway.do";
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *res = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        PLog(@"请求成功--responseObject == %@", res);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *result = dict[@"status"];
        if([result isEqualToString:@"y"])
        {
            NSString *order = dict[@"data"];
            [self aliPay:order];
        }
        else
        {
            self.view.userInteractionEnabled = YES;
            [SVProgressHUD dismiss];

            NSString *mes = dict[@"info"];
            [SVProgressHUD showErrorWithStatus:mes];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error.userInfo);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (void)openScan
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"openScan" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"openScan == %@", data);
//        responseCallback(@{ @"status":@"1" });
        if(data)
        {
            QRCodeViewController *vc = [[QRCodeViewController alloc]init];
            vc.scanResultBlock = ^(QRCodeViewController *vc, NSString *resultStr)
            {
                PLog(@"scan result == %@", resultStr);
                [vc.navigationController popViewControllerAnimated:NO];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:resultStr forKey:@"url"];
                
                // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
                [defaults synchronize];
                UIViewController *detailVc = [NSClassFromString(@"WebDetailViewController") new];
                [self.navigationController pushViewController:detailVc animated:YES];

//                UIImage * printimage = [self createQRForString:resultStr];
//                self.testView.image = printimage;
                //            [self png2GrayscaleImage:printimage];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)bindQrcodeOrder
{
    [_bridge registerHandler:@"bindQrcodeOrder" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"openScan == %@", data);
        //        responseCallback(@{ @"status":@"1" });
        if(data)
        {
            PLog(@"data == %@", data);
            NSString *orderNo = data[@"orderNo"];
            
            QRCodeViewController *vc = [[QRCodeViewController alloc]init];
            vc.scanResultBlock = ^(QRCodeViewController *vc, NSString *resultStr)
            {
                PLog(@"scan result == %@", resultStr);
                [vc.navigationController popViewControllerAnimated:NO];
                NSString *url = [NSString stringWithFormat:@"%@&orderNo=%@", resultStr, orderNo];
                PLog(@"url == %@", url);
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:url forKey:@"url"];
                
                // 方法synchronise是为了强制存储，其实并非必要，因为这个方法会在系统中默认调用，但是你确认需要马上就存储，这样做是可行的
                [defaults synchronize];
                UIViewController *detailVc = [NSClassFromString(@"WebDetailViewController") new];
                [self.navigationController pushViewController:detailVc animated:YES];
                
                //                UIImage * printimage = [self createQRForString:resultStr];
                //                self.testView.image = printimage;
                //            [self png2GrayscaleImage:printimage];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)printFeeList
{
    [_bridge registerHandler:@"printFeeList" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"printFeeList == %@", data);
        if(data)
        {
            _printModel = [PrintModel mj_objectWithKeyValues:data];
            
            if([[HHBluetoothPrinterManager sharedManager] isConnectSuccess])
            {
//                self.view.userInteractionEnabled = NO;
//                [SVProgressHUD showWithStatus:@"打印中..."];
                [self printInit:FeeList];
//                [self print];
//                self.view.userInteractionEnabled = YES;
//                [SVProgressHUD showSuccessWithStatus:@"打印成功"];
            }
            else
            {
                BluetoothViewController *vc = [[BluetoothViewController alloc]init];
                vc.printerBlock = ^(BluetoothViewController *vc)
                {
                    [vc.navigationController popViewControllerAnimated:NO];
//                    self.view.userInteractionEnabled = NO;
                    [SVProgressHUD showInfoWithStatus:@"连接成功，开始打印"];
                    PLog(@"开始打印=====");
                    [self printInit:FeeList];
                    PLog(@"打印结束=====");
//                    self.view.userInteractionEnabled = YES;
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (void)printQrcode
{
    [_bridge registerHandler:@"printQrcode" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"printQrcode == %@", data);
        if(data)
        {
            self.orderNo = data[@"orderNo"];
            self.staffNo = data[@"staffNo"];
            if([[HHBluetoothPrinterManager sharedManager] isConnectSuccess])
            {
                _printModel = [PrintModel mj_objectWithKeyValues:data];
                [self printInit:QRCode];
            }
            else
            {
                BluetoothViewController *vc = [[BluetoothViewController alloc]init];
                vc.printerBlock = ^(BluetoothViewController *vc)
                {
                    [vc.navigationController popViewControllerAnimated:NO];
                    [SVProgressHUD showInfoWithStatus:@"连接成功，开始打印"];
//                    [self printQR];
                    [self printInit:QRCode];
                    [[HHBluetoothPrinterManager sharedManager] printTest:_printDatas];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

#pragma mark - pay

- (void)ApplePayFunc
{
    //先获取Apple Pay支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager applePayWithTraderInfo:nil viewController:self respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)wechatPayFunc
{
    //先获取微信支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager wechatPayWithAppId:@"" partnerId:@"" prepayId:@"" package:@"" nonceStr:@"" timeStamp:@"" sign:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)aliPay:(NSString *)order
{
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager aliPayOrder:order scheme:@"PigOnPalm" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        self.view.userInteractionEnabled = YES;

        switch (respCode) {
            case 0:
                PLog(@"支付成功");
                [SVProgressHUD showInfoWithStatus:@"支付成功"];
                break;
            case -1:
                PLog(@"支付失败");
                [SVProgressHUD showInfoWithStatus:@"支付失败"];
                break;
            case -2:
                PLog(@"支付取消");
                [SVProgressHUD showInfoWithStatus:@"支付取消"];
                break;
            case -99:
                PLog(@"未知错误");
                [SVProgressHUD showInfoWithStatus:@"未知错误"];
                break;
            default:
                [SVProgressHUD dismiss];
                break;
        }
    }];
}

- (void)unionPayFunc
{
    //先获取银联支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager unionPayWithSerialNo:@"" viewController:self respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)sendDataTimer:(NSTimer *)timer
{
    //发送打印数据
    //PLog(@"send data timer");
    
    if ([_printDatas count] > 0)
    {
        NSData* cmdData;
        
        cmdData = [_printDatas objectAtIndex:0];
        [[HHBluetoothPrinterManager sharedManager] startPrint:cmdData];
        
        [_printDatas removeObjectAtIndex:0];
        PLog(@"print length == %ld", _printDatas.count);
    }
}

- (void)logout
{
    //    __weak typeof(self) weakSelf = self;
    [_bridge registerHandler:@"logout" handler:^(id data, WVJBResponseCallback responseCallback) {
        PLog(@"logout == %@", data);
        if(data)
        {
            [self logoutCall];
        }
    }];
}

#pragma mark - creatQRImage

- (UIImage *)createQRForString:(NSString *)qrString {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data
              forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:0.1
                                   orientation:UIImageOrientationUp];
    
    // 不失真的放大
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:10.0];
    
    // 缩放到固定的宽度(高度与宽度一致)
    UIImage * endImage = [self scaleWithFixedWidth:400 image:resized];
    CGImageRelease(cgImage);
    return endImage;
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

- (UIImage *)scaleWithFixedWidth:(CGFloat)width image:(UIImage *)image
{
    float newHeight = image.size.height * (width / image.size.width);
    CGSize size = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

#pragma mark - print

- (void)printInit:(PrintType)type
{
    [self printerInit];
    [self jingb];
    [self jinga];
    if(type == FeeList)
        [self printFeeListFormat];
    else
        [self printQRCodeFormat];
    [self printerInit];
}

- (void)printFeeListFormat
{
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"交易编号：%@\n", _printModel.orderNo]];
    
    for(OrderClothessModel *orderClothess in _printModel.orderClothess)
    {
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"联系人：%@\n", orderClothess.recvName]];
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"收件地址：%@%@%@%@\n", orderClothess.recvCity, orderClothess.recvArea, orderClothess.recvSecArea, orderClothess.recvAddress]];
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"是否加急：%@\n", orderClothess.isUrgent?@"是":@"否"]];
        [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    }
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"名称           数量        金额\n"];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
//    FeesModel *f = [[FeesModel alloc]init];
//    f.clothesName = @"三个字";
//    f.quantity = @430;
//    f.amount = @300;
//    [_printModel.fees addObject:f];
//
//    FeesModel *f2 = [[FeesModel alloc]init];
//    f2.quantity = @43;
//    f2.amount = @300;
//    f2.clothesName = @"五个字个字";
//    [_printModel.fees addObject:f2];
    
    for(FeesModel *fee in _printModel.fees)
    {
        if(fee.clothesName.length == 2)
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@            %@           %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
        else if(fee.clothesName.length == 3)
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@         %@          %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
        else if(fee.clothesName.length == 4)
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@        %@           %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
        else
        {
            [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"%@      %@          %@\n", fee.clothesName, fee.quantity, fee.amount]];
        }
    }
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"合计                        %@\n", _printModel.totalAmount]];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"折扣                        %@\n", _printModel.offsetAmount]];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"应收                        %@\n", _printModel.payAmount]];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"--------------------------------\n"];
    
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"委托人签名：\n\n"];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"收件人签名：\n\n\n\n\n\n"];
}

- (void)printQRCodeFormat
{
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:@"广西兆泳\n"];
    [self printerWithFormat:Align_Left CharZoom:Char_Normal Content:[NSString stringWithFormat:@"收件员工号：%@\n\n\n", self.staffNo]];
//    UIImage * printimage = [self createQRForString:[NSString stringWithFormat:@"http://www.eyixi.com:8088/atake/app/order/goNextOrderStep.do?orderNo=%@\n\n", self.orderNo]];
    UIImage * printimage = [self createQRForString:@"https://www.baidu.com"];
//    [self appendImage:printimage maxWidth:250];
    [self png2GrayscaleImage:printimage];
//    [self appendQRCodeWithInfo:@"https://www.baidu.com"];
//    [self appendImage:[UIImage imageNamed:@"ico180"] maxWidth:300];
    [self printerWithFormat:Align_Center CharZoom:Char_Normal Content:self.orderNo];
}

- (UIImage *)png2GrayscaleImage:(UIImage *) oriImage
{
    //const int ALPHA = 0;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    int width = oriImage.size.width ;//imageRect.size.width;
    int height =oriImage.size.height;
    int imgSize = width * height;
    int x_origin = 0;
    int y_to = height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(imgSize * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, imgSize * sizeof(uint32_t));
    
    NSInteger nWidthByteSize = (width+7)/8;
    
    NSInteger nBinaryImgDataSize = nWidthByteSize * y_to;
    Byte *binaryImgData = (Byte *)malloc(nBinaryImgDataSize);
    
    memset(binaryImgData, 0, nBinaryImgDataSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width , height), [oriImage CGImage]);
    
    Byte controlData[8];
    controlData[0] = 0x1d;
    controlData[1] = 0x76;  //'v';
    controlData[2] = 0x30;
    controlData[3] = 0;
    controlData[4] = nWidthByteSize & 0xff;
    controlData[5] = (nWidthByteSize>>8) & 0xff;
    controlData[6] = y_to & 0xff;
    controlData[7] = (y_to>>8) & 0xff;
    NSData *printData = [[NSData alloc] initWithBytes:controlData length:8];
    [self printData:printData];
    
    for(int y = 0; y < y_to; y++)
    {
        for(int x = x_origin; x < width ; x++)
        {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            /*
             rgbaPixel[RED] = gray;
             rgbaPixel[GREEN] = gray;
             rgbaPixel[BLUE] = gray;
             */
            if (gray > 228)
            {
                rgbaPixel[RED] = 255;
                rgbaPixel[GREEN] = 255;
                rgbaPixel[BLUE] = 255;
                
            }
            else
            {
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
                binaryImgData[(y*width+x)/8] |= (0x80>>(x%8));
            }
        }
    }
    
    printData = [[NSData alloc] initWithBytes:binaryImgData length:nBinaryImgDataSize];
    [self printData:printData];
    
    memset(controlData, '\n', 8);
    printData = [[NSData alloc] initWithBytes:controlData length:3];
    [self printData:printData];
    
    return 0;
}

- (void)printData:(NSData *)dataPrinted
{
    PLog(@"print data:%lu", (unsigned long)[dataPrinted length]);
    //    aa++;
//#define MAX_CHARACTERISTIC_VALUE_SIZE 20
    NSData  *data    = nil;
    NSUInteger i;
    NSUInteger strLength;
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    PLog(@"print data:%@", dataPrinted);
    
    
    strLength = [dataPrinted length];
    PLog(@"strlength == %ld", strLength);
    cellCount = (strLength%MAX_CHARACTERISTIC_VALUE_SIZE)?(strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        PLog(@"print:%lu,%lu,%lu,%lu", (unsigned long)strLength,(unsigned long)cellCount, (unsigned long)cellMin, (unsigned long)cellLen);
        NSRange rang = NSMakeRange(cellMin, cellLen);
        
        data = [dataPrinted subdataWithRange:rang];
        PLog(@"print:%@", data);
        //        if (aa>3) {
        
        //        }else{
        [_printDatas addObject:data];
        //        }
        //        [manager startPrint:data];
    }
}

- (void)printerWithFormat:(Align_Type_e)eAlignType CharZoom:(Char_Zoom_Num_e)eCharZoomNum Content:(NSString *)printContent{
    NSData  *data    = nil;
    NSUInteger strLength;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    Byte caPrintFmt[500];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    //caPrintFmt[0] = 0x1b;
    //caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[0] = 0x1d;
    caPrintFmt[1] = 0x21;
    caPrintFmt[2] = (eCharZoomNum<<4) | eCharZoomNum;
    caPrintFmt[3] = 0x1b;
    caPrintFmt[4] = 0x61;
    caPrintFmt[5] = eAlignType;
    NSData *printData = [printContent dataUsingEncoding: enc];
    Byte *printByte = (Byte *)[printData bytes];
    
    strLength = [printData length];
    if (strLength < 1) {
        return;
    }
    
    for (int  i = 0; i<strLength; i++)
    {
        caPrintFmt[6+i] = *(printByte+i);
    }
    
    data = [NSData dataWithBytes:caPrintFmt length:6+strLength];
    
    [self printLongData:data];
}

- (void)printLongData:(NSData *)printContent
{
    NSUInteger i;
    NSUInteger strLength;
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    strLength = [printContent length];
    if (strLength < 1) {
        return;
    }
    
    cellCount = (strLength%MAX_CHARACTERISTIC_VALUE_SIZE)?(strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        PLog(@"print:%d,%d,%d,%d", strLength,cellCount, cellMin, cellLen);
        NSRange rang = NSMakeRange(cellMin, cellLen);
        NSData *subData = [printContent subdataWithRange:rang];
        
        PLog(@"print:%@", subData);
        [_printDatas addObject:subData];
    }
}

- (void)jinga
{
    unsigned char* cData = (unsigned char *)calloc(100, sizeof(unsigned char));
    NSData* sendData = nil;
    //选中中文指令集
    cData[0] = 0x1b;
    cData[1] = 0x74;
    cData[2] = 15;
    sendData = [NSData dataWithBytes:cData length:3];
    
    free(cData);
    [_printDatas addObject:sendData];
    
}
- (void)jingb
{
    unsigned char* cData = (unsigned char *)calloc(100, sizeof(unsigned char));
    NSData* sendData = nil;
    //选中中文指令集
    cData[0] = 0x1c;
    cData[1] = 0x26;
    sendData = [NSData dataWithBytes:cData length:2];
    free(cData);
    [_printDatas addObject:sendData];
}

- (void)printerInit
{
    NSData *printFormat;
    Byte caPrintFmt[20];
    
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    printFormat = [NSData dataWithBytes:caPrintFmt length:2];
    PLog(@"format:%@", printFormat);
    
    [_printDatas addObject:printFormat];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    PLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    PLog(@"webViewDidFinishLoad");
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    PLog(@"title == %@", self.title);
    
    [self addLeftButton];
}

- (void)loadWebView:(UIWebView*)webView
{
    NSURL* url = [NSURL URLWithString:@"http://handpig.com/pak/wx/mark/basePage.do"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
//    {
//        statusBar.backgroundColor = [UIColor whiteColor];
//    }
//
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - savePictrue

- (void)longPressed:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    if(longPressGestureRecognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
    CGPoint touchPoint = [longPressGestureRecognizer locationInView:_webView];
    NSString *srcStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src",touchPoint.x,touchPoint.y];
    NSString *saveUrl = [_webView stringByEvaluatingJavaScriptFromString:srcStr];
    if(srcStr.length == 0){
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存图片到相册" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self savePhotoToPhotosAlbumWithImgUrl:saveUrl];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)savePhotoToPhotosAlbumWithImgUrl:(NSString *)url {
    NSURL *ImgUrl = [NSURL URLWithString:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:ImgUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
  
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            return;
        }
        NSData *imgData = [NSData dataWithContentsOfURL:location];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:imgData];
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end


