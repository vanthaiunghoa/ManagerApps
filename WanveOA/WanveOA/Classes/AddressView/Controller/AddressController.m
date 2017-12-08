#import "AddressController.h"
#import "AFNetworking.h"
#import "AddressModel.h"
#import "PersonModel.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"

@interface AddressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *flagArray;

@end

@implementation AddressController

- (NSMutableArray *)sectionArray
{
    if(self.sectionArray == nil)
    {
        self.sectionArray = [NSMutableArray array];
    }
    
    return self.sectionArray;
}

- (NSMutableArray *)flagArray
{
    if(self.flagArray == nil)
    {
        self.flagArray = [NSMutableArray array];
    }
    
    return self.flagArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通讯录";
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.backgroundColor = UIColor.whiteColor;
//    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:246 green:246 blue:246 alpha:1];
    [self.view addSubview:self.tableView];
    
    [self get];
//    [self makeData];
}

-(void)get
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    //    NSDictionary *dict = @{
    //                           @"UserID":@"cwq",
    //                           @"UserPsw":@"123456"
    //                           };
//    NSString *str = [NSString stringWithFormat:@"%@%@%%@", @"http://121.15.203.82:9210/DMS_Phone/Contact/ContactHandler.ashx?Action=GetContactByUserID&para={UserID:'cwq'}", username, @"'}"];
   
    NSString *str = [NSString stringWithFormat:@"%@", @"http://121.15.203.82:9210/DMS_Phone/Contact/ContactHandler.ashx?Action=GetContactByUserID&para={UserID:'cwq'}"];
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlStr parameters: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        PLog(@"请求成功--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSArray *dictM = dict;
        _sectionArray = [AddressModel objectArrayWithKeyValuesArray:dict];

        _flagArray = [NSMutableArray array];
        for (int i = 0; i < _sectionArray.count; i ++)
        {
            [_flagArray addObject:@"0"];
        }
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        PLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArray.count;
}

//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLabel = [[UILabel alloc] init];
//    sectionLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 44);
//    sectionLabel.textColor = [UIColor redColor];
    
    AddressModel *address = _sectionArray[section];
    
    sectionLabel.text = [NSString stringWithFormat:@"  %@", address.KSName];
    sectionLabel.textAlignment = NSTextAlignmentLeft;
    sectionLabel.tag = 100 + section;
    sectionLabel.userInteractionEnabled = YES;
    sectionLabel.backgroundColor = [UIColor colorWithRed:235 green:235 blue:241 alpha:1];
//    sectionLabel.backgroundColor = UIColor.whiteColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [sectionLabel addGestureRecognizer:tap];
    
    return sectionLabel;
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
//组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_flagArray[indexPath.section] isEqualToString:@"0"])
        return 0;
    else
        return 44;
}

//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *arr = _sectionArray[section];
//    return arr.count;
    AddressModel *address = _sectionArray[section];
    return address.UserList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    AddressModel *address = _sectionArray[indexPath.section];
    NSArray *Persons = [PersonModel objectArrayWithKeyValuesArray:address.UserList];
    PersonModel *person = Persons[indexPath.row];
    cell.textLabel.text = person.UserName;
    
    cell.clipsToBounds = YES; //这句话很重要
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PLog(@"%@",[NSString stringWithFormat:@"第%ld组的第%ld个cell",(long)indexPath.section,(long)indexPath.row]);
//    PLog(@"%@", _sectionArray[indexPath.section]);
}

//手势点击事件
- (void)sectionClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag % 100;
    
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    
    AddressModel *address = _sectionArray[index];
    NSArray *Persons = [PersonModel objectArrayWithKeyValuesArray:address.UserList];
    
    for (int i = 0; i < Persons.count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:index];
        [indexArray addObject:path];
    }
    
    if ([_flagArray[index] isEqualToString:@"0"]) {//展开
        _flagArray[index] = @"1";
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];  //使用下面注释的方法就 注释掉这一句
    } else { //收起
        _flagArray[index] = @"0";
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop]; //使用下面注释的方法就 注释掉这一句
    }
    
    //  NSRange range = NSMakeRange(index, 1);
    //  NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    //  [_tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



@end
