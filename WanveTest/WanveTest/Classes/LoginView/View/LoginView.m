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
    
    UIImageView *bkg = [UIImageView new];
//    bkg.image = [UIImage imageNamed:@"login_bkg"]; // 大图耗内存
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"login_bkg"];
    bkg.image = [UIImage imageWithContentsOfFile:path];
    [self addSubview:bkg];
    [bkg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo_company"];
    [self addSubview:logoIcon];
    [logoIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(@(H(85)));
        make.width.equalTo(@(W(129)));
        make.height.equalTo(@(H(44)));
    }];
    
    UILabel *company = [UILabel new];
    company.text = @"万维博通";
    company.textColor = [UIColor whiteColor];
    company.font = [UIFont systemFontOfSize:32];
    company.textAlignment = NSTextAlignmentCenter;
    [self addSubview:company];
    [company makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(logoIcon.bottom).offset(H(10));
        make.left.right.equalTo(self);
    }];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"智慧政务管理平台";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:28];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logoIcon.centerX);
        make.top.equalTo(company.bottom).with.offset(H(15));
        make.left.right.equalTo(self);
    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor whiteColor];
    usernameBkg.layer.cornerRadius = 5;
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    [usernameBkg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(titleLab.bottom).with.offset(H(40));
        make.left.equalTo(self).offset(H(30));
        make.right.equalTo(self).offset(H(-30));
        make.height.equalTo(@(H(40)));
    }];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [usernameBkg addSubview:userIcon];
    [userIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.centerY);
        make.left.equalTo(@(W(12)));
        make.width.height.equalTo(@(W(18)));
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.textColor = [UIColor blackColor];
    self.usernameTextField.font = [UIFont systemFontOfSize:18];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [usernameBkg addSubview:self.usernameTextField];
    [self.usernameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.right).with.offset(W(12));
        make.top.bottom.equalTo(usernameBkg);
        make.right.equalTo(usernameBkg.right).offset(W(-12));
//        make.width.equalTo(@(261));
    }];
    
    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor whiteColor];
    passwordBkg.layer.cornerRadius = 5;
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    [passwordBkg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameBkg.left);
        make.top.equalTo(usernameBkg.bottom).with.offset(H(20));
        make.width.height.equalTo(usernameBkg);
    }];
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.width.height.equalTo(@(W(18)));
        make.left.equalTo(@(W(12)));
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
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
    [self.eyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(W(-12)));
        make.width.equalTo(@(W(30)));
        make.height.equalTo(@(H(18)));
        make.centerY.equalTo(passwordBkg.centerY);
    }];
    
    [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.usernameTextField.left);
        make.right.equalTo(self.eyeBtn.left).offset(W(-12));
    }];
    
    self.accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accountBtn setTitle:@"记住账号" forState:UIControlStateNormal];
    [self.accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.accountBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
    [self.accountBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
    self.accountBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    self.accountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
    [self.accountBtn addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.accountBtn];
    [self.accountBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordBkg.left);
        make.top.equalTo(passwordBkg.bottom).with.offset(H(20));
    }];
    
    self.autoLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [self.autoLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
    self.autoLoginBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    self.autoLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
    [self.autoLoginBtn addTarget:self action:@selector(autoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.autoLoginBtn];
    [self.autoLoginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountBtn.centerY);
        make.right.equalTo(passwordBkg.right);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5.0];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3ECE89"]] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.height.equalTo(passwordBkg);
        make.top.equalTo(self.autoLoginBtn.bottom).with.offset(H(20));
    }];
    
    UIButton *vpnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [vpnBtn setTitle:@"VPN设置" forState:UIControlStateNormal];
    [vpnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vpnBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    vpnBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    vpnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
    [vpnBtn addTarget:self action:@selector(vpnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:vpnBtn];
    [vpnBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.bottom).offset(H(20));
        make.right.equalTo(loginBtn.right);
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
