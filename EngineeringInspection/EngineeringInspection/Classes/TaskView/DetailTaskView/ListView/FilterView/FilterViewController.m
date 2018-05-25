#import "FilterViewController.h"
#import "FilterCell.h"
#import "ListModel.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
#import "UIColor+color.h"

static const CGFloat MJDuration = 2.0;

@interface FilterViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *issueTableView;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *btnPre;
@property (nonatomic, strong) UIView *issueView;
@property (nonatomic, strong) UIView *dispatchView;
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation FilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    
    [self initSegmentControl];
    [self initBottomView];
    [self initIssueTableView];
}

#pragma mark - init

- (void)initSegmentControl
{
    CGFloat btnW = (self.view.bounds.size.width - 50)/3.0;
    CGFloat x = 0;
    NSArray *arr = [[NSArray alloc]initWithObjects:@"问题清单", @"待办事项", @"筛选", nil];
    
    for(int i = 0; i < arr.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, TOP_HEIGHT, btnW, 44)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRGB:28 green:120 blue:255] forState:UIControlStateSelected];
        btn.tag = i;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:btn];
        if(0 == i)
        {
            btn.selected = YES;
            _btnPre = btn;
        }
        
        [btn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        
        x += btnW;
    }
}

- (void)initBottomView
{
    _issueView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, (self.view.bounds.size.width - 50), 44)];
    [_issueView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_issueView];
    
    _dispatchView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, (self.view.bounds.size.width - 50), 44)];
    [_dispatchView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_dispatchView];
    _dispatchView.hidden = YES;
    
    CGFloat btnW = (self.view.bounds.size.width - 50)/2.0;
    CGFloat x = 0;
    NSArray *arr = [[NSArray alloc]initWithObjects:@"指派", @"新增", nil];
    
    for(int i = 0; i < arr.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, 0, btnW, 44)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [_issueView addSubview:btn];
        
        [btn addTarget:self action:@selector(issueViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        x += btnW;
    }
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 50)/2.0, 4, 1, 36)];
    [vLine setBackgroundColor:[UIColor lightGrayColor]];
    [_issueView addSubview:vLine];

    NSArray *dispatchArr = [[NSArray alloc]initWithObjects:@"取消", @"全选", @"指派负责人", @"指派期限", nil];
    
    x = 0;
    btnW = (self.view.bounds.size.width - 50)/4.0;
    for(int i = 0; i < dispatchArr.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, 0, btnW, 44)];
        [btn setTitle:dispatchArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [_dispatchView addSubview:btn];
        
        [btn addTarget:self action:@selector(dispatchClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        x += btnW;
    }
}

- (void)initIssueTableView
{
    _modelsArray = [NSMutableArray array];
    NSMutableArray *tmp = [NSMutableArray array];
    NSMutableArray *tmp2 = [NSMutableArray array];
    
    for(int i = 0; i < 3; ++i)
    {
        ListModel *model = [ListModel new];
        model.Title = @"测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容";
        model.HJ = @"缓急";
        model.SendDate = @"类型类型类型";
        model.WhoGiveName = @"位置位置位置";
        
        [tmp addObject:model];
    }
    
    for(int i = 0; i < 3; ++i)
    {
        ListModel *model = [ListModel new];
        model.Title = @"测试内容测试内容测试内容内容测试内容测试内容测试内容222222222222222222";
        model.HJ = @"缓急2222";
        model.SendDate = @"类型类型类型222";
        model.WhoGiveName = @"位置位置位置222222222";
        
        [tmp2 addObject:model];
    }
    
    for(int i = 0; i < 10; ++i)
    {
        if(i%2 == 0)
        {
            [_modelsArray addObject:tmp];
        }
        else
        {
            [_modelsArray addObject:tmp2];
        }
    }
    
    _issueTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT + 44, (self.view.bounds.size.width - 50), self.view.bounds.size.height - 88 - TOP_HEIGHT) style:UITableViewStylePlain];
    [_issueTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_issueTableView setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
    [_issueTableView registerClass:[FilterCell class] forCellReuseIdentifier:NSStringFromClass([FilterCell class])];
    [_issueTableView setDelegate:self];
    [_issueTableView setDataSource:self];
    _issueTableView.sectionHeaderHeight = 40;
    [self.view addSubview:_issueTableView];
    
    [self loadMore];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -clicked

-(void)selected:(UIButton *)sender
{
    //    UISegmentedControl* control = (UISegmentedControl*)sender;
    if(sender.tag < 2 && (_btnPre.tag != sender.tag))
    {
        _btnPre.selected = NO;
        _btnPre = sender;
    }
    
    switch (sender.tag)
    {
        case 0:
            PLog(@"问题清单");
            sender.selected = YES;
            break;
        case 1:
            sender.selected = YES;
            PLog(@"待办事项");
            break;
        case 2:
            PLog(@"筛选");
            self.huge = 5432;
            self.num = 520;
            break;
        default:
            PLog(@"error");
            break;
    }
}

- (void)issueViewClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
            PLog(@"指派");
            _issueView.hidden = YES;
            _dispatchView.hidden = NO;
            break;
        case 1:
            PLog(@"新增");
            break;
        default:
            PLog(@"error");
            break;
    }
}

- (void)dispatchClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
            PLog(@"取消");
            _dispatchView.hidden = YES;
            _issueView.hidden = NO;
            break;
        case 1:
            PLog(@"全选");
            break;
        case 2:
            PLog(@"指派负责人");
            break;
        case 3:
            PLog(@"指派期限");
            break;
        default:
            PLog(@"error");
            break;
    }
}

#pragma mark - 示例代码
#pragma mark UITableView + 下拉刷新 默认
- (void)refresh
{
//    __weak __typeof(self) weakSelf = self;

    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _issueTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewData];
        _page = 1;
        [self download:_page];
    }];

    // 马上进入刷新状态
    [_issueTableView.mj_header beginRefreshing];
}

#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
    [self refresh];

    __weak __typeof(self) weakSelf = self;

    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _issueTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    __weak UITableView *tableView = _issueTableView;
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
                _modelsArray = [ListModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
            }
            else
            {
                NSMutableArray *tmp = [ListModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
                for(ListModel *model in tmp)
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

        [_issueTableView reloadData];
        if(1 == _page)
        {
            [_issueTableView.mj_header endRefreshing];
        }
        else
        {
            [_issueTableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
        if(1 == _page)
        {
            [_issueTableView.mj_header endRefreshing];
        }
        else
        {
            [_issueTableView.mj_footer endRefreshing];
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
    __weak UITableView *tableView = _issueTableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];

        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [tableView.mj_footer endRefreshingWithNoMoreData];
    });
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_modelsArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [FilterCell class];
    ListModel *model = self.modelsArray[indexPath.section][indexPath.row];
//
//    if (model.imagePathsArray.count > 1)
//    {
//        currentClass = [ReceiveCell2 class];
//    }
    /*
     普通版也可实现一步设置搞定高度自适应，不再推荐使用此套方法，具体参看“UITableView+SDAutoTableViewCellHeight”头文件
     return [_issueTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass];
     */
    
    // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
    return [_issueTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = self.modelsArray[indexPath.section][indexPath.row];
    FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FilterCell class])];
    cell.model = model;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    [self.cells addObject:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"2018-08-08 08:08:08";
}

#pragma mark - lazy load

- (NSMutableArray *)cells
{
    if(_cells == nil)
    {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

@end
