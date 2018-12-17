//
//  AddressViewController.m
//  WanveTest
//
//  Created by wanve on 2018/1/23.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "AddressViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
#import "AddressModel.h"
#import "AddressDepartmentViewController.h"
#import "AddressCell.h"

@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, strong) NSMutableArray *searchDatas;
@property (nonatomic, assign) BOOL isSearch;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isSearch = NO;
    self.navigationItem.title = @"通讯录";
    self.view.backgroundColor = [UIColor whiteColor];
    _searchDatas = [[NSMutableArray alloc]init];
    
    [self initView];
    [self loadDatas];
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
    searchBar.placeholder = @"请输入部门名字进行筛选...";
    searchBar.delegate = self;
    searchBar.barStyle =  UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.view addSubview:searchBar];
    
    y += searchBar.frame.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AddressCell class] forCellReuseIdentifier:NSStringFromClass([AddressCell class])];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

-(NSArray *)address
{
    if(_address == nil)
    {
        _address = [NSArray array];
    }
    return _address;
}

- (void)loadDatas
{
    [SVProgressHUD showWithStatus:@"加载数据中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
 
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@", [[UrlManager sharedUrlManager] getBaseUrl], @"/Contact/ContactHandler.ashx?Action=GetContactByUserID&para={UserID:'", userModel.username, @"'}"];
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    PLog(@"url == %@", urlStr);
    
    [manager GET:urlStr parameters: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
//        [SVProgressHUD showSuccessWithStatus:@"加载数据成功"];
        [SVProgressHUD dismiss];
        PLog(@"请求成功--%@",responseObject);
        
        _address = [AddressModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
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
        return _address.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressCell class])];
    if(_isSearch)
    {
        cell.model = _searchDatas[indexPath.row];
    }
    else
    {
        cell.model = _address[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AddressDepartmentViewController *vc = [AddressDepartmentViewController new];
    if(_isSearch)
    {
        vc.departmentModel = _searchDatas[indexPath.row];
    }
    else
    {
        vc.departmentModel = _address[indexPath.row];
    }
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
        for(AddressModel *model in _address)
        {
            if([model.KSName containsString:searchText])
            {
                [_searchDatas addObject:model];
            }
        }
    }
    
    [self.tableView reloadData];
}

@end
