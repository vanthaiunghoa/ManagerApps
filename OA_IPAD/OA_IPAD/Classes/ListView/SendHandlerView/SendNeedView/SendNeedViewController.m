#import "SendNeedViewController.h"
#import "SendHandlerCell.h"
#import "UIImage+EasyExtend.h"
#import "UIColor+Scheme.h"
#import "UIColor+color.h"
#import "UIColor+EasyExtend.h"
#import "MBProgressHUD+LCL.h"
#import <MJRefresh/MJRefresh.h>
#import "SendFileListViewModel.h"
#import "ModelManager.h"

@interface SendNeedViewController ()<UITableViewDelegate, UITableViewDataSource, SendHandlerCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation SendNeedViewController

#pragma mark - view controller life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"ReloadSendHandlerData" object:nil];
    
    self.isRefresh = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = ViewColor;
    [self initTableView];
}

- (void)refresh
{
    self.isRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.isRefresh)
    {
        self.isRefresh = NO;
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - topHeight - 55)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    [self.tableView registerClass:[SendHandlerCell class] forCellReuseIdentifier:NSStringFromClass([SendHandlerCell class])];
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestDataRefresh:YES];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self requestDataRefresh:NO];
    }];
    
    footer.stateLabel.text = @"";
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - data flow

- (void)requestDataRefresh:(BOOL)refresh
{
    if(refresh)
    {
        self.currentPage = 1;
        self.viewModel.listItems = [NSMutableArray arrayWithCapacity:10];
    }
    
    NSDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"PageSize" : @10,
                                                                           @"PageNum" : @(self.currentPage),
                                                                           @"SearchType" : @"CanHandle",
                                                                           @"FWState" : @"",                          // 发文状态
                                                                           @"WHT" : [ModelManager sharedModelManager].dict[@"文号头"],   // 文号头
                                                                           @"WHN" : [ModelManager sharedModelManager].dict[@"文号年"],    // 文号年
                                                                           @"WHZ" : [ModelManager sharedModelManager].dict[@"文号字"],    // 文号字
                                                                           @"BT" : [ModelManager sharedModelManager].dict[@"标题"],       // 标题
                                                                           @"WZ" : [ModelManager sharedModelManager].dict[@"文种"],
                                                                           @"NGR" : [ModelManager sharedModelManager].dict[@"拟稿人"],            //
                                                                           @"ZTC" : @""}];
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    @weakify(self);
    [[[self.viewModel requestListCommand] execute:params] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"数据加载成功"];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if ([x count])
        {
            if((self.currentPage) != self.viewModel.totalPage)
            {
                [self.tableView.mj_footer endRefreshing];
            }
            else
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            self.currentPage++;
        }
        else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError * _Nullable error)
     {
         @strongify(self);
         self.view.userInteractionEnabled = YES;
         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     }];
}

#pragma mark - SendHandlerCellDelegate

- (void)approval:(NSIndexPath *)indexPath
{
    UIViewController *next = [self.viewModel touchTitleNextViewControllerWithIndex:indexPath.row];
    if (next) {
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void)userDidHandleTask:(NSNotification *)notification {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendHandlerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendHandlerCell class])];
    id<ListCellDataSource> dataSource = self.viewModel.models[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = dataSource;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [SendHandlerCell class];
    id<ListCellDataSource> model = self.viewModel.models[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *next = [self.viewModel touchButtonNextViewControllerWithIndex:indexPath.row];
    if (next) {
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width - 40;
}

#pragma mark - lazy load

- (SendFileListViewModel *)viewModel
{
    if(_viewModel == nil)
    {
        _viewModel = [SendFileListViewModel new];
    }
    
    return _viewModel;
}


@end
