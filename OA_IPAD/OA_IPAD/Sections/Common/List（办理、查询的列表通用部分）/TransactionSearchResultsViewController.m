//
//  TransactionSearchResultsViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/13.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "TransactionSearchResultsViewController.h"
#import "SendHandlerCell.h"
#import "SendRetrievalCell.h"
#import "ReceiveRetrievalCell.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "UIColor+color.h"

@interface TransactionSearchResultsViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SendHandlerCellDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSString *searchText;

@end

@implementation TransactionSearchResultsViewController

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
    if([self.title isEqualToString:@"收文检索"])
    {
        [self.tableView registerClass:[ReceiveRetrievalCell class] forCellReuseIdentifier:NSStringFromClass([ReceiveRetrievalCell class])];
    }
    else if([self.title isEqualToString:@"发文检索"])
    {
        [self.tableView registerClass:[SendRetrievalCell class] forCellReuseIdentifier:NSStringFromClass([SendRetrievalCell class])];
    }
    else
    {
        [self.tableView registerClass:[SendHandlerCell class] forCellReuseIdentifier:NSStringFromClass([SendHandlerCell class])];
    }
}

#pragma mark - search bar callbacks

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"code CONTAINS %@", searchText];
//    NSArray *resuts = [self.viewModel.models filteredArrayUsingPredicate:pre];
//    if ([resuts count] == 0)  {
//        pre = [NSPredicate predicateWithFormat:@"title CONTAINS %@", searchText];
//        resuts = [self.viewModel.models filteredArrayUsingPredicate:pre];
//    }
//    self.searchItems = resuts;
//    [self.tableView reloadData];
    
    self.searchText = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"code CONTAINS %@", self.searchText];
    NSArray *resuts = [self.viewModel.models filteredArrayUsingPredicate:pre];
    if ([resuts count] == 0)  {
        pre = [NSPredicate predicateWithFormat:@"title CONTAINS %@", self.searchText];
        resuts = [self.viewModel.models filteredArrayUsingPredicate:pre];
    }
    self.searchItems = resuts;
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
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

#pragma mark - SendHandlerCellDelegate

- (void)approval:(NSIndexPath *)indexPath
{
    NSInteger index = [self.viewModel.models indexOfObject:self.searchItems[indexPath.row]];
    UIViewController *next = [self.viewModel touchTitleNextViewControllerWithIndex:index];
    if (next) {
        [_searchBar resignFirstResponder];
        [self.navigationController pushViewController:next animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.title isEqualToString:@"收文检索"])
    {
        ReceiveRetrievalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReceiveRetrievalCell class])];
        id<ListCellDataSource> dataSource = self.searchItems [indexPath.row];
        cell.model = dataSource;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    else if([self.title isEqualToString:@"发文检索"])
    {
        SendRetrievalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendRetrievalCell class])];
        id<ListCellDataSource> dataSource = self.searchItems [indexPath.row];
        cell.model = dataSource;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;
    }
    else
    {
        SendHandlerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendHandlerCell class])];
        id<ListCellDataSource> dataSource = self.searchItems [indexPath.row];
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
        id<ListCellDataSource> model = self.searchItems [indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
    else if([self.title isEqualToString:@"发文检索"])
    {
        Class currentClass = [SendRetrievalCell class];
        id<ListCellDataSource> model = self.searchItems [indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
    else
    {
        Class currentClass = [SendHandlerCell class];
        id<ListCellDataSource> model = self.searchItems [indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]] + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = [self.viewModel.models indexOfObject:self.searchItems[indexPath.row]];
    UIViewController *next = [self.viewModel touchButtonNextViewControllerWithIndex:index];
    if (next) {
        [_searchBar resignFirstResponder];
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

@end
