#import "MJTableViewController.h"
#import "UserManager.h"
#import "VPNManager.h"
#import "WebViewController.h"
#import "UIViewController+BackButtonHandler.h"

#define DEMO_VIEW_CONTROLLER_PUSH FALSE
static const CGFloat tableViewRow = 4;
static const CGFloat MJDuration = 2.0;
/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface MJTableViewController()
/** 用来显示的假数据 */
@property (strong, nonatomic) NSArray *data;
@end

@implementation MJTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //    MJPerformSelectorLeakWarning(
    //        [self performSelector:NSSelectorFromString(self.method) withObject:nil];
    //                                 );
    [self loadMore];
}

- (BOOL)navigationShouldPopOnBackButton
{
    [[UserManager sharedUserManager] logout];
    [[VPNManager sharedVPNManager] stopVPN];
    return YES;
}

#pragma mark - 示例代码
#pragma mark UITableView + 下拉刷新 默认
- (void)refresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    [self refresh];
    
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.data insertObject:MJRandomData atIndex:0];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.data addObject:MJRandomData];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.mj_footer endRefreshing];
    });
}

#pragma mark 加载最后一份数据
- (void)loadLastData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.data addObject:MJRandomData];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

- (NSArray *)data
{
    if (!_data) {
        self.data = [NSArray array];
//        for (int i = 0; i < tableViewRow; ++i) {
//            [self.data addObject:MJRandomData];
//        }
        self.data = @[@"注销", @"pdf", @"WebView", @"sd_autolayout"];
    }
    return _data;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.row)
    {
        [self logout];
    }
    else if(1 == indexPath.row)
    {
        
    }
    else if(2 == indexPath.row)
    {
        WebViewController *vc = [[WebViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    MJTestViewController *test = [[MJTestViewController alloc] init];
//    if (indexPath.row % 2) {
//        [self.navigationController pushViewController:test animated:YES];
//    } else {
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
}

- (void)logout
{
    [[UserManager sharedUserManager] logout];
    [[VPNManager sharedVPNManager] stopVPN];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
