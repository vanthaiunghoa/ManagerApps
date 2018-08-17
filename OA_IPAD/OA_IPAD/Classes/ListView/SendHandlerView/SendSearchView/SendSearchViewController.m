#import "SendSearchViewController.h"
#import "SendHandlerCell.h"
#import "UIColor+color.h"
#import <MJRefresh/MJRefresh.h>
#import "SendFileListViewModel.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "SendFilterViewController.h"

@interface SendSearchViewController ()<UITableViewDelegate, UITableViewDataSource, SendHandlerCellDelegate, SendFilterViewControllerDelegate>

@property (nonatomic, strong) SendFileListViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation SendSearchViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发文办理查询";
    
    self.fd_interactivePopDisabled = YES; //禁用侧滑
    self.view.backgroundColor = ViewColor;
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
    [self addFilterButton];
    [self initTableView];
}

- (void)addFilterButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setTitle:@"筛选条件" forState:0];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
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
}

#pragma mark - clicked

- (void)filterClicked:(UIButton *)sender
{
    SendFilterViewController *vc = [[SendFilterViewController alloc] init];
    vc.dict = [self.dict mutableCopy];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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
                                                                           @"FWState" : @"",                          // 发文状态
                                                                           @"WHT" : self.dict[@"文号头"],              // 文号头
                                                                           @"WHN" : self.dict[@"文号年"],              // 文号年
                                                                           @"WHZ" : self.dict[@"文号字"],              // 文号字
                                                                           @"BT" : self.dict[@"标题"],                 // 标题
                                                                           @"WZ" : self.dict[@"文种"],
                                                                           @"NGR" : self.dict[@"拟稿人"],            //
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

#pragma mark - SendFilterViewControllerDelegate

- (void)controller:(SendFilterViewController *)controller didConfirmFilter:(NSMutableDictionary *)dict
{
    [controller.navigationController popViewControllerAnimated:YES];

    self.dict = [dict mutableCopy];
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

- (NSMutableDictionary *)dict
{
    if(_dict == nil)
    {
        _dict = [NSMutableDictionary dictionaryWithCapacity:9];
        
        //向词典中动态添加数据
        [_dict setObject:@"" forKey:@"文号头"];         // 文号头
        [_dict setObject:@"" forKey:@"文号年"];         // 文号年

        [_dict setObject:@"" forKey:@"文号字"];         // 文号字
        [_dict setObject:@"" forKey:@"标题"];           // 标题

        [_dict setObject:@"" forKey:@"文种"];
        [_dict setObject:@"" forKey:@"拟稿人"];
    }
    
    return _dict;
}

@end
