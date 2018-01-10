#import "VPNSettingViewController.h"
#import "VPNSettingView.h"
#import "UserModel.h"
#import "UserManager.h"
#import "UIColor+color.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface VPNSettingViewController()<VPNSettingViewDelegate>

@property (nonatomic, strong) VPNSettingView *vpnSettingView;

@end

@implementation VPNSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)loadView
{
    _vpnSettingView = [[VPNSettingView alloc]init];
    _vpnSettingView.delegate = self;
    self.view = _vpnSettingView;
    self.view.backgroundColor = [UIColor colorWithRGB:227 green:243 blue:254];
}

#pragma mark - VPNSettingViewDelegate

- (void)didClickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
