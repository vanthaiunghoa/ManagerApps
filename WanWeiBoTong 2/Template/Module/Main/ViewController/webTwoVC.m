//
//  webTwoVC.m
//  Template
//
//  Created by Apple on 2017/11/24.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "webTwoVC.h"

#import "protocol.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "AddressBookVC.h"

#import "AddressNewBookVC.h"

#import "AppDelegate.h"

#import <WebKit/WebKit.h>

#define kUrl @"http://121.15.203.82:9210/DMS_Phone/"


@interface webTwoVC ()<LZBJSExport>

@property (nonatomic , strong ) UIWebView * webview ;

@end

@implementation webTwoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    [self creatUI];
    
    [self layout];
    
    [self getData];
    
    
    
    
    
    
}

- (void)configNav{}
- (void)creatUI{
    
    _webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    //注册上下文.
    [self regiseterResponser];
    
    
    NSString*userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userNameStr"];
    NSString*pwdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwdStr"];
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    NSString*urlStr;
    
    if ([model.isOpenLogin isEqualToString:@"1"]) {//开启vpn
    

        urlStr = @"http://172.21.102.222:8000/dgjxj_touch/Login/Index.aspx";
        
        
    }else{//没有开启vpn.
        
        
        urlStr = [NSString stringWithFormat:@"http://121.15.203.82:9210/DMS_Phone/Login/QuickLogin.aspx?cmd={UserID:\"%@\",UserPsw:\"%@\"}",userName,pwdStr];
        
        
    }
    
    
    //url 编码
    urlStr  =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL*url = [NSURL URLWithString:urlStr];
    
    
    NSURLRequest*request = [NSURLRequest requestWithURL:url];
    

    
    
    [_webview loadRequest:request];


    
    [self.view addSubview:_webview];
    
}
- (void)layout{}
- (void)getData{}


#pragma mark 协议方法

#pragma mark - 第二种方式JSEport协议方式
- (void)regiseterResponser
{
    
    
    JSContext *context = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [context setObject:self forKeyedSubscript:@"iOSJsCore"];
    
//  网页js这样写    iOSJsCore.ClickiOS(message);
    
    //     [context setObject:self forKeyedSubscript:@"EyeUtil"];
    
}

//点击了iOS,出现菜单
- (void)ClickiOS:(NSString*)parma{

    NSLog(@"js调用了OC方法");
    
    NSDictionary*dict =  [NSJSONSerialization JSONObjectWithData:parma.mj_JSONData options:NSJSONReadingMutableLeaves error:nil];
    
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


//通讯录
- (void)btnAction1:(UIButton*)button {
    
    
    NSLog(@"通讯录");
    
    
    
    
    //    AddressBookVC*vc = [AddressBookVC new];
    AddressNewBookVC*vc = [AddressNewBookVC new];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


//注销
- (void)btnAction2:(UIButton*)button {
    
    NSLog(@"注销");
    
    
    
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




@end
