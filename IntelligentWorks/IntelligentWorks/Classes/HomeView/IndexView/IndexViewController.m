//
//  IndexViewController.m
//  IntelligentWorks
//
//  Created by wanve on 2018/8/8.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "IndexViewController.h"
#import "UIColor+color.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initScrollView];
}

- (void)initScrollView
{
    CGFloat y = TOP_HEIGHT;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y)];
    scrollView.backgroundColor = ViewColor;
    [self.view addSubview:scrollView];
    
    y = 40;
    CGFloat x = 30;
    CGFloat margin = 10;
    CGFloat btnW = (SCREEN_WIDTH - 2.0*x - margin)/2.0;
    for(int i = 0; i < 5; ++i)
    {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [scrollView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i", i]] forState:UIControlStateNormal];
        btn.tag = i;
        if(i%2 == 0 && i != 0)
        {
            x = 30;
            y += btnW + margin;
        }
        btn.frame = CGRectMake(x, y, btnW, btnW);
        
        x += btnW + margin;
    }
    
    y += 40 + btnW;
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, y)];
}

@end
