#import "InspectionItemViewController.h"
#import "InspectionItemCell.h"
#import "InspectionItemModel.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
#import "UIColor+color.h"
#import "NSString+extension.h"
#import "REFrostedViewController.h"
#import "FilterViewController.h"


static const CGFloat MJDuration = 2.0;

@interface InspectionItemViewController()<UITableViewDataSource,UITableViewDelegate, REFrostedViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *issueTableView;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *btnPre;

@end

@implementation InspectionItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    
    [self initSegmentControl];
    [self initIssueTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.frostedViewController.delegate = self;
}

#pragma mark - init

- (void)initSegmentControl
{
    CGFloat btnW = SCREEN_WIDTH/3.0;
    CGFloat x = 0;
    NSArray *arr = [[NSArray alloc]initWithObjects:@"全部", @"待办事项", @"筛选", nil];
    
    for(int i = 0; i < arr.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, 0, btnW, 44)];
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

- (void)initIssueTableView
{
    _modelsArray = [NSMutableArray array];
    
    for(int i = 0; i < 20; ++i)
    {
        InspectionItemModel *model = [InspectionItemModel new];
        model.type = @"房屋工程";
        model.num = [NSString stringWithFormat:@"%d", i+2];
        
        [_modelsArray addObject:model];
    }
    
    _issueTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.view.bounds.size.height - 88 - TOP_HEIGHT) style:UITableViewStyleGrouped];
    [_issueTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_issueTableView setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
    [_issueTableView registerClass:[InspectionItemCell class] forCellReuseIdentifier:NSStringFromClass([InspectionItemCell class])];
    [_issueTableView setDelegate:self];
    [_issueTableView setDataSource:self];
    _issueTableView.sectionHeaderHeight = 44;
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
            PLog(@"全部");
            sender.selected = YES;
            break;
        case 1:
            sender.selected = YES;
            PLog(@"待办事项");
            break;
        case 2:
            PLog(@"筛选");
            [self showFilterView];
            break;
        default:
            PLog(@"error");
            break;
    }
}

- (void)showFilterView
{
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

- (void)tapClicked:(UITapGestureRecognizer *)tap
{

}

#pragma mark - REFrostedViewControllerDelegate

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
    FilterViewController *vc = (FilterViewController *)menuViewController;
    NSInteger num = vc.huge;
    NSLog(@"inspectionItem num == %ld", num);
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
    FilterViewController *vc = (FilterViewController *)menuViewController;
    NSInteger num = vc.num;
    NSLog(@"inspectionItem num == %ld", num);
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
                           @"Action":@"GetSWHandleInspectionItemOfBLState",
                           @"jsonRequest":jsonRequest
                           };
    PLog(@"dict == %@", dict);
    
    [manager POST:[[UrlManager sharedUrlManager] getSWHandlerInspectionItemUrl] parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
                _modelsArray = [InspectionItemModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
            }
            else
            {
                NSMutableArray *tmp = [InspectionItemModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
                for(InspectionItemModel *model in tmp)
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat arrowHeight = 8;
    CGFloat arrowWidth = 18;
    
    NSString *title = @"质量（安全）管理";
    CGFloat width = [NSString calculateRowWidth:44 string:title fontSize:16] + 10;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *classify = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 44)];
    [classify setTextAlignment:NSTextAlignmentLeft];
    classify.textColor = [UIColor colorWithRGB:28 green:120 blue:255];
    classify.text = title;
    [headerView addSubview:classify];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(13+width, (44 - arrowHeight)/2.0, arrowWidth, arrowHeight)];
    arrow.image = [UIImage imageNamed:@"blue-arrow-down"];
    arrow.userInteractionEnabled = NO;
    [headerView addSubview:arrow];
    
    UILabel *labNum = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 40, 44)];
    [labNum setTextAlignment:NSTextAlignmentRight];
    labNum.textColor = [UIColor redColor];
    labNum.text = @"200";
    [headerView addSubview:labNum];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    tap.delegate = self;
    [headerView addGestureRecognizer:tap];
    headerView.tag = section;
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InspectionItemModel *model = self.modelsArray[indexPath.row];
    InspectionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InspectionItemCell class])];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - private

@end
