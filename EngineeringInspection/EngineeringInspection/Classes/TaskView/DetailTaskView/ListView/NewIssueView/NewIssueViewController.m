//
//  NewIssueViewController.m
//  EngineeringInspection
//
//  Created by wanve on 2018/5/29.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "NewIssueViewController.h"

@interface NewIssueViewController ()

@end

@implementation NewIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView
{
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 50, SCREEN_WIDTH - 100, SCREEN_HEIGHT - 100)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    scrollView.alwaysBounceVertical = YES;
//    scrollView.alwaysBounceHorizontal = NO;
    //    scrollView.showsVerticalScrollIndicator = YES;
    //    scrollView.scrollsToTop = NO;
    //    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 400);
    scrollView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    [self.view addSubview:scrollView];
}


@end
