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
    [bkg_top makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"智慧政务管理平台";
    titleLab.textColor = [UIColor colorWithHexString:@"#FAF90B"];
    titleLab.font = [UIFont systemFontOfSize:34];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self).with.offset(H(106));
    }];
    
    UILabel *welcomeCNLab = [UILabel new];
    welcomeCNLab.text = @"欢迎使用VPN接入系统";
    welcomeCNLab.textColor = [UIColor whiteColor];
    welcomeCNLab.font = [UIFont systemFontOfSize:22];
    welcomeCNLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeCNLab];
    [welcomeCNLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(titleLab.bottom).offset(H(35));
    }];

    UILabel *welcomeENLab = [UILabel new];
    welcomeENLab.text = @"Welcome to the VPN access system";
    welcomeENLab.textColor = [UIColor whiteColor];
    welcomeENLab.font = [UIFont systemFontOfSize:14];
    welcomeENLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeENLab];
    [welcomeENLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(welcomeCNLab.bottom).offset(H(6));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"#406CBA"];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bkg_top.bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(0.5)));
    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor whiteColor];
    [self addSubview:usernameBkg];
    [usernameBkg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(60)));
    }];

    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"vpn_user"];
    [usernameBkg addSubview:userIcon];
    [userIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.centerY);
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
    [self.accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(usernameBkg);
        make.left.equalTo(userIcon.right).with.offset(W(10));
        make.right.equalTo(usernameBkg.right).offset(W(-22.5));
    }];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHexString:@"#999"];
    [self addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usernameBkg.bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(0.5)));
    }];

    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor whiteColor];
    [self addSubview:passwordBkg];
    [passwordBkg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.bottom).with.offset(0);
        make.left.right.width.height.equalTo(usernameBkg);
    }];

    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"vpn_password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon makeConstraints:^(MASConstraintMaker *make) {
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
    [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.width.height.equalTo(self.accountTextField);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"#999"];
    [self addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordBkg.bottom).with.offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(0.5)));
    }];
    
    UILabel *useLab = [UILabel new];
    useLab.text = @"启用";
    useLab.textColor = [UIColor blackColor];
    useLab.font = [UIFont systemFontOfSize:18];
    [self addSubview:useLab];
    [useLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(W(22.5)));
        make.top.equalTo(line2.bottom).with.offset(H(20));
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
    [self.useBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(useLab.right).with.offset(W(17.5));
        make.centerY.equalTo(useLab.centerY);
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
    [self.unuseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBtn.right).with.offset(W(75));
        make.centerY.equalTo(self.useBtn.centerY);
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
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.unuseBtn.bottom).with.offset(H(20));
        make.left.equalTo(self).offset(@(W(22.5)));
        make.right.equalTo(self).offset(@(W(-22.5)));
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
