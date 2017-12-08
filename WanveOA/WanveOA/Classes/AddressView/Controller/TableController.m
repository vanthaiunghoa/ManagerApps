//
//  TableController.m
//  WanveOA
//
//  Created by wanve on 17/11/8.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import "TableController.h"
#import "AddressModel.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

static const CGFloat MJDuration = 2.0;
/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface TableController ()

@property (nonatomic, strong) NSMutableArray *addressModels;;

@end

@implementation TableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"通讯录";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    MJPerformSelectorLeakWarning(
//                                 [self performSelector:NSSelectorFromString(self.method) withObject:nil];
//                                 );
    [self drag];
}

-(void)get
{
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"UserID":@"cwq",
                           @"UserPsw":@"123456"
                           };
    [manager GET:@"http://121.15.203.82:9210/DMS_Phone/Login/LoginHandler.ashx?Action=Login&cmd=" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}

-(void)post
{
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"UserID":@"cwq",
                           @"UserPsw":@"123456"
                           };
    [manager POST:@"http://121.15.203.82:9210/DMS_Phone/Login/LoginHandler.ashx?Action=Login&cmd=" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
      
        
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSDictionary *dictM = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
//        PLog(@"%@",dictM);
//        [dictM writeToFile:@"/Users/xiaomage/Desktop/video.plist" atomically:YES];
//        
//        NSArray *arrayM = dictM[@"videos"];
        
        //字典转模型
        //        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:arrayM.count];
        //
        //        for (NSDictionary *dict in arrayM) {
        //            [arr addObject:[XMGVideo videoWithDict:dict]];
        //        }
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        id obj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        PLog(@"result = %@", obj[@"Result"]);
        PLog(@"Message = %@", obj[@"Message"]);
        
//        self.loginInfo = [LoginInfo objectWithKeyValues:obj];
        

        //字典数组
//        self.loginInfo = [LoginInfo mj_objectWithKeyValues:str];
//
//        PLog(@"----%@",self.videos);
 
//        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}

-(void)get2
{
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"username":@"520it",
                           @"pwd":@"520it"
                           };
    [manager GET:@"http://120.25.226.186:32812/login" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
}

-(void)post2
{
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //2.发送请求
    NSDictionary *dict = @{
                           @"username":@"520it",
                           @"pwd":@"520it"
                           };
    [manager POST:@"http://120.25.226.186:32812/login" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        PLog(@"请求成功--%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

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

- (void)drag
{
    [self refresh];
    
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置文字
//    [footer setTitle:@"点击或者下拉刷新数据" forState:MJRefreshStateIdle];
//    [footer setTitle:@"数据加载中..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    
//    // 设置字体
//    footer.stateLabel.font = [UIFont systemFontOfSize:17];
//    
//    // 设置颜色
//    footer.stateLabel.textColor = [UIColor blueColor];
    
    // 设置footer
    self.tableView.mj_footer = footer;
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.addressModels insertObject:MJRandomData atIndex:0];
    }
    
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
    for (int i = 0; i<5; i++) {
        [self.addressModels addObject:MJRandomData];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.mj_footer endRefreshing];
    });
    
    
    // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//    [tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark 加载最后一份数据
- (void)loadLastData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.addressModels addObject:MJRandomData];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

#pragma mark 只加载一次数据
- (void)loadOnceData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.addressModels addObject:MJRandomData];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 隐藏当前的上拉刷新控件
        tableView.mj_footer.hidden = YES;
    });
}

- (NSMutableArray *)addressModels
{
    if (!_addressModels) {
        self.addressModels = [NSMutableArray array];
        for (int i = 0; i<5; i++) {
            [self.addressModels addObject:MJRandomData];
        }
    }
    return _addressModels;
}

#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", indexPath.row % 2?@"push":@"modal", self.addressModels[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MJTestViewController *test = [[MJTestViewController alloc] init];
//    if (indexPath.row % 2) {
//        [self.navigationController pushViewController:test animated:YES];
//    } else {
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
}



@end
