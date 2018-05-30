#import "TrackViewController.h"
#import "TrackCell.h"
#import "TrackModel.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
#import "UIColor+color.h"
#import "PNChart.h"

static const CGFloat MJDuration = 2.0;

@interface TrackViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, strong) NSArray *descriptionArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation TrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    
    [self initTableView];
    [self initHeaderView];
}

#pragma mark - init

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_HEIGHT - 88) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
    [_tableView registerClass:[TrackCell class] forCellReuseIdentifier:NSStringFromClass([TrackCell class])];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330)];
    headerView.backgroundColor = [UIColor whiteColor];

    CGFloat y = 0;
    CGFloat x = 0;
    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 20)];
    marginView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [headerView addSubview:marginView];
    y += 40;
    
    NSArray *colorArray = @[[UIColor colorWithRGB:255 green:151 blue:49], [UIColor colorWithRGB:232 green:72 blue:99], [UIColor colorWithRGB:61 green:80 blue:179], [UIColor colorWithRGB:203 green:219 blue:56], [UIColor colorWithRGB:41 green:150 blue:243]];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:colorArray[0] description:self.descriptionArray[0]],
                       [PNPieChartDataItem dataItemWithValue:15 color:colorArray[1] description:self.descriptionArray[1]],
                       [PNPieChartDataItem dataItemWithValue:30 color:colorArray[2] description:self.descriptionArray[2]],
                       [PNPieChartDataItem dataItemWithValue:45 color:colorArray[3] description:self.descriptionArray[3]],
                       [PNPieChartDataItem dataItemWithValue:45 color:colorArray[4] description:self.descriptionArray[4]]
                       ];
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2.0 - 100), y, 200.0, 200.0) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.showOnlyValues = NO;
    [pieChart strokeChart];
    pieChart.legendStyle = PNLegendItemStyleStacked;
    pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    [headerView addSubview:pieChart];

    y += 225;
    CGFloat colorW = 15;
    CGFloat labW = 97;
    CGFloat margin = (SCREEN_WIDTH - 3.0*(labW+colorW))/4.0;
    x = margin;
    
    for(int i = 0; i < 3; ++i)
    {
        UIView *color = [[UIView alloc] initWithFrame:CGRectMake(x, y, colorW, colorW)];
        color.backgroundColor = colorArray[i];
        [headerView addSubview:color];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(x + colorW + 5, y - 2, labW, 19)];
        [description setFont:[UIFont systemFontOfSize:14]];
        [description setText:self.descriptionArray[i]];
        [description setTextAlignment:NSTextAlignmentLeft];
//        [description setBackgroundColor:[UIColor redColor]];
        [headerView addSubview:description];
        
        x += margin + colorW + labW;
    }
    
    y += 35;
    labW = 70;
    x = SCREEN_WIDTH/2.0 - 20 - labW - colorW;
    for(int i = 3; i < self.descriptionArray.count; ++i)
    {
        UIView *color = [[UIView alloc] initWithFrame:CGRectMake(x, y, colorW, colorW)];
        color.backgroundColor = colorArray[i];
        [headerView addSubview:color];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(x + colorW + 5, y - 2, labW, 19)];
//        [description setBackgroundColor:[UIColor redColor]];
        [description setFont:[UIFont systemFontOfSize:14]];
        [description setText:self.descriptionArray[i]];
        [description setTextAlignment:NSTextAlignmentLeft];
        [headerView addSubview:description];
        
        x = SCREEN_WIDTH/2.0 + 20;
    }
    
    _tableView.tableHeaderView = headerView;
}

#pragma mark UITableView + 下拉刷新 默认
- (void)refresh
{
//    __weak __typeof(self) weakSelf = self;

    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewData];
        _page = 1;
        [self download:_page];
    }];

    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];
}

#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    [self refresh];

    __weak __typeof(self) weakSelf = self;

    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    __weak UITableView *tableView = _tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];

        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
    });
}

- (void)download:(NSInteger)page
{
/*    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"数据加载中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    // 2.发送请求
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"ActiveCode\":\"%@\",\"PageSize\":\"10\",\"PageNum\":\"%zd\",\"BLState\":\"ALL\"}", userModel.activeCode, self.page];
//    NSString *state = @"1";
//    NSString *jsonRequest = [NSString stringWithFormat:@"{\"ActiveCode\":\"%@\",\"BLState\":\"%@\"}", userModel.activeCode, state];
    NSDictionary *dict = @{
                           @"Action":@"GetSWHandleListOfBLState",
                           @"jsonRequest":jsonRequest
                           };
    PLog(@"dict == %@", dict);
    
    [manager POST:[[UrlManager sharedUrlManager] getSWHandlerListUrl] parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        PLog(@"请求成功--result == %@", result);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        NSNumber *isSuccess = dict[@"IsSuccess"];
        PLog(@"isSuccess == %@", isSuccess);
        NSNumber *num = [NSNumber numberWithInt:1];
        if([isSuccess isEqualToNumber:num])
        {
            if(1 == self.page)
            {
                _modelsArray = [TrackModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
            }
            else
            {
                NSMutableArray *tmp = [TrackModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
                for(TrackModel *model in tmp)
                {
                    [_modelsArray addObject:model];
                }
            }
        }
        else
        {
            NSString *mes = dict[@"ErrorMessage"];
            [SVProgressHUD showErrorWithStatus:mes];
        }

        [_tableView reloadData];
        if(1 == _page)
        {
            [_tableView.mj_header endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
        if(1 == _page)
        {
            [_tableView.mj_header endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshing];
        }
    }];*/
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
    __weak UITableView *tableView = _tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];

        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackModel *model = self.modelsArray[indexPath.row];
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TrackCell class])];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - lazy load

- (NSMutableArray *)modelsArray
{
    if(_modelsArray == nil)
    {
        _modelsArray = [NSMutableArray array];
        for(int i = 0; i < self.descriptionArray.count; ++i)
        {
            TrackModel *model = [TrackModel new];
            model.des = self.descriptionArray[i];
            model.percent = @"6个，占30%";
            [_modelsArray addObject:model];
        }
    }
    
    return _modelsArray;
}

- (NSArray *)descriptionArray
{
    if(_descriptionArray == nil)
    {
        _descriptionArray = [NSArray array];
        _descriptionArray = @[@"未设置期限", @"未超期未完成", @"已超期未完成", @"超期完成", @"按时完成"];
    }
    
    return _descriptionArray;
}

@end
