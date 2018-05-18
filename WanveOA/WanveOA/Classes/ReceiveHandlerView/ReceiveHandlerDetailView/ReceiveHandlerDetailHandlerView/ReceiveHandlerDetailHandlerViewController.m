//
//  ReceiveHandlerDetailHandlerViewController.m
//  WanveOA
//
//  Created by wanve on 2018/3/2.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "ReceiveHandlerDetailHandlerViewController.h"
#import "ReceiveHandlerDetailHandlerView.h"

@interface ReceiveHandlerDetailHandlerViewController ()

@property (strong, nonatomic) ReceiveHandlerDetailHandlerView *handlerView;

@end

@implementation ReceiveHandlerDetailHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = false;
    
////    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 50, SCREEN_WIDTH - 100, SCREEN_HEIGHT - 100)];
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    scrollView.alwaysBounceVertical = YES;
//    scrollView.alwaysBounceHorizontal = NO;
////    scrollView.showsVerticalScrollIndicator = YES;
////    scrollView.scrollsToTop = NO;
////    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 400);
//    scrollView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
//    [self.view addSubview:scrollView];
//
//    CGFloat y = 0;
//    CGFloat h = 44;
//    for(int i = 0; i < 100; ++i)
//    {
//        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, scrollView.bounds.size.width, h)];
//        lab.text = @"hell";
//        [scrollView addSubview:lab];
//
//        y += h;
//    }
}

- (void)loadView {
    _handlerView = [[ReceiveHandlerDetailHandlerView alloc]init];
    self.view = _handlerView;
}


@end
