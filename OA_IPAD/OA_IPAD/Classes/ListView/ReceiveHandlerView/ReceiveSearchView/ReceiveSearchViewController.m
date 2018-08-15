#import "ReceiveSearchViewController.h"
#import "SendHandlerCell.h"
#import "UIImage+EasyExtend.h"
#import "UIColor+Scheme.h"
#import "UIColor+color.h"
#import "UIColor+EasyExtend.h"
#import "MBProgressHUD+LCL.h"
#import "QuickHandleView.h"
#import <MJRefresh/MJRefresh.h>
#import "ReceiveFileHandleListViewModel.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface ReceiveSearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDelegate, UITableViewDataSource, SendHandlerCellDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ReceiveSearchViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    //    self.navigationItem.leftBarButtonItem = nil;
    //    self.navigationItem.hidesBackButton = YES;
    self.fd_interactivePopDisabled = YES; //禁用侧滑
    self.view.backgroundColor = ViewColor;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self addSearchBar];
    [self initTableView];
}

- (void)addSearchBar
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor colorWithHex:0x3D98FF];
    [self.view addSubview:topView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 44)];
    [topView addSubview:searchBar];
    searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:searchBar.bounds.size];
    searchBar.delegate = self;
    _searchBar = searchBar;
    [searchBar setShowsCancelButton:YES];
    
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    
    //修改标题和标题颜色
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_searchBar becomeFirstResponder];
    _searchBar.placeholder = @"输入文件标题、流水号搜索";
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
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

#pragma mark - search bar callbacks

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    self.viewModel.searchType = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)cancel:(id)sender {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
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
                                                                           @"SWBH" : @"",        // 收文流水号
                                                                           @"HJ" : @"",          // 文件缓急
                                                                           @"WHT" : @"",         // 文号头
                                                                           @"WHN" : @"",         // 文号年
                                                                           @"WHS" : @"",         // 文号数
                                                                           @"Title" : @"",       // 标题
                                                                           @"ZTC" : @"",         // 主题词
                                                                           @"LWDW" : @"",        // 来文单位
                                                                           @"LWDWLB" : @"",      // 来文单位类别编号
                                                                           @"MJ" : @"",          // 文件密级
                                                                           @"WZ" : @"",          // 文种
                                                                           @"GLML" : @"",        // 归类目录
                                                                           @"RecKSName" : @"",   // 主办科室名
                                                                           @"JBTime_S" : @"",    // 交办时间(开始)
                                                                           @"JBTime_E" : @""}];  // 交办时间(结束)
    
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

- (ReceiveFileHandleListViewModel *)viewModel
{
    if(_viewModel == nil)
    {
        _viewModel = [ReceiveFileHandleListViewModel new];
    }
    
    return _viewModel;
}

@end
