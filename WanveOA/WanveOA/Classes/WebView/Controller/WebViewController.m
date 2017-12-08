#import "WebViewController.h"
#import "LoginController.h"
#import "AddressController.h"
#import "AddressController.h"
#import "CoverView.h"
#import "PopMenuView.h"
#import "UIColor+color.h"

@interface WebViewController ()<UIWebViewDelegate, PopMenuViewDelegate>
//@property (nonatomic , strong) DetailWebModel *detailModel;
@property (nonatomic , weak) UIWebView *webView;
@property (nonatomic , copy) NSString *url;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    topView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:UIColor.redColor];
    [self.view addSubview:btn];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.backgroundColor = [UIColor whiteColor];
   
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.webView loadRequest:request];

    
    UIButton *popBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 44, 60, 30)];
//    [popBtn setBackgroundImage:[UIImage imageNamed:@"popMenu"] forState:UIControlStateNormal];
    //    [btn sizeToFit];
    //    address.titleLabel.font = [UIFont systemFontOfSize:13];
    [popBtn setTitle:@"更多" forState:UIControlStateNormal];
    [popBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [popBtn setBackgroundColor:[UIColor colorWithHexString:@"#87CEEB"]];
    [popBtn addTarget:self action:@selector(popMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];
}

// 点击活动按钮就会调用
- (void)popMenu
{
    // 1.弹出蒙版
    [CoverView show];
    // bug:发现一个控件没有显示,1.有没有设置尺寸 2.看有没有控件挡住 3.有可能你都没有添加到某个控件
    
    // 2.弹出pop菜单
    PopMenuView *menu = [PopMenuView showInPoint:CGPointMake(SCREEN_WIDTH-50, 108)];
    menu.delegate = self;
    
}

#pragma mark - PopMenuViewDelegate
// 点击菜单中关闭按钮就会调用
- (void)popMenuDidHide:(PopMenuView *)popMenu tag:(NSInteger)tag
{
    //    [UIView animateWithDuration:0.25 animations:nil completion:^(BOOL finished) {
    //        // 动画完成的时候做事情
    //
    //    }];
    
    
    void (^completion)() = ^(){
        // 隐藏完成的时候,需要做事情
        
        // 移除蒙版
        [CoverView hide];
        if(0 == tag)
        {
            [self address];
        }
        else if(1 == tag)
        {
            [self back];
        }
        else
        {
            [self exitApplication];
        }
    };
    
    // 隐藏pop菜单到某个点
    [popMenu hideInPoint:CGPointMake(SCREEN_WIDTH - 60, 64) completion:completion];
    
    //    [popMenu hideInPoint:CGPointMake(44, 44) completion:block];
}

- (void)address
{
    AddressController *vc = [[AddressController alloc]init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    //    TableController *vc = [[firstViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back
{
    LoginController *vc = [[LoginController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

//- (void)exitApplication {
//    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [UIView animateWithDuration:1.0f animations:^{
//        window.alpha = 0;
//        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
//    } completion:^(BOOL finished) {
//        exit(0);
//    }];
//}

- (void)exitApplication
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
