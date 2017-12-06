#import "ReceiveTableViewController.h"
#import "ReceiveCell.h"
#import "ReceiveCell2.h"
#import "ReceiveModel.h"
#import "UserManager.h"
#import "UserModel.h"
//#import "ReceiveDetailViewController.h"

static const CGFloat MJDuration = 2.0;

@interface ReceiveTableViewController()
/** 用来显示的假数据 */
@property (strong, nonatomic) NSArray *data;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ReceiveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self creatModelsWithCount:18];
    
    [self.tableView registerClass:[ReceiveCell class] forCellReuseIdentifier:NSStringFromClass([ReceiveCell class])];
//    [self.tableView registerClass:[ReceiveCell2 class] forCellReuseIdentifier:NSStringFromClass([ReceiveCell2 class])];
    [self loadMore];
}

- (NSMutableArray *)modelsArray
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    return _modelsArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 示例代码
#pragma mark UITableView + 下拉刷新 默认
- (void)refresh
{
//    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewData];
        _page = 1;
        [self download:_page];
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

- (void)download:(NSInteger)page
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"数据加载中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    // 2.发送请求
    
//    NSString *str = [NSString stringWithFormat:@"{\"ActiveCode\":\"%@\"}", userModel.activeCode];
//    NSString *receive = @"收文";
    NSString *str = [NSString stringWithFormat:@"{\"ActiveCode\":\"%@\",\"PageSize\":\"10\",\"PageNum\":\"%zd\",\"BLSate\":\"ALL\"}", userModel.activeCode, self.page];
    NSDictionary *dict = @{
                           @"Action":@"GetSWHandleList_BLState",
                           @"jsonRequest":str
                           };
    PLog(@"dict == %@", dict);

    NSString *url = @"http://202.104.110.143:8009/oasystem/Handlers/DMS_FileMan_Handler.ashx?";
    
    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        // 转码
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* utf8Str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
        PLog(@"utf8Str == %@", utf8Str);
        NSData *data = [utf8Str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        NSNumber *isSuccess = dict[@"IsSuccess"];
        PLog(@"isSuccess == %@", isSuccess);
        NSNumber *num = [NSNumber numberWithInt:1];
        if([isSuccess isEqualToNumber:num])
        {
            if(1 == self.page)
            {
                _modelsArray = [ReceiveModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
            }
            else
            {
                NSMutableArray *tmp = [ReceiveModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
                [_modelsArray addObject:tmp];
            }
        }
        else
        {
            NSString *mes = dict[@"Status"];
            [SVProgressHUD showErrorWithStatus:mes];
        }

        [self.tableView reloadData];
        if(1 == _page)
        {
            [self.tableView.mj_header endRefreshing];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    ++_page;
    [self download:_page];
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
        self.data = @[@"收文办理", @"发文办理", @"WebView", @"sd_autolayout"];
    }
    return _data;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ReceiveCell class];
    ReceiveModel *model = self.modelsArray[indexPath.row];
//
//    if (model.imagePathsArray.count > 1)
//    {
//        currentClass = [ReceiveCell2 class];
//    }
    /*
     普通版也可实现一步设置搞定高度自适应，不再推荐使用此套方法，具体参看“UITableView+SDAutoTableViewCellHeight”头文件
     return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass];
     */
    
    // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ReceiveCell class];
    ReceiveCell *cell = nil;
    
    ReceiveModel *model = self.modelsArray[indexPath.row];
//    if (model.imagePathsArray.count > 1)
//    {
//        currentClass = [ReceiveCell2 class];
//    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.model = model;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ReceiveDetailViewController *vc = [NSClassFromString(@"ReceiveDetailViewController") new];
//    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController pushViewController:[NSClassFromString(@"ReceiveDetailViewController") new] animated:YES];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
