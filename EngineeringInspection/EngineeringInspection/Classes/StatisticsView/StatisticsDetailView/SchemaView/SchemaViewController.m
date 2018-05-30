#import "SchemaViewController.h"
#import "SchemaCell.h"
#import "SchemaModel.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
#import "UIColor+color.h"
#import "PNChart.h"

static const CGFloat MJDuration = 2.0;

@interface SchemaViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation SchemaViewController

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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_HEIGHT - 44) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
    [_tableView registerClass:[SchemaCell class] forCellReuseIdentifier:NSStringFromClass([SchemaCell class])];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 360)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat y = 0;
    CGFloat x = 0;
    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH, 20)];
    marginView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [headerView addSubview:marginView];
    y += 25;
    
    NSArray *topArray = @[@"任务数", @"问题数", @"记录数"];
    CGFloat labW = SCREEN_WIDTH/3.0;
    for(int i = 0; i < topArray.count; ++i)
    {
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(x, y, labW, 30)];
        [num setFont:[UIFont systemFontOfSize:14]];
        [num setText:@"-"];
        [num setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:num];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(x, y + 30, labW, 35)];
        [description setFont:[UIFont systemFontOfSize:16]];
        [description setTextAlignment:NSTextAlignmentCenter];
        [description setText:topArray[i]];
        [headerView addSubview:description];
        
        x += labW;
        
        if(i < 2)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y+5, 1, 60)];
            line.backgroundColor = [UIColor darkGrayColor];
            [headerView addSubview:line];
        }
    }
    y += 82;
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:[UIColor colorWithRGB:41 green:150 blue:243] description:@"待指派"],
                       [PNPieChartDataItem dataItemWithValue:15 color:[UIColor colorWithRGB:232 green:72 blue:99] description:@"待修复"],
                       [PNPieChartDataItem dataItemWithValue:30 color:[UIColor colorWithRGB:244 green:151 blue:49] description:@"待销项"],
                       [PNPieChartDataItem dataItemWithValue:45 color:[UIColor colorWithRGB:203 green:219 blue:56] description:@"已销项"],
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

    y += 217;
    CGFloat colorW = 15;
    labW = 55;
    CGFloat margin = (SCREEN_WIDTH - 4.0*(labW+colorW))/5.0;
    x = margin;
    NSArray *descriptionArray = @[@"待指派", @"待修复", @"待销项", @"已销项"];
    NSArray *colorArray = @[[UIColor colorWithRGB:41 green:150 blue:243], [UIColor colorWithRGB:232 green:72 blue:99], [UIColor colorWithRGB:244 green:151 blue:49], [UIColor colorWithRGB:203 green:219 blue:56]];
    for(int i = 0; i < descriptionArray.count; ++i)
    {
        UIView *color = [[UIView alloc] initWithFrame:CGRectMake(x, y, colorW, colorW)];
        color.backgroundColor = colorArray[i];
        [headerView addSubview:color];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(x + colorW, y - 2, labW, 19)];
        [description setFont:[UIFont systemFontOfSize:14]];
        [description setText:descriptionArray[i]];
        [description setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:description];
        
        x += margin + colorW + labW;
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
                _modelsArray = [SchemaModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
            }
            else
            {
                NSMutableArray *tmp = [SchemaModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
                for(SchemaModel *model in tmp)
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
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchemaModel *model = self.modelsArray[indexPath.row];
    SchemaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SchemaCell class])];
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
        for(int i = 0; i < 2; ++i)
        {
            SchemaModel *model = [SchemaModel new];
            model.name = @"质量检查-万维博通大厦";
            model.record = @"3";
            model.unrepair = @"10";
            model.distribute = @"2";
            model.destroy = @"5";
            model.undestroy = @"30";
            
            [_modelsArray addObject:model];
        }
    }
    
    return _modelsArray;
}

@end
