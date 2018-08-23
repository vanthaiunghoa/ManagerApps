#import "HomeViewController.h"
#import "HomeCell.h"
#import "NSString+extension.h"
#import "UrlManager.h"
#import "UIImage+image.h"
#import "UserManager.h"
#import "UserModel.h"
#import "KxMenu.h"
#import "UIColor+color.h"
#import "CommonPickerView.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, CommonPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = TITLE;
    self.view.backgroundColor = ViewColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self setTitle];
    
    // 盐田
//    self.openType = @"pro_oicinfo";
    [self setupNavBtn];
    [self initView];
    
//    [self loginWebService];
}

- (void)initView
{
    UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, 118)];
    [self.view addSubview:bkgView];
    bkgView.backgroundColor = [UIColor whiteColor];
    
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat margin = 20;
    CGFloat btnW = (SCREEN_WIDTH - 2.0*x - margin)/2.0;
    
    NSArray *arr = @[@"选择科室", @"选择进度"];
    for(int i = 0; i < arr.count; ++i)
    {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [bkgView addSubview:btn];
        btn.backgroundColor = [UIColor colorWithRGB:233 green:233 blue:233];
        btn.tag = i;
        btn.frame = CGRectMake(x, y, btnW, 44);
        
        [btn addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, btnW - 25, 44)];
        [btn addSubview:lab];
        lab.text = arr[i];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textColor = [UIColor blackColor];
        
        UIView *right = [[UIView alloc] initWithFrame:CGRectMake(btnW - 15, 0, 15, 44)];
        [btn addSubview:right];
        right.backgroundColor = [UIColor colorWithRGB:181 green:181 blue:181];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 17, 10, 10)];
        [right addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"small-arrow-down"];
        
        x += btnW + margin;
    }
    
    y += 54;
    x = 10;
    UIView *textFieldBkg = [[UIView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - 2.0*x, 44)];
    [bkgView addSubview:textFieldBkg];
    textFieldBkg.backgroundColor = ViewColor;

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 2.0*x - 64, 44)];
    [textFieldBkg addSubview:textField];
    textField.placeholder = @"输入检索条件";
    textField.textColor = [UIColor grayColor];
    textField.font = [UIFont systemFontOfSize:16];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.textField = textField;

    UIButton *btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2.0*x - 44, 0, 44, 44)];
    [textFieldBkg addSubview:btnSearch];
    [btnSearch setBackgroundColor:[UIColor colorWithRGB:245 green:245 blue:245]];
    [btnSearch setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];

    [btnSearch addTarget:self action:@selector(searchClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat topHeight = IS_IPHONEX ? 88 : 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT + 118, SCREEN_WIDTH, SCREEN_HEIGHT - self.navigationController.toolbar.frame.size.height - 118 - topHeight)];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = ViewColor;
    
    [self.tableView registerClass:[HomeCell class] forCellReuseIdentifier:NSStringFromClass([HomeCell class])];
}

- (void)setTitle
{
//    NSString *title = TITLE;
//    UILabel *labTitle = [UILabel new];
//    [labTitle setText:title];
//    [labTitle setFont:[UIFont systemFontOfSize:16]];
//    self.navigationItem.titleView = labTitle;
}

#pragma mark - click

- (void)selectClicked:(UIButton *)sender
{
    NSArray *arr = @[@"测试1", @"测试2", @"测试3", @"测试4"];
    
    CommonPickerView *pickerView = [[CommonPickerView alloc] initWithArrayData:arr xlsn0wDelegate:self];
    [pickerView show];
}

- (void)searchClicked:(UIButton *)sender
{
    PLog(@"search == %@", self.textField.text);
}

#pragma mark - CommonPickerViewDelegate

- (void)pickerSingler:(CommonPickerView *)pickerSingler selectedTitle:(NSString *)selectedTitle selectedRow:(NSInteger)selectedRow
{

}

#pragma mark - 示例代码
#pragma mark UITableView + 下拉刷新 默认
- (void)refresh
{
//    //    __weak __typeof(self) weakSelf = self;
//
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //        [weakSelf loadNewData];
//        _page = 1;
//        [self download:_page];
//    }];
//
//    // 马上进入刷新状态
//    [self.tableView.mj_header beginRefreshing];
}

#pragma mark UITableView + 上拉刷新 默认
- (void)loadMore
{
//    [self refresh];
//
//    __weak __typeof(self) weakSelf = self;
//
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadMoreData];
//    }];
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
//    // 1.添加假数据
//    //    for (int i = 0; i<5; i++) {
//    //        [self.data insertObject:MJRandomData atIndex:0];
//    //    }
//
//    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//    __weak UITableView *tableView = self.tableView;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [tableView reloadData];
//
//        // 拿到当前的下拉刷新控件，结束刷新状态
//        [tableView.mj_header endRefreshing];
//    });
}

- (void)download:(NSInteger)page
{
//    self.view.userInteractionEnabled = NO;
//    [SVProgressHUD showWithStatus:@"数据加载中，请稍等..."];
//
//    //1.创建一个请求管理者
//    //AFHTTPRequestOperationManager内部封装了URLSession
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//
//    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
//    // 2.发送请求
//
//    //    NSString *str = [NSString stringWithFormat:@"{\"ActiveCode\":\"%@\"}", userModel.activeCode];
//    //    NSString *receive = @"收文";
//    NSString *str = [NSString stringWithFormat:@"{\"ActiveCode\":\"%@\",\"PageSize\":\"10\",\"PageNum\":\"%zd\",\"BLSate\":\"ALL\"}", userModel.activeCode, self.page];
//    NSDictionary *dict = @{
//                           @"Action":@"GetSWHandleList_BLState",
//                           @"jsonRequest":str
//                           };
//    PLog(@"dict == %@", dict);
//
//    NSString *url = @"http://202.104.110.143:8009/oasystem/Handlers/DMS_FileMan_Handler.ashx?";
//
//    [manager POST:url parameters: dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        self.view.userInteractionEnabled = YES;
//        [SVProgressHUD dismiss];
//        // 转码
//        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        NSString* utf8Str = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:gbkEncoding];
//        PLog(@"utf8Str == %@", utf8Str);
//        NSData *data = [utf8Str dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//        NSNumber *isSuccess = dict[@"IsSuccess"];
//        PLog(@"isSuccess == %@", isSuccess);
//        NSNumber *num = [NSNumber numberWithInt:1];
//        if([isSuccess isEqualToNumber:num])
//        {
//            if(1 == self.page)
//            {
//                _modelsArray = [ReceiveModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
//            }
//            else
//            {
//                NSMutableArray *tmp = [ReceiveModel mj_objectArrayWithKeyValuesArray:dict[@"Datas"]];
//                [_modelsArray addObject:tmp];
//            }
//        }
//        else
//        {
//            NSString *mes = dict[@"Status"];
//            [SVProgressHUD showErrorWithStatus:mes];
//        }
//
//        [self.tableView reloadData];
//        if(1 == _page)
//        {
//            [self.tableView.mj_header endRefreshing];
//        }
//        else
//        {
//            [self.tableView.mj_footer endRefreshing];
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        self.view.userInteractionEnabled = YES;
//        PLog(@"请求失败--%@",error);
//        [SVProgressHUD showInfoWithStatus:@"网络异常"];
//    }];
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
//    ++_page;
//    [self download:_page];
}

#pragma mark 加载最后一份数据
- (void)loadLastData
{
//    // 1.添加假数据
//    //    for (int i = 0; i<5; i++) {
//    //        [self.data addObject:MJRandomData];
//    //    }
//
//    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//    __weak UITableView *tableView = self.tableView;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [tableView reloadData];
//
//        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
//        [tableView.mj_footer endRefreshingWithNoMoreData];
//    });
}

#pragma mark - nav item
- (void)setupNavBtn
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutClicked:)];
}

#pragma mark - clicked

- (void)logoutClicked:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"切换账号"
                     image:nil
                    target:self
                    action:@selector(switchClicked:)],
      
      [KxMenuItem menuItem:@"退出"
                     image:nil
                    target:self
                    action:@selector(exitClicked:)],
      ];
    
    for(KxMenuItem *item in menuItems)
    {
        item.alignment = NSTextAlignmentCenter;
    }
    
    CGRect frame = CGRectMake(6, TOP_HEIGHT - 44, 44, 44);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)switchClicked:(id)sender
{
    [[UserManager sharedUserManager] logout];
}

- (void)exitClicked:(id)sender
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0)
    {
        //退出
        exit(0);
    }
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCell class])];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    MeetingsInfo *info = self.otherMeetings[indexPath.row];
    cell.flowName = @"hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试hello测试测试测试";

//    if(indexPath.row == self.otherMeetings.count - 1)
//    {
//        cell.isHiddenLine = YES;
//    }
//    else
//    {
//        cell.isHiddenLine = NO;
//    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MeetingsInfo *other = self.otherMeetings[indexPath.row];
//    MeetingViewController *vc = [[MeetingViewController alloc] init];
//    vc.identifier = other.MM_SNID;
//    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[NSClassFromString(@"IndexViewController") new] animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}


@end
