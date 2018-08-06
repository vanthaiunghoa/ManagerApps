#import "VPNSettingView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "UserModel.h"
#import "UserManager.h"

#define TIMECOUNT 60

@interface VPNSettingView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *accountTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *useBtn;
@property (nonatomic, strong) UIButton *unuseBtn;
@property (nonatomic, strong) UIButton *getPassword;

@end

@implementation VPNSettingView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIImageView *bkg_top = [UIImageView new];
    bkg_top.image = [UIImage imageNamed:@"vpn-top"];
    [self addSubview:bkg_top];
    [bkg_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@485);
    }];
    
    UIView *bottomView = [UIView new];
    [bottomView setBackgroundColor:[UIColor colorWithRGB:227 green:243 blue:254]];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(370);
        make.left.right.bottom.equalTo(self);
    }];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"万维博通智慧办公平台";
//    titleLab.text = @"移动办公系统";
//    titleLab.text = @"智慧办公系统";
    titleLab.textColor = [UIColor colorWithRGB:249 green:248 blue:11];
    titleLab.font = [UIFont systemFontOfSize:58];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(90);
    }];
    
    UILabel *welcomeCNLab = [UILabel new];
    welcomeCNLab.text = @"欢迎使用VPN接入系统";
    welcomeCNLab.textColor = [UIColor whiteColor];
    welcomeCNLab.font = [UIFont systemFontOfSize:45];
    welcomeCNLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeCNLab];
    [welcomeCNLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(35);
    }];

    UILabel *welcomeENLab = [UILabel new];
    welcomeENLab.text = @"Welcome to the VPN access system";
    welcomeENLab.textColor = [UIColor whiteColor];
    welcomeENLab.font = [UIFont systemFontOfSize:29];
    welcomeENLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeENLab];
    [welcomeENLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(welcomeCNLab.mas_bottom).offset(6);
    }];
    
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor colorWithHexString:@"#406CBA"];
//    [self addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bkg_top.mas_bottom).with.offset(0);
//        make.left.right.equalTo(self);
//        make.height.equalTo(@(0.5));
//    }];
    
    self.getPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getPassword setTitle:@"获取动态密码" forState:UIControlStateNormal];
    [self.getPassword addTarget:self action:@selector(getPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.getPassword.layer setMasksToBounds:YES];
    [self.getPassword.layer setCornerRadius:38];
    [self.getPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getPassword.titleLabel.font = [UIFont systemFontOfSize:38];
    [self.getPassword setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:49 green:138 blue:238]] forState:UIControlStateNormal];
    [bottomView addSubview:self.getPassword];
    [self.getPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(30);
        make.left.equalTo(self).offset(48);
        make.right.equalTo(self).offset(-48);
        make.height.equalTo(@78);
    }];
    
    UIView *textFieldBkg = [UIView new];
    textFieldBkg.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:textFieldBkg];
    [textFieldBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getPassword.mas_bottom).with.offset(30);
        make.left.right.equalTo(self);
        make.height.equalTo(@201);
    }];

    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"vpn-user"];
    [textFieldBkg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldBkg.mas_top).offset(30);
        make.left.equalTo(@48);
        make.width.height.equalTo(@40);
    }];

    self.accountTextField = [UITextField new];
    self.accountTextField.placeholder = @"请输入vpn账号";
    self.accountTextField.textColor = [UIColor blackColor];
    self.accountTextField.font = [UIFont systemFontOfSize:37];
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTextField.clearsOnBeginEditing = NO;
    self.accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.accountTextField.delegate = self;
    [textFieldBkg addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldBkg.mas_top);
        make.left.equalTo(userIcon.mas_right).with.offset(20);
        make.right.equalTo(textFieldBkg.mas_right).offset(-48);
        make.height.equalTo(@100);
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithRGB:163 green:163 blue:163];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom);
        make.left.right.equalTo(textFieldBkg);
        make.height.equalTo(@1);
    }];

    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"vpn-password"];
    [textFieldBkg addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(30);
        make.left.equalTo(@51);
        make.width.equalTo(@34);
        make.height.equalTo(@40);
    }];

    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入vpn密码";
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:37];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [textFieldBkg addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(passwordIcon.mas_right).offset(23);
        make.right.equalTo(textFieldBkg.mas_right).offset(-48);
        make.height.equalTo(@100);
    }];
    
//    UIView *line2 = [UIView new];
//    line2.backgroundColor = [UIColor colorWithHexString:@"#999"];
//    [self addSubview:line2];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(passwordBkg.mas_bottom).with.offset(0);
//        make.left.right.equalTo(self);
//        make.height.equalTo(@0.5);
//    }];
    
    UILabel *useLab = [UILabel new];
    useLab.text = @"启用";
    useLab.textColor = [UIColor blackColor];
    useLab.font = [UIFont systemFontOfSize:37];
    [bottomView addSubview:useLab];
    [useLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.getPassword.mas_left);
        make.top.equalTo(textFieldBkg.mas_bottom).offset(30);
    }];

    self.useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.useBtn setTitle:@"是" forState:UIControlStateNormal];
    [self.useBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.useBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.useBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    self.useBtn.titleLabel.font = [UIFont systemFontOfSize:37];
    self.useBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -14);
    [self.useBtn addTarget:self action:@selector(useClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.useBtn];
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(useLab.mas_right).with.offset(38);
        make.centerY.equalTo(useLab.mas_centerY);
    }];

    self.unuseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.unuseBtn setTitle:@"否" forState:UIControlStateNormal];
    [self.unuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.unuseBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [self.unuseBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    self.unuseBtn.titleLabel.font=[UIFont systemFontOfSize:37];
    self.unuseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -14);
    [self.unuseBtn addTarget:self action:@selector(unuseClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.unuseBtn];
    [self.unuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBtn.mas_right).with.offset(163);
        make.centerY.equalTo(self.useBtn.mas_centerY);
    }];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"返 回" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:38];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:38];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:49 green:138 blue:238]] forState:UIControlStateNormal];
    [bottomView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unuseBtn.mas_bottom).with.offset(30);
        make.left.equalTo(self).offset(48);
        make.right.equalTo(self).offset(-48);
        make.height.equalTo(self.getPassword);
    }];
    
    return self;
}

- (void)backClick:(UIButton *)sender
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.vpnAccount = self.accountTextField.text;
    userModel.vpnPassword = self.passwordTextField.text;
    [[UserManager sharedUserManager] saveUserModel:userModel];
    [_delegate didClickBackBtn];
}

- (void)getPasswordClick:(UIButton *)sender
{
    [_delegate didClickGetPassword];
}

- (void)countDown
{
    __block NSInteger second = TIMECOUNT;
    //(1)
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //(2)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //(3)
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //(4)
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                self.getPassword.enabled = YES;
                [self.getPassword setTitle:[NSString stringWithFormat:@"获取动态密码"] forState:UIControlStateNormal];
                second = TIMECOUNT;
                //(6)
                dispatch_cancel(timer);
            } else {
                self.getPassword.enabled = NO;
                [self.getPassword setTitle:[NSString stringWithFormat:@"(%ld)秒后可重新获取",second] forState:UIControlStateNormal];
                second--;
            }
        });
    });
    //(5)
    dispatch_resume(timer);
}

- (void)useClick:(UIButton *)sender
{
    if([self isValid])
    {
        UIButton *btn = (UIButton *)sender;
        btn.selected = YES;
        self.unuseBtn.selected = NO;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isVPNLogin = YES;
        userModel.vpnAccount = self.accountTextField.text;
        userModel.vpnPassword = self.passwordTextField.text;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
}

- (void)unuseClick:(UIButton *)sender
{
    if([self isValid])
    {
        UIButton *btn = (UIButton *)sender;
        btn.selected = YES;
        self.useBtn.selected = NO;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isVPNLogin = NO;
        userModel.vpnAccount = self.accountTextField.text;
        userModel.vpnPassword = self.passwordTextField.text;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
}

- (BOOL)isValid
{
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(account.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入vpn账号"];
        return NO;
    }
    if(password.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入vpn密码"];
        return NO;
    }
    
    return YES;
}

- (void)reloadData
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isVPNLogin)
    {
        self.useBtn.selected = YES;
        self.unuseBtn.selected = NO;
    }
    else
    {
        self.useBtn.selected = NO;
        self.unuseBtn.selected = YES;
    }
    self.accountTextField.text = userModel.vpnAccount;
    self.passwordTextField.text = userModel.vpnPassword;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.accountTextField == textField) {
        if ([self.passwordTextField canBecomeFirstResponder]) {
            [self.passwordTextField becomeFirstResponder];
            return NO;
        }
    }
    
    if (self.passwordTextField == textField) {
        [self.passwordTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldResignFirstResponder
{
    if ([self.accountTextField isFirstResponder])
        [self.accountTextField resignFirstResponder];
    
    if ([self.passwordTextField isFirstResponder])
        [self.passwordTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


@end
