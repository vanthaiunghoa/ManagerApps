#import "LoginView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "UserModel.h"
#import "UserManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"

@interface LoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UIButton *accountBtn;
@property (nonatomic, strong) UIButton *autoLoginBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor colorWithRGB:50 green:139 blue:239];
    
    UIImageView *bkg = [UIImageView new];
    bkg.image = [UIImage imageNamed:@"login-bkg"]; // 大图耗内存
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"login-bkg"];
//    bkg.image = [UIImage imageWithContentsOfFile:path];
    [self addSubview:bkg];
    [bkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@533);
    }];
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logoIcon];
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@130);
        make.width.equalTo(@246);
        make.height.equalTo(@84);
    }];

    UILabel *company = [UILabel new];
    company.text = @"万维博通智慧办公平台";
    company.textColor = [UIColor whiteColor];
    company.font = [UIFont systemFontOfSize:51];
    company.textAlignment = NSTextAlignmentCenter;
    [self addSubview:company];
    [company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIcon.mas_bottom).offset(30);
        make.left.right.equalTo(self);
        make.height.equalTo(@78);
    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor clearColor];
    usernameBkg.layer.cornerRadius = 38;
    usernameBkg.layer.borderWidth = 2;
    usernameBkg.layer.borderColor = [[UIColor whiteColor] CGColor];
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    [usernameBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(company.mas_bottom).with.offset(130);
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-100);
        make.height.equalTo(@78);
    }];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [usernameBkg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.mas_centerY);
        make.left.equalTo(@40);
        make.width.equalTo(@28);
        make.height.equalTo(@30);
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.textColor = [UIColor whiteColor];
    self.usernameTextField.tintColor = [UIColor whiteColor];
    [self.usernameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.usernameTextField.font = [UIFont systemFontOfSize:34];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [usernameBkg addSubview:self.usernameTextField];
    
    UIButton *clean = [self.usernameTextField valueForKey:@"_clearButton"]; //key是固定的
    [clean setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
//    [clean setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateHighlighted];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(22);
        make.top.bottom.equalTo(usernameBkg);
        make.right.equalTo(usernameBkg.mas_right).offset(-40);
    }];
    
    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor clearColor];
    passwordBkg.layer.cornerRadius = 50;
    passwordBkg.layer.borderWidth = 2;
    passwordBkg.layer.borderColor = [[UIColor whiteColor] CGColor];
    passwordBkg.layer.cornerRadius = 38;
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    [passwordBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameBkg.mas_left);
        make.top.equalTo(usernameBkg.mas_bottom).with.offset(38);
        make.width.height.equalTo(usernameBkg);
    }];
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.left.width.height.equalTo(userIcon);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTextField.tintColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:34];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    
    UIButton *cleanPassword = [self.passwordTextField valueForKey:@"_clearButton"]; //key是固定的
    [cleanPassword setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    
//    self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.eyeBtn setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
//    [self.eyeBtn setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateSelected];
//    [self.eyeBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.eyeBtn.selected = NO;
//    [passwordBkg addSubview:self.eyeBtn];
//    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@(-12));
//        make.width.equalTo(@30);
//        make.height.equalTo(@18);
//        make.centerY.equalTo(passwordBkg.mas_centerY);
//    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.equalTo(self.usernameTextField);
    }];
    
//    self.accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.accountBtn setTitle:@"记住账号" forState:UIControlStateNormal];
//    [self.accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.accountBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
//    [self.accountBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
//    self.accountBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    self.accountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    [self.accountBtn addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.accountBtn];
//    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(passwordBkg.mas_left);
//        make.top.equalTo(passwordBkg.mas_bottom).with.offset(20);
//    }];
//
//    self.autoLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self.autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
//    [self.autoLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
//    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
//    self.autoLoginBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    self.autoLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    [self.autoLoginBtn addTarget:self action:@selector(autoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.autoLoginBtn];
//    [self.autoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.accountBtn.mas_centerY);
//        make.right.equalTo(passwordBkg.mas_right);
//    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:38];
    [loginBtn setTitleColor:[UIColor colorWithRGB:50 green:144 blue:255] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:34];
//    [loginBtn setBackgroundColor:[UIColor whiteColor]];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:50 green:144 blue:255]] forState:UIControlStateHighlighted];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(passwordBkg);
        make.top.equalTo(passwordBkg.mas_bottom).offset(58);
    }];
    
    UIButton *vpnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [vpnBtn setTitle:@"VPN设置" forState:UIControlStateNormal];
    [vpnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vpnBtn setImage:[UIImage imageNamed:@"login-setup"] forState:UIControlStateNormal];
    vpnBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    vpnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -14);
    [vpnBtn addTarget:self action:@selector(vpnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:vpnBtn];
    [vpnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(38);
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

- (void)reloadData:(NSString *)account AndPassword:(NSString *)password
{
//    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
//
//    self.accountBtn.selected = userModel.isRememberUsername;
//    self.autoLoginBtn.selected = userModel.isAutoLogin;
//
//    if(self.autoLoginBtn.isSelected || self.accountBtn.isSelected)
//    {
//        self.usernameTextField.text = userModel.username;
//        self.passwordTextField.text = userModel.password;
//    }
//    else
//    {
//        self.usernameTextField.text = @"";
//        self.passwordTextField.text = @"";
//        if(self.accountBtn.isSelected)
//        {
//            self.usernameTextField.text = userModel.username;
//        }
//    }
    
    self.usernameTextField.text = account;
    self.passwordTextField.text = password;
    
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
