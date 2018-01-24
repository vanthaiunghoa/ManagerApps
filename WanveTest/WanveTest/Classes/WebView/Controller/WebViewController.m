#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UserManager.h"
#import "UserModel.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface WebViewController()

@property (nonatomic , strong ) UIWebView *webview ;

@end

@implementation WebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self loadWebView];
}

- (void)loadWebView
{
    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    NSString  *urlStr = @"http://172.21.102.222:8000/dgjxj_touch/Login/Index.aspx";
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://121.15.203.82:9210/DMS_Phone/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}", userModel.username, userModel.password];
    
    //url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL*url = [NSURL URLWithString:urlStr];
    NSURLRequest*request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
    [self.view addSubview:_webview];
    
    //注册上下文.
    [self regiseterResponser];
}

#pragma mark - 第二种方式JSEport协议方式
- (void)regiseterResponser
{
    JSContext *context = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context setObject:self forKeyedSubscript:@"iOSJsCore"];
    
//  网页js这样写    iOSJsCore.ClickiOS(message);
//     [context setObject:self forKeyedSubscript:@"EyeUtil"];
}

//点击了iOS,出现菜单
- (void)ClickiOS:(NSString*)parma
{
    NSLog(@"js调用了OC方法");
//    NSDictionary*dict =  [NSJSONSerialization JSONObjectWithData:parma.mj_JSONData options:NSJSONReadingMutableLeaves error:nil];
//
//    if (dict != nil && [dict.allKeys containsObject:@"type"]) {
///        if ([dict[@"type"]  isEqualToString:@"phonebook"]) {//通讯录
////        }else if ([dict[@"type"]  isEqualToString:@"logout"]){//注销
////        }else if ([dict[@"type"]  isEqualToString:@"quit"]){//退出
//
//        }else{//显示菜单
//        }
//    }
}

@end


