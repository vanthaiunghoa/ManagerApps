#import "VPNSettingViewController.h"
#import "VPNSettingView.h"
#import "UserModel.h"
#import "UserManager.h"

@interface VPNSettingViewController()<VPNSettingViewDelegate>

@property (nonatomic, strong) VPNSettingView *vpnSettingView;

@end

@implementation VPNSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadView
{
    _vpnSettingView = [[VPNSettingView alloc]init];
    _vpnSettingView.delegate = self;
    self.view = _vpnSettingView;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_vpnSettingView reloadData];
}

#pragma mark - VPNSettingViewDelegate

- (void)didClickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
