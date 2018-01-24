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

@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *address;

@end

@implementation AddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    
    self.tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[ProjectActivityListCell class] forCellReuseIdentifier:kCellIdentifier_ProjectActivityList];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadDatas];
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
        [SVProgressHUD showSuccessWithStatus:@"加载数据成功"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _address.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    AddressModel *model = _address[indexPath.row];
    cell.textLabel.text = model.KSName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressDepartmentViewController *vc = [AddressDepartmentViewController new];
    vc.departmentModel = _address[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
