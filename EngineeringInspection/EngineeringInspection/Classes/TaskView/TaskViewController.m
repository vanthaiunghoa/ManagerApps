#import "TaskViewController.h"
#import "NSString+extension.h"
#import "UrlManager.h"
#import "UserManager.h"
#import "UserModel.h"
#import "ZLImageTextButton.h"
#import <FTPopOverMenu.h>
#import "TaskCell.h"
#import "TaskModel.h"
#import "TaskDetailViewController.h"
#import "UIColor+color.h"

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ZLImageTextButton *btnProject;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"";
    [self setupLeftNavBtn:@"万维博通大厦"];
    [self setupRightNavBtn:@"全部同步"];
    
    [self initTableView];
//    [self loginWebService];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_tableView registerClass:[TaskCell class] forCellReuseIdentifier:NSStringFromClass([TaskCell class])];
}

#pragma mark - nav item
- (void)setupLeftNavBtn:(NSString *)projectName
{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutClicked:)];
    
    CGFloat width = [NSString calculateRowWidth:44 string:projectName fontSize:ZLFontSize] + ImageWidth + ImageTextDistance;
    
    _btnProject = [ZLImageTextButton buttonWithType:UIButtonTypeCustom];
    _btnProject.zlButtonType = ZLImageRightTextLeft;
    [_btnProject setImage:[UIImage imageNamed:@"white-arrow-down"] forState:UIControlStateNormal];
    [_btnProject setTitle:projectName forState:UIControlStateNormal];
    [_btnProject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnProject.frame = CGRectMake(0, 0, width, 44);
//    [self.view addSubview:_btnProject];
    
    [_btnProject addTarget:self action:@selector(projectClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btnProject];
}

- (void)setupRightNavBtn:(NSString *)name
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:self action:@selector(allSynchronizationClicked:)];
   
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

#pragma mark - clicked

- (void)allSynchronizationClicked:(UIButton *)sender
{
    PLog(@"right clicked");
}

- (void)projectClicked:(UIButton *)sender
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = SCREEN_WIDTH - 8.0;
    configuration.textColor = [UIColor colorWithRGB:28 green:120 blue:255];
    configuration.menuRowHeight = 44;
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor darkGrayColor];
    
    NSMutableArray *projects = [NSMutableArray array];
    [projects addObject:@"万维博通大厦"];
    [projects addObject:@"万维博通大厦一二"];
    [projects addObject:@"万维博通大厦三四五"];
    [projects addObject:@"万维博通大"];
    [projects addObject:@"万维博通大厦六"];
    [projects addObject:@"万维博通大厦八九十十一"];
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:projects
                       doneBlock:^(NSInteger selectedIndex)
                       {
                           NSString *text = projects[selectedIndex];
                           if(text.length != _btnProject.titleLabel.text.length)
                           {
                               [_btnProject removeFromSuperview];
                               [self setupLeftNavBtn:text];
                           }
                           else
                           {
                               [_btnProject setTitle:text forState:UIControlStateNormal];
                           }
                       }
                    dismissBlock:^{
                           NSLog(@"user canceled. do nothing.");
                       }];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaskCell class])];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TaskDetailViewController *vc = [[TaskDetailViewController alloc] init];
    vc.selectIndex = 1;
//    vc.title = key;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - datas

- (void)loginWebService
{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"验证中，请稍等..."];
    
    NSString *password = [[UrlManager sharedUrlManager] getPassword];
    password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    password = [NSString urlEncode:password];
    PLog(@"password == %@", password);
    
    UserModel *model = [[UserManager sharedUserManager] getUserModel];
    
    NSString *soapMsg = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\" ?>"
                          "<REQUEST>"
                          "<USER>%@</USER>"
                          "<PASSWORD>%@</PASSWORD>"
                          "<SP_ID>%@</SP_ID>"
                          "</REQUEST>", model.username, password, [[UrlManager sharedUrlManager] getSPID]];
    PLog(@"soapMsg == %@", soapMsg);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60;
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapMsg.length] forHTTPHeaderField:@"Content-Length"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error)
     {
         return soapMsg;
     }];

    [manager POST:[[UrlManager sharedUrlManager] getSingleUrl] parameters:soapMsg success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        self.view.userInteractionEnabled = YES;
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        PLog(@"result == %@", result);
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLog(@"error == @%", error.userInfo);
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}


@end
