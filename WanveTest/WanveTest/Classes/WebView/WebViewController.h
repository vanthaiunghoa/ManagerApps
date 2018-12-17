//
//  WebViewController.h
//  WanveTest
//
//  Created by wanve on 2017/11/27.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

@end
