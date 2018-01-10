#import "LoginView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "UserModel.h"
#import "UserManager.h"

@interface LoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UIButton *accountBtn;
@property (nonatomic, strong) UIButton *autoLoginBtn;

@end

@implementation LoginView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo_company"];
    [self addSubview:logoIcon];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"智慧政务管理平台";
    titleLab.textColor = [UIColor colorWithHex:0x132E65];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    usernameBkg.layer.cornerRadius = 5;
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [usernameBkg addSubview:userIcon];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
    self.usernameTextField.font = [UIFont systemFontOfSize:14];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [usernameBkg addSubview:self.usernameTextField];

    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    passwordBkg.layer.cornerRadius = 5;
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
    self.passwordTextField.font = [UIFont systemFontOfSize:14];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    
    self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateSelected];
    [self.eyeBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBkg addSubview:self.eyeBtn];
    
    self.accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accountBtn setTitle:@"记住账号" forState:UIControlStateNormal];
    [self.accountBtn setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [self.accountBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
    [self.accountBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
    self.accountBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.accountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [self.accountBtn addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.accountBtn];
    
    self.autoLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [self.autoLoginBtn setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
    self.autoLoginBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.autoLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [self.autoLoginBtn addTarget:self action:@selector(autoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.autoLoginBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5.0];
    [loginBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x2badda]] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    
    UIButton *vpnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [vpnBtn setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [vpnBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    vpnBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [vpnBtn setTitle:@"VPN设置" forState:UIControlStateNormal];
    vpnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [vpnBtn addTarget:self action:@selector(vpnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:vpnBtn];
    
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@93);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@119);
        make.height.equalTo(@62);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logoIcon.mas_centerX);
        make.top.mas_equalTo(logoIcon.mas_bottom).with.offset(14);
        make.width.equalTo(@200);
        make.height.equalTo(@25);
    }];

    [usernameBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@320);
        make.height.equalTo(@44);
        make.top.equalTo(titleLab.mas_bottom).with.offset(50);
    }];

    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.mas_centerY);
        make.left.equalTo(@14);
    }];

    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(userIcon.mas_right).with.offset(10);
        make.width.equalTo(@267.5);
        make.height.equalTo(@44);
    }];

    [passwordBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameBkg.mas_left);
        make.top.equalTo(usernameBkg.mas_bottom).with.offset(25);
        make.width.height.equalTo(usernameBkg);
    }];

    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.left.equalTo(@14);
    }];

    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.usernameTextField.mas_left);
        make.width.equalTo(@230);
    }];

    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-14);
        make.centerY.equalTo(passwordBkg.mas_centerY);
    }];
    
    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordBkg.mas_left);
        make.top.equalTo(passwordBkg.mas_bottom).with.offset(20);
    }];

    [self.autoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountBtn.mas_centerY);
        make.right.equalTo(passwordBkg.mas_right);
    }];

    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@320);
        make.height.equalTo(@44);
        make.top.equalTo(self.autoLoginBtn.mas_bottom).with.offset(20);
    }];
    
    [vpnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(20);
        make.right.equalTo(loginBtn.mas_right);
    }];
    
    return self;
}

- (void)eyeClick:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.isOpen = btn.selected;
    [[UserManager sharedUserManager] saveUserModel:userModel];
}

- (void)accountClick:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = !btn.selected;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isRememberUsername = btn.selected;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
    else
    {
        if(self.usernameTextField.text.length == 0)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
            return;
        }

        btn.selected = !btn.selected;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isRememberUsername = btn.selected;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
}

- (void)autoLoginClick:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = !btn.selected;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isAutoLogin = btn.selected;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
    else
    {
        if([self isValid])
        {
            btn.selected = !btn.selected;
            UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
            userModel.isAutoLogin = btn.selected;
            userModel.isRememberUsername = YES;
            self.accountBtn.selected = YES;
            [[UserManager sharedUserManager] saveUserModel:userModel];
        }
    }
}

- (void)loginClick:(UIButton *)sender
{
    if([self isValid])
    {
        [self.passwordTextField resignFirstResponder];
        [_delegate didLoginWithUserName:self.usernameTextField.text AndPassWord:self.passwordTextField.text];
    }
}

- (BOOL)isValid
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(username.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return NO;
    }
    if(password.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    
    return YES;
}

- (void)vpnSettingClick:(UIButton *)sender
{
    [_delegate didClickVPNSettingBtn];
}

- (void)reloadData
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    self.eyeBtn.selected = NO;
    self.passwordTextField.secureTextEntry = YES;
    self.accountBtn.selected = userModel.isRememberUsername;
    self.autoLoginBtn.selected = userModel.isAutoLogin;
    
    if(self.autoLoginBtn.isSelected)
    {
        self.usernameTextField.text = userModel.username;
        self.passwordTextField.text = userModel.password;
    }
    else
    {
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        if(self.accountBtn.isSelected)
        {
            self.usernameTextField.text = userModel.username;
        }
    }
    
    if(0 == self.usernameTextField.text.length)
    {
        [self.usernameTextField becomeFirstResponder];
    }
    else
    {
        if(0 == self.passwordTextField.text.length)
        {
            [self.passwordTextField becomeFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.usernameTextField == textField) {
        if ([self.passwordTextField canBecomeFirstResponder]) {
            [self.passwordTextField becomeFirstResponder];
            return NO;
        }
    }

    if (self.passwordTextField == textField) {
        [self.passwordTextField resignFirstResponder];
        [self loginClick:nil];
    }

    return YES;
}

- (void)textFieldResignFirstResponder
{
    if ([self.usernameTextField isFirstResponder])
        [self.usernameTextField resignFirstResponder];

    if ([self.passwordTextField isFirstResponder])
        [self.passwordTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


@end
