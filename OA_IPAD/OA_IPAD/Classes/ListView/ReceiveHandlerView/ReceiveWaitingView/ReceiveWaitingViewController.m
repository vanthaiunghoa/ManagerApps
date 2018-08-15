#import "ReceiveWaitingViewController.h"
#import "ReceiveHandlerCell.h"
#import "UIImage+EasyExtend.h"
#import "UIColor+Scheme.h"
#import "UIColor+color.h"
#import "UIColor+EasyExtend.h"
#import "MBProgressHUD+LCL.h"
#import "QuickHandleView.h"
#import <MJRefresh/MJRefresh.h>
#import "ReceiveFileHandleListViewModel.h"

@interface ReceiveWaitingViewController ()<UITableViewDelegate, UITableViewDataSource, ReceiveHandlerCellDelegate>

@property (nonatomic, strong) NSMutableArray *selectedModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ReceiveWaitingViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = ViewColor;
    [self initTableView];
    [self initBottomView];
}

- (void)initTableView
{
    CGFloat topHeight = SCREEN_WIDTH > 768 ? 128 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - topHeight - 55)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    [self.tableView registerClass:[ReceiveHandlerCell class] forCellReuseIdentifier:NSStringFromClass([ReceiveHandlerCell class])];
    
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

- (void)initBottomView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, SCREEN_WIDTH, 64)];
    [btn setImage:[UIImage imageNamed:@"handler"] forState:UIControlStateNormal];
    [btn setTitle:@"快速办理" forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [btn addTarget:self action:@selector(quickHandle:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:22];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x3D98FF]] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

#pragma mark - data flow

- (void)requestDataRefresh:(BOOL)refresh
{
    if(refresh)
    {
        self.currentPage = 1;
        self.viewModel.listItems = [NSMutableArray arrayWithCapacity:10];
    }
    
    NSDictionary *params = [NSMutableDictionary dictionaryWithDictionary:  @{@"PageSize": @10, @"PageNum": @(self.currentPage), @"BLState":@"0"}];
    
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

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ReceiveHandlerCell class];
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

- (NSMutableArray *)selectedModel
{
    if(_selectedModel == nil)
    {
        _selectedModel = [NSMutableArray array];
    }
    return _selectedModel;
}

- (ReceiveFileHandleListViewModel *)viewModel
{
    if(_viewModel == nil)
    {
        _viewModel = [ReceiveFileHandleListViewModel new];
    }
    
    return _viewModel;
}

@end
