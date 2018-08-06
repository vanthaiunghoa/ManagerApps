//
//  TransactionListViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/3/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "TransactionListViewController.h"
#import "UIImage+EasyExtend.h"
#import "UIColor+Scheme.h"
#import "UIColor+color.h"
#import "UIColor+EasyExtend.h"
#import "MBProgressHUD+LCL.h"
#import "TransactionSearchResultsViewController.h"
#import "QuickHandleView.h"
#import <MJRefresh/MJRefresh.h>

@interface TransactionListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickHandleButtonHeight;

@end

@implementation TransactionListViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc ♻️", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.quickHandleButton.hidden = !self.viewModel.shouldShowQuickHandleButton;
    if (self.viewModel.shouldShowQuickHandleButton) {
        // 快速处理开启多选功能
        self.tableView.allowsMultipleSelection = YES;
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    } else {
        self.tableView.allowsSelection = NO;
    }
    self.quickHandleButtonHeight.constant *= (self.viewModel.shouldShowQuickHandleButton);
    
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestDataRefresh:YES];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self _requestDataRefresh:NO];
    }];
    footer.stateLabel.text = @"";
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
    [self _addSearchButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidHandleTask:) name:@"userDidHandleTask" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self _configureNavigationBarWhenAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self _configureNavigationBarWhenAppear];
}

#pragma mark - views
- (void)_configureNavigationBarWhenAppear {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UINavigationBar *bar = self.navigationController.navigationBar;
    [bar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    bar.barTintColor = [UIColor schemeBlue];
}

- (void)_addSearchButton {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"sousuo"];
    [searchButton setImage:image forState:0];
    [searchButton setTintColor:[UIColor whiteColor]];
    [searchButton setTitle:@"查询" forState:0];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    searchButton.frame = CGRectMake(0, 0, 100, 44);
    [searchButton addTarget:self action:@selector(showSearchController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}
#pragma mark - data flow

- (void)_requestDataRefresh:(BOOL)refresh {
    
    NSDictionary *params = @{@"refresh":@(refresh)};
    
    @weakify(self);
    [[[self.viewModel requestListCommand] execute:params] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if ([x count]) {
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError * _Nullable error) {
        @strongify(self);
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud showMessage:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - actions

- (void)handleButton:(id)sender touchedAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *next = [self.viewModel touchButtonNextViewControllerWithIndex:indexPath.row];
    if (next) {
        [self.navigationController pushViewController:next animated:YES];
    }
}
- (IBAction)quickHandle:(id)sender {
    NSArray<NSIndexPath *> *indexPaths = self.tableView.indexPathsForSelectedRows;
    if (indexPaths.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"" atView:nil];
        [hud showMessage:@"没有选中纪录"];
        return;
    }
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:1];
    for (NSIndexPath *indexPath in indexPaths) {
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
            hud.label.text = [NSString stringWithFormat:@"办理进度：%d/%d",(int)finishedCount, (int)indexPaths.count];
        } completed:^{
            @strongify(self);
            [hud showMessage:@"全部处理完毕"];
            NSMutableArray *lefts = [NSMutableArray arrayWithArray: self.viewModel.models];
             [lefts removeObjectsInArray:models];
            self.viewModel.models = lefts;
            [self.tableView reloadData];
        }];
    } fromViewController:self];
}

- (void)handleTitleButton:(id)sender touchedAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *next = [self.viewModel touchTitleNextViewControllerWithIndex:indexPath.row];
    if (next) {
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (void)showSearchController:(id)sender {
    TransactionSearchResultsViewController *vc = [TransactionSearchResultsViewController new];
    vc.viewModel = self.viewModel;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (cell.selected) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = !cell.selected;
    return indexPath;
}

- (void)userDidHandleTask:(NSNotification *)notification {
    [self.tableView.mj_header beginRefreshing];
//    NSString *code = notification.userInfo[@"code"];
//    if (code) {
//        id<ListCellDataSource> foundObject = nil;
//        for (id<ListCellDataSource> listModel in self.viewModel.models) {
//            if ([listModel.code isEqualToString:code]) {
//                foundObject = listModel;
//                break;
//            }
//        }
//        if (foundObject) {
//            NSMutableArray *newModels = [NSMutableArray arrayWithArray:self.viewModel.models];
//            [newModels removeObject:foundObject];
//            self.viewModel.models = newModels;
//            [self.tableView reloadData];
//        }
//    }
}

#pragma mark - table views


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    id<ListCellDataSource> dataSource = self.viewModel.models[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.viewModel respondsToSelector:@selector(nextButtonTitle)]) {
        [cell.handleButton setTitle:self.viewModel.nextButtonTitle forState:0];
    }
    [cell setDataSource:dataSource];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 257;
}
@end
