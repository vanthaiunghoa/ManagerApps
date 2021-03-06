#import "VPNSettingView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "UserModel.h"
#import "UserManager.h"

@interface VPNSettingView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *accountTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *useBtn;
@property (nonatomic, strong) UIButton *unuseBtn;

@end

@implementation VPNSettingView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIImageView *bkg_top = [UIImageView new];
    bkg_top.image = [UIImage imageNamed:@"vpn_top"];
    [self addSubview:bkg_top];
    [bkg_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"智慧政务管理平台";
    titleLab.textColor = [UIColor colorWithHexString:@"#FAF90B"];
    titleLab.font = [UIFont systemFontOfSize:34];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).with.offset(H(106));
    }];
    
    UILabel *welcomeCNLab = [UILabel new];
    welcomeCNLab.text = @"欢迎使用VPN接入系统";
    welcomeCNLab.textColor = [UIColor whiteColor];
    welcomeCNLab.font = [UIFont systemFontOfSize:22];
    welcomeCNLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeCNLab];
    [welcomeCNLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(titleLab.mas_bottom).offset(H(35));
    }];

    UILabel *welcomeENLab = [UILabel new];
    welcomeENLab.text = @"Welcome to the VPN access system";
    welcomeENLab.textColor = [UIColor whiteColor];
    welcomeENLab.font = [UIFont systemFontOfSize:14];
    welcomeENLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeENLab];
    [welcomeENLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(welcomeCNLab.mas_bottom).offset(H(6));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"#406CBA"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bkg_top.mas_bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(0.5)));
    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor whiteColor];
    [self addSubview:usernameBkg];
    [usernameBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(60)));
    }];

    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"vpn_user"];
    [usernameBkg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.mas_centerY);
        make.left.equalTo(@(W(22.5)));
        make.width.height.equalTo(@(W(20)));
    }];

    self.accountTextField = [UITextField new];
    self.accountTextField.placeholder = @"请输入vpn账号";
    self.accountTextField.textColor = [UIColor blackColor];
    self.accountTextField.font = [UIFont systemFontOfSize:18];
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTextField.clearsOnBeginEditing = NO;
    self.accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.accountTextField.returnKeyType = UIReturnKeyNext;
    self.accountTextField.delegate = self;
    [usernameBkg addSubview:self.accountTextField];
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(usernameBkg);
        make.left.equalTo(userIcon.mas_right).with.offset(W(10));
        make.right.equalTo(usernameBkg.mas_right).offset(W(-22.5));
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"#999"];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usernameBkg.mas_bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(0.5)));
    }];

    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor whiteColor];
    [self addSubview:passwordBkg];
    [passwordBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).with.offset(0);
        make.left.right.width.height.equalTo(usernameBkg);
    }];

    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"vpn_password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.width.height.equalTo(@(W(20)));
        make.left.equalTo(@(W(22.5)));
    }];

    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入vpn密码";
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.width.height.equalTo(self.accountTextField);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"#999"];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordBkg.mas_bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(0.5)));
    }];
    
    UILabel *useLab = [UILabel new];
    useLab.text = @"启用";
    useLab.textColor = [UIColor blackColor];
    useLab.font = [UIFont systemFontOfSize:18];
    [self addSubview:useLab];
    [useLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(W(22.5)));
        make.top.equalTo(line2.mas_bottom).with.offset(H(20));
    }];

    self.useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.useBtn setTitle:@"是" forState:UIControlStateNormal];
    [self.useBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.useBtn setImage:[UIImage imageNamed:@"unuse"] forState:UIControlStateNormal];
    [self.useBtn setImage:[UIImage imageNamed:@"use"] forState:UIControlStateSelected];
    self.useBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    self.useBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
    [self.useBtn addTarget:self action:@selector(useClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.useBtn];
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(useLab.mas_right).with.offset(W(17.5));
        make.centerY.equalTo(useLab.mas_centerY);
    }];

    self.unuseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.unuseBtn setTitle:@"否" forState:UIControlStateNormal];
    [self.unuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.unuseBtn setImage:[UIImage imageNamed:@"unuse"] forState:UIControlStateNormal];
    [self.unuseBtn setImage:[UIImage imageNamed:@"use"] forState:UIControlStateSelected];
    self.unuseBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    self.unuseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
    [self.unuseBtn addTarget:self action:@selector(unuseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.unuseBtn];
    [self.unuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBtn.mas_right).with.offset(W(75));
        make.centerY.equalTo(self.useBtn.mas_centerY);
    }];

    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"返 回" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:W(20)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3399FE"]] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.unuseBtn.mas_bottom).with.offset(H(20));
        make.left.equalTo(self).offset((W(22.5)));
        make.right.equalTo(self).offset((W(-22.5)));
        make.height.equalTo(@(H(40)));
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
