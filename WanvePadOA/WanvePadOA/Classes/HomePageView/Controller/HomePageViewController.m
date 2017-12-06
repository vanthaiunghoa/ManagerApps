//
//  HomePageViewController.m
//  WanvePadOA
//
//  Created by wanve on 2017/11/30.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageView.h"
#import "IconLabel.h"
#import "ReceiveTableViewController.h"

@interface HomePageViewController ()

@property (nonatomic, strong) HomePageView *homeView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)loadView
{
    _homeView = [[HomePageView alloc] initWithFrame:SCREEN_BOUNDS];
//    NSArray *array = @[@"文字", @"照片视频", @"头条文章", @"红包", @"直播", @"点评", @"好友圈", @"更多", @"音乐", @"商品", @"签到", @"秒拍", @"头条文章", @"红包", @"直播", @"点评"];
    NSArray *array = @[@"收文办理", @"照片视频", @"头条文章", @"红包", @"直播", @"点评", @"好友圈", @"更多", @"音乐", @"商品", @"签到", @"秒拍", @"头条文章", @"红包", @"直播", @"点评"];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *string in array)
    {
        IconLabelModel *item = [IconLabelModel new];
        item.icon = [UIImage imageNamed:[NSString stringWithFormat:@"sina_%@", string]];
        item.text = string;
        [models addObject:item];
    }
    
    self.view = _homeView;
    self.view.backgroundColor = [UIColor whiteColor];
    _homeView.models = models;
    [self handleItemClicked];
}

- (void)handleItemClicked
{
    __weak typeof(self) weak_self = self;
    _homeView.didClickItems = ^(HomePageView *homeView, NSInteger index)
    {
        NSString *title = homeView.items[index].textLabel.text;
        PLog(@"title == %@", title);
        PLog(@"tag == %ld", index);
        
        UIViewController *vc = nil;
        switch (index)
        {
            case 0:
                vc = [NSClassFromString(@"ReceiveTableViewController") new];
                break;
                
            default:
                break;
        }
        
        vc.title = title;
        if(!vc)
        {
            vc = [NSClassFromString(@"ReceiveTableViewController") new];
        }
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"首页";
        weak_self.navigationItem.backBarButtonItem = backItem;
        [weak_self.navigationController pushViewController:vc animated:YES];
    };

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
