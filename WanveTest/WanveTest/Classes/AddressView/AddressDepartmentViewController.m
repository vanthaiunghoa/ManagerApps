//
//  AddressDepartmentViewController.m
//  WanveTest
//
//  Created by wanve on 2018/1/23.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "AddressDepartmentViewController.h"
#import "AddressModel.h"
#import "AddressDetailViewController.h"
#import "DepartmentCell.h"

@interface AddressDepartmentViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchDatas;
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation AddressDepartmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _departmentModel.KSName;
    self.view.backgroundColor = [UIColor whiteColor];
    _isSearch = NO;
    _searchDatas = [[NSMutableArray alloc]init];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)initView
{
    float y = 0;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 44)];
    searchBar.placeholder = @"请输入姓名进行筛选...";
    searchBar.delegate = self;
    searchBar.barStyle =  UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
//    searchBar
    [self.view addSubview:searchBar];
    
    y += searchBar.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DepartmentCell class] forCellReuseIdentifier:NSStringFromClass([DepartmentCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isSearch)
    {
        return _searchDatas.count;
    }
    else
    {
        return _departmentModel.UserList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DepartmentCell class])];
    if(_isSearch)
    {
        cell.model = _searchDatas[indexPath.row];
    }
    else
    {
        cell.model = _departmentModel.UserList[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AddressDetailViewController *vc = [AddressDetailViewController new];
    UserListModel *model = nil;
    if(_isSearch)
    {
        model = _searchDatas[indexPath.row];
    }
    else
    {
        model = _departmentModel.UserList[indexPath.row];
    }
    model.kSName = _departmentModel.KSName;
    vc.userListModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        _isSearch = NO;
    }
    else
    {
        _isSearch = YES;
        [_searchDatas removeAllObjects];
        for(UserListModel *model in _departmentModel.UserList)
        {
            if([model.UserName containsString:searchText])
            {
                [_searchDatas addObject:model];
            }
        }
    }

    [self.tableView reloadData];
}


@end
