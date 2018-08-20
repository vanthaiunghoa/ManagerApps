#import "ListViewController.h"
#import "SendHandlerCell.h"
#import "ReceiveHandlerCell.h"
#import "SendRetrievalCell.h"
#import "ReceiveRetrievalCell.h"
#import "UIImage+EasyExtend.h"
#import "UIColor+Scheme.h"
#import "UIColor+color.h"
#import "UIColor+EasyExtend.h"
#import "MBProgressHUD+LCL.h"
#import "TransactionSearchResultsViewController.h"
#import "QuickHandleView.h"
#import <MJRefresh/MJRefresh.h>
#import "ReceiveRetrievalFilterViewController.h"
#import "SendRetrievalFilterViewController.h"

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource, SendHandlerCellDelegate, ReceiveHandlerCellDelegate, SendRetrievalFilterViewControllerDelegate, ReceiveRetrievalFilterViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation ListViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = ViewColor;
    [self addSearchButton];
    [self initTableView];
    if([self.title isEqualToString:@"收文办理"])
    {
        [self initBottomView];
    }
}

- (void)initTableView
{
    if([self.title isEqualToString:@"收文办理"])
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    }
    else
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    if([self.title isEqualToString:@"收文检索"])
    {
        [self.tableView registerClass:[ReceiveRetrievalCell class] forCellReuseIdentifier:NSStringFromClass([ReceiveRetrievalCell class])];
    }
    else if([self.title isEqualToString:@"发文检索"])
    {
        [self.tableView registerClass:[SendRetrievalCell class] forCellReuseIdentifier:NSStringFromClass([SendRetrievalCell class])];
    }
    else if([self.title isEqualToString:@"发文办理"])
    {
        [self.tableView registerClass:[SendHandlerCell class] forCellReuseIdentifier:NSStringFromClass([SendHandlerCell class])];
    }
    else
    {
        [self.tableView registerClass:[ReceiveHandlerCell class] forCellReuseIdentifier:NSStringFromClass([ReceiveHandlerCell class])];
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidHandleTask:) name:@"userDidHandleTask" object:nil];
}

- (void)initBottomView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 64)];
    [btn setImage:[UIImage imageNamed:@"handler"] forState:UIControlStateNormal];
    [btn setTitle:@"快速办理" forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [btn addTarget:self action:@selector(quickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:22];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x3D98FF]] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)addSearchButton
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"search"];
    [searchButton setImage:image forState:0];
    [searchButton setTintColor:[UIColor whiteColor]];
    [searchButton setTitle:@"查询" forState:0];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [searchButton sizeToFit];
//    searchButton.frame = CGRectMake(0, 0, 100, 44);
    [searchButton addTarget:self action:@selector(showSearchController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

#pragma mark - data flow

- (void)requestDataRefresh:(BOOL)refresh
{
    if(refresh)
    {
        self.currentPage = 1;
        self.viewModel.listItems = [NSMutableArray arrayWithCapacity:10];
    }
    
    NSDictionary *params = nil;
    if([self.title isEqualToString:@"发文检索"])
    {
        params = [NSMutableDictionary dictionaryWithDictionary:@{@"PageSize" : @10,
                                                               @"PageNum" : @(self.currentPage),
                                                               @"ifFF" : @"",               // 是否封发
                                                               @"FWH" : @"",                // 发文号
                                                               @"WHT" : self.dict[@"文号头"],              // 文号头
                                                               @"WHN" : self.dict[@"文号年"],              // 文号年
                                                               @"WHZ" : self.dict[@"文号字"],              // 文号字
                                                               @"BT" : self.dict[@"标题"],               // 标题
                                                               @"ZTC" : @"",                               // 主题词
                                                               @"WZ" : self.dict[@"文种"],            // 文种
                                                               @"XXGKCatalog" : @"",                       // 信息公开类目
                                                               @"NGR" : self.dict[@"拟稿人"],
                                                               @"ZSDW" : @"",                              // 主送单位
                                                               @"ZBKS" : @"",                         // 主办科室
                                                               @"QFR" : @"",                              // 签发人
                                                               @"GJQK" : @"",                         // 归档情况
                                                               @"QFDateStart" : self.dict[@"签发日期起"],
                                                               @"QFDateEnd" : self.dict[@"签发日期止"]}];
    }
    else
    {
        params = [NSMutableDictionary dictionaryWithDictionary:@{@"PageSize" : @10,
                                                                 @"PageNum" : @(self.currentPage),
                                                                 @"SWBH" : self.dict[@"流水号"],             // 收文流水号
                                                                 @"HJ" : self.dict[@"缓急"],                // 文件缓急
                                                                 @"WHT" : self.dict[@"文号头"],              // 文号头
                                                                 @"WHN" : self.dict[@"文号年"],              // 文号年
                                                                 @"WHS" : self.dict[@"文号数"],              // 文号数
                                                                 @"Title" : self.dict[@"标题"],              // 标题
                                                                 @"ZTC" : @"",                               // 主题词
                                                                 @"LWDW" : self.dict[@"来文单位"],            // 来文单位
                                                                 @"LWDWLB" : @"",                            // 来文单位类别编号
                                                                 @"MJ" : @"",                                // 文件密级
                                                                 @"WZ" : @"",                                // 文种
                                                                 @"GLML" : @"",                              // 归类目录
                                                                 @"RecKSName" : @"",                         // 主办科室名
                                                                 @"ZSDW" : @"",                              // 主送单位
                                                                 @"BJInfo" : @"",                            // 办结情况
                                                                 @"GDInfo" : @"",                            // 归档情况
                                                                 @"CWTime_S" : self.dict[@"成文时间开始"],     // 成文时间(开始)
                                                                 @"CWTime_E" : self.dict[@"成文时间结束"]}];   // 成文时间(结束)
    }

    
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

#pragma mark - ReceiveRetrievalFilterViewControllerDelegate

- (void)receiveRetrievalFilterViewController:(ReceiveRetrievalFilterViewController *)controller didConfirmFilter:(NSMutableDictionary *)dict
{
    [controller.navigationController popViewControllerAnimated:YES];
    
    self.dict = [dict mutableCopy];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - SendRetrievalFilterViewControllerDelegate

- (void)sendRetrievalFilterViewController:(SendRetrievalFilterViewController *)controller didConfirmFilter:(NSMutableDictionary *)dict
{
    [controller.navigationController popViewControllerAnimated:YES];
    
    self.dict = [dict mutableCopy];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ReceiveRetrievalCellDelegate

- (void)handlerModel:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected
{
    if(isSelected)
    {
        [self.selectedModel addObject:indexPath];
    }
    else
    {
        [self.selectedModel removeObject:indexPath];
    }
}

- (void)approval:(NSIndexPath *)indexPath
{
    UIViewController *next = [self.viewModel touchTitleNextViewControllerWithIndex:indexPath.row];
    if (next) {
        [self.navigationController pushViewController:next animated:YES];
    }
}

#pragma mark - actions

- (void)quickHandle:(id)sender {
    if (self.selectedModel.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"没有选中记录"];
        return;
    }
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:1];
    for (NSIndexPath *indexPath in self.selectedModel) {
        [models addObject:self.viewModel.models[indexPath.row]];
    }
    
    __block NSInteger finishedCount = 0;
    @weakify(self);
    [QuickHandleView showWithConfirmBlock:^(NSString *advice) {
        @strongify(self);
        MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"正在处理.." atView:nil];
        @weakify(self);
        [[self.viewModel quickHandleModels:models advice:advice ] subscribeNext:^(id  _Nullable x) {
        } error:^(NSError * _Nullable error) {
            finishedCount++;
            hud.label.text = [NSString stringWithFormat:@"办理进度：%d/%d",(int)finishedCount, (int)self.selectedModel.count];
        } completed:^{
            @strongify(self);
            [hud showMessage:@"全部处理完毕"];
            NSMutableArray *lefts = [NSMutableArray arrayWithArray: self.viewModel.models];
            [lefts removeObjectsInArray:models];
            self.viewModel.models = lefts;
            [self.tableView reloadData];
            [self.selectedModel removeAllObjects];
        }];
    } fromViewController:self];
}

- (void)showSearchController:(id)sender
{
    if([self.title isEqualToString:@"发文检索"])
    {
        SendRetrievalFilterViewController *vc = [[SendRetrievalFilterViewController alloc] init];
        vc.dict = [self.dict mutableCopy];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else
    {
        ReceiveRetrievalFilterViewController *vc = [[ReceiveRetrievalFilterViewController alloc] init];
        vc.dict = [self.dict mutableCopy];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
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
    if([self.title isEqualToString:@"收文检索"])
    {
        ReceiveRetrievalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiveRetrievalCell class])];
        id<ListCellDataSource> dataSource = self.viewModel.models[indexPath.row];
        cell.model = dataSource;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    else if([self.title isEqualToString:@"发文检索"])
    {
        SendRetrievalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendRetrievalCell class])];
        id<ListCellDataSource> dataSource = self.viewModel.models[indexPath.row];
        cell.model = dataSource;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    else if([self.title isEqualToString:@"收文办理"])
    {
        ReceiveHandlerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiveHandlerCell class])];
        id<ListCellDataSource> dataSource = self.viewModel.models[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        cell.isSelected = NO;
        for(NSIndexPath *index in self.selectedModel)
        {
            if(indexPath.row == index.row)
            {
                cell.isSelected = YES;
                break;
            }
        }
        
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = dataSource;
        return cell;
    }
    else
    {
        SendHandlerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendHandlerCell class])];
        id<ListCellDataSource> dataSource = self.viewModel.models[indexPath.row];
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = dataSource;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.title isEqualToString:@"收文检索"])
    {
        Class currentClass = [ReceiveRetrievalCell class];
        id<ListCellDataSource> model = self.viewModel.models[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
    else if([self.title isEqualToString:@"发文检索"])
    {
        Class currentClass = [SendRetrievalCell class];
        id<ListCellDataSource> model = self.viewModel.models[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
    else if([self.title isEqualToString:@"收文办理"])
    {
        Class currentClass = [ReceiveHandlerCell class];
        id<ListCellDataSource> model = self.viewModel.models[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
    else
    {
        Class currentClass = [SendHandlerCell class];
        id<ListCellDataSource> model = self.viewModel.models[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
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

- (NSMutableArray *)selectedModel
{
    if(_selectedModel == nil)
    {
        _selectedModel = [NSMutableArray array];
    }
    return _selectedModel;
}

- (NSMutableDictionary *)dict
{
    if(_dict == nil)
    {
        _dict = [NSMutableDictionary dictionaryWithCapacity:9];
        
        if([self.title isEqualToString:@"发文检索"])
        {
            //向词典中动态添加数据
            [_dict setObject:@"" forKey:@"文种"];
            [_dict setObject:@"" forKey:@"拟稿人"];
            
            [_dict setObject:@"" forKey:@"文号头"];         // 文号头
            [_dict setObject:@"" forKey:@"文号年"];         // 文号年
            
            [_dict setObject:@"" forKey:@"文号字"];         // 文号字
            [_dict setObject:@"" forKey:@"标题"];           // 标题
            
            [_dict setObject:@"" forKey:@"签发日期起"];     // 交办时间(开始)
            [_dict setObject:@"" forKey:@"签发日期止"];     // 交办时间(结束)
        }
        else
        {
            [_dict setObject:@"" forKey:@"流水号"];          // 收文流水号
            [_dict setObject:@"" forKey:@"缓急"];           // 文件缓急
            
            [_dict setObject:@"" forKey:@"文号头"];         // 文号头
            [_dict setObject:@"" forKey:@"文号年"];         // 文号年
            
            [_dict setObject:@"" forKey:@"文号数"];         // 文号数
            [_dict setObject:@"" forKey:@"标题"];           // 标题
            
            [_dict setObject:@"" forKey:@"来文单位"];        // 来文单位
            [_dict setObject:@"" forKey:@"成文时间开始"];     //
            [_dict setObject:@"" forKey:@"成文时间结束"];     //
        }
    }
    
    return _dict;
}


@end
