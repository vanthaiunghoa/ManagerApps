//
//  WebVC.m
//  Template
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "WebVC.h"

#import "AddressBookVC.h"

#import "AddressNewBookVC.h"

#import "AppDelegate.h"

#import <WebKit/WebKit.h>

#define kUrl @"http://121.15.203.82:9210/DMS_Phone/"

@interface WebVC ()<UITextFieldDelegate,UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic , strong ) UITextField * urlTextField ;

@property (nonatomic , strong ) WKWebView * webView;

@property (nonatomic , strong ) UIWebView * webView2;

@property (nonatomic , strong ) UIView* downView;

@end

@implementation WebVC{
    
    UIView*_bigView;
    
    UIButton*_btn1;
    UIButton*_btn2;
    UIButton*_btn3;
    
    UIView*_line1;
    UIView*_line2;
    UIView*_line3;
    
    
    
}

- (void)setData:(NSData *)data{
    
    _data = data;
    

    
    
}

- (void)setUrlStr:(NSString *)urlStr{
    
    _urlStr = urlStr;
    
    

}
#pragma mark - getter
- (WKWebView *)webView{
    if(_webView == nil){
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        
        config.userContentController = [WKUserContentController new];
        
        [config.userContentController addScriptMessageHandler:self name:@"ClickiOS"];
       
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-kTotalTopHeight) configuration:config];
        
        _webView.scrollView.bounces = NO;
        
        _webView.navigationDelegate = self;
        
        _webView.UIDelegate= self;
        
        
        
    }
    return _webView;
}


- (UIView*)downView{
    if (_downView==nil){
        
        _downView=[[UIView   alloc] init];
        _downView.backgroundColor = [UIColor whiteColor];
        
//        _downView.layer.borderColor = [UIColor colorWithHex:0xa1000000 alpha:0.63].CGColor ;
//        _downView.layer.borderWidth = kfont(1);
        _downView.layer.cornerRadius = kfont(5);
        _downView.clipsToBounds=YES;
        _downView.backgroundColor = [UIColor colorWithHex:0xa1000000 alpha:0.8];
        
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn1 setTitle:@"通讯录" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor colorWithHex:0xfdfdfd ] forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:kfont(17)];
        [_btn1 addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
        
        _line1 = [UIView new];
        _line1.backgroundColor = [UIColor colorWithHex:0xDDDDDD alpha:0.63] ;
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn2 setTitle:@"注销" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor colorWithHex:0xfdfdfd] forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:kfont(17)];
        [_btn2 addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchUpInside];
        
        _line2 = [UIView new];
        _line2.backgroundColor = [UIColor colorWithHex:0xDDDDDD alpha:0.63];
        
        
        _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn3 setTitle:@"退出" forState:UIControlStateNormal];
        [_btn3 setTitleColor:[UIColor colorWithHex:0xfdfdfd] forState:UIControlStateNormal];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:kfont(17)];
        [_btn3 addTarget:self action:@selector(btnAction3:) forControlEvents:UIControlEventTouchUpInside];
        
        _line3 = [UIView new];
        _line3.backgroundColor = [UIColor colorWithHex:0xDDDDDD alpha:0.63];
        
        
        [_downView addSubview:_btn1];
        [_downView addSubview:_btn2];
        [_downView addSubview:_btn3];
        [_downView addSubview:_line1];
        [_downView addSubview:_line2];
        [_downView addSubview:_line3];
        
        
    }
    
    return _downView;
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // self.navigationController.navigationBar.hidden=NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationItem.title = @"智慧政务管理平台";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithFileName:@"菜单 (1)"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageWithFileName:@"菜单 (1)"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    
    [btn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightItem;

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //self.navigationController.navigationBar.hidden=YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    [self creatUI];
    
    [self layout];
    
    [self getData];
    
    
    
    
    
    
}

- (void)configNav{}
- (void)creatUI{
    
    
    _urlTextField = [UITextField new];
    _urlTextField.placeholder = @"输入网址";
    _urlTextField.textColor = [UIColor colorWithHex:0xeeeeee];
    _urlTextField.font = [UIFont systemFontOfSize:kfont(16)];
    _urlTextField.delegate=self;
    
    _urlTextField.hidden = YES;
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    
    
    //
//    [[NSUserDefaults standardUserDefaults]setValue:_userNameTextfield.text forKey:@"userNameStr"];
//    [[NSUserDefaults standardUserDefaults]setValue:_pwdTextfield.text forKey:@"pwdStr"];
    
    NSString*userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userNameStr"];
    NSString*pwdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwdStr"];
    
    NSString*urlStr = [NSString stringWithFormat:@"http://121.15.203.82:9210/DMS_Phone/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}",userName,pwdStr];
    
//    NSString*urlStr = @"http://www.jianshu.com/";
    
    
    //url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL*url = [NSURL URLWithString:urlStr];


    NSURLRequest*request = [NSURLRequest requestWithURL:url];
    
    
// WKWebViewConfiguration*   configuration = [[WKWebViewConfiguration alloc]init];
    
    
//    configuration.isProxy
    
    
//   request.isProxy
    
//    /\(i[^;]+;( U;)? CPU.+Mac OS X/
//    \(i[^;]+;( U;)? CPU.+Mac OS X
    

    [_webView loadRequest:request];

    [_webView evaluateJavaScript:@"!!(navigator.userAgent).match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)" completionHandler:^(id result, NSError *error) {

        NSLog(@"userAgent :%@", result);

//        Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Mobile/14G60

    }];
    

  
    
    [self.view addSubview:_urlTextField];
    
    [self.view addSubview:_webView];
    
    
    
    _bigView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    
    
    [_bigView addSubview:self.downView];
    
    
    [self.view addSubview:_bigView];
    
    _bigView.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0];
    
    _bigView.hidden = YES;
    
    _downView.hidden = YES;
    
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBackView:)];
    
    _bigView.userInteractionEnabled = YES;
    
    [_bigView addGestureRecognizer:tap];
    

}

- (void)layout{
    
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@(kTotalTopHeight));
        make.right.equalTo(@(kpt(-12)));
        make.width.equalTo(@(kpt(100)));
        make.height.equalTo(@(kph(150)));
        
        
    }];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_downView.mas_centerX);
        
        make.top.equalTo(@(kpt(15)));
        
        make.left.right.equalTo(@0);
        
    }];
    
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(5)));
        make.right.equalTo(@(kpt(-5)));
        make.height.equalTo(@(kph(1)));
        make.top.equalTo(_btn1.mas_bottom).with.offset(kph(6));
        
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_downView.mas_centerX);
        
        make.top.equalTo(_line1.mas_bottom).with.offset(kph(6));
        
        
        make.left.right.equalTo(@0);
        
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(5)));
        make.right.equalTo(@(kpt(-5)));
        make.height.equalTo(@(kph(1)));
        make.top.equalTo(_btn2.mas_bottom).with.offset(kph(6));
        
        
    }];
    
    [_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_downView.mas_centerX);
        
        make.top.equalTo(_line2.mas_bottom).with.offset(kph(6));
        
        
        make.left.right.equalTo(@0);
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [_urlTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.right.equalTo(@0);
        make.top.equalTo(@(kph(0)));
        make.height.equalTo(@(kph(30)));
        
        
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(@0);
        
//        make.top.equalTo(_urlTextField.mas_bottom);
        
        make.top.equalTo(@(kStatusHeight));
        
        
        
    }];
    
    [_btn1 setEnlargeEdgeWithTop:15 right:0 bottom:5 left:0];
    [_btn2 setEnlargeEdgeWithTop:5 right:0 bottom:5 left:0];
    [_btn3 setEnlargeEdgeWithTop:5 right:0 bottom:5 left:0];
    
    
}
- (void)getData{}



- (void)rightAction:(id)sender{
    
    NSLog(@"出现下拉菜单");
    
    _downView.hidden = !_downView.hidden;
    
    _bigView.hidden = !_bigView.hidden;
    
    
    
    
}
//通讯录
- (void)btnAction1:(UIButton*)button {
    
    
    NSLog(@"通讯录");
    
    [self hiddenBackView:nil];
    
    
//    AddressBookVC*vc = [AddressBookVC new];
    AddressNewBookVC*vc = [AddressNewBookVC new];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


//注销
- (void)btnAction2:(UIButton*)button {
    
    NSLog(@"注销");
    
    [self hiddenBackView:nil];
    
    //清空账号
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    model.isRecode = @"0";
    model.userName=nil;
    model.pwdName=nil;
    
    model.isLogout = @"1";
    
    model.isAutoLogin = @"0";
    
    model.isRecode = @"0";
    
    [DDGetUserInformationTool saveUserInformationWithModel:model];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//退出
- (void)btnAction3:(UIButton*)button {
    
    NSLog(@"退出");
    
    [self hiddenBackView:nil];
    
    [self exitApplication];//退出app
    
    
    
}

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:delegate.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    delegate.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
    
}



- (void)hiddenBackView:(UITapGestureRecognizer*)tap{
    
    _bigView.hidden = YES;
    _downView.hidden = YES;
    
    
}


#pragma mark   script发送消息给原生
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"message == %@",message);
    
    NSString*type = message.body;
    
//    @"{\"type\":\"phonebook\"}";
    
    NSLog(@"type.mj_JSONData == %@",type.mj_JSONData);

    
 NSDictionary*dict =  [NSJSONSerialization JSONObjectWithData:type.mj_JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    if (dict != nil && [dict.allKeys containsObject:@"type"]) {
        
        
        
        if ([dict[@"type"]  isEqualToString:@"phonebook"]) {//通讯录
        
            [self btnAction1:nil];
            
            
        }else if ([dict[@"type"]  isEqualToString:@"logout"]){//注销
            
            
            [self btnAction2:nil];
            
            
        }else if ([dict[@"type"]  isEqualToString:@"quit"]){//退出
            
            
            [self btnAction3:nil];
            
        }else{//显示菜单
            
            
            
//            [self rightAction:nil];
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
}



- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"方法");
    
//    [self rightAction:nil];
    
    
}





@end
