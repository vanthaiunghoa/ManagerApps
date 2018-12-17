#import "VPNSettingViewController.h"
#import "VPNSettingView.h"
#import "UserModel.h"
#import "UserManager.h"
#import "UIColor+color.h"
#import <MessageUI/MFMessageComposeViewController.h>
//#import <UINavigationController+FDFullscreenPopGesture.h>

@interface VPNSettingViewController()<VPNSettingViewDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) VPNSettingView *vpnSettingView;

@end

@implementation VPNSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.fd_prefersNavigationBarHidden = YES;
}

- (void)loadView
{
    _vpnSettingView = [[VPNSettingView alloc]init];
    _vpnSettingView.delegate = self;
    [_vpnSettingView reloadData];
    self.view = _vpnSettingView;
    self.view.backgroundColor = [UIColor colorWithRGB:227 green:243 blue:254];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - VPNSettingViewDelegate

- (void)didClickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickGetPassword
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        // 设置短信内容
        vc.body = @"mm";
        // 设置收件人列表
        vc.recipients = @[@"106350123333777"];  // 号码数组
        // 设置代理
        vc.messageComposeDelegate = self;
        // 显示控制器
        [self presentViewController:vc animated:YES completion:nil];
    }
}
    
#pragma mark - MFMessageComposeViewControllerDelegate
    
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
    {
        PLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        PLog(@"Message sent");
        [SVProgressHUD showInfoWithStatus:@"发送成功"];
        [_vpnSettingView countDown];
    }
    else
    {
        PLog(@"Message failed");
        [SVProgressHUD showInfoWithStatus:@"发送失败"];
    }
}

@end
