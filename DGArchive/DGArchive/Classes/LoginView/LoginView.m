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
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [UIView new];
    [self addSubview:topView];
    topView.backgroundColor = [UIColor colorWithRGB:69 green:124 blue:228];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(H(250)));
    }];
    
    CGFloat w = 296.0/192.0 * H(96);
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo"];
    [topView addSubview:logoIcon];
    [logoIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.bottom.equalTo(topView.bottom).offset(-H(100));
        make.width.equalTo(w);
        make.height.equalTo(@(H(96)));
    }];
    
    UIImageView *arc = [UIImageView new];
    arc.image = [UIImage imageNamed:@"arc"];
    [topView addSubview:arc];
    [arc makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topView);
        make.bottom.equalTo(topView.bottom);
        make.height.equalTo(@(H(55.5)));
    }];

    UIView *userView = [UIView new];
    [self addSubview:userView];
    userView.backgroundColor = [UIColor clearColor];
    [userView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(W(30));
        make.right.equalTo(self.right).offset(W(-30));
        make.top.equalTo(topView.bottom).offset(H(15));
        make.height.equalTo(@(H(50)));
    }];
    
    CGFloat h = 35.0/34.0 * 16;
    UIImageView *user = [UIImageView new];
    user.image = [UIImage imageNamed:@"user"];
    [userView addSubview:user];
    [user makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userView.centerY);
        make.left.equalTo(userView.left).offset(W(20));
        make.width.equalTo(@17);
        make.height.equalTo(h);
    }];

    self.usernameTextField = [UITextField new];
    self.usernameTextField.textColor = [UIColor blackColor];
    self.usernameTextField.placeholder = @"手机号码/用户名";
    self.usernameTextField.font = [UIFont systemFontOfSize:18];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [userView addSubview:self.usernameTextField];
    [self.usernameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(userView);
        make.left.equalTo(user.right).offset(W(20));
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userView.bottom);
        make.left.right.equalTo(userView);
        make.height.equalTo(@1);
    }];
    
    UIView *passwordView = [UIView new];
    [self addSubview:passwordView];
    passwordView.backgroundColor = [UIColor clearColor];
    [passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(W(30));
        make.right.equalTo(self.right).offset(W(-30));
        make.top.equalTo(line.bottom).offset(H(15));
        make.height.equalTo(@(H(50)));
    }];
    
    h = 34.0/29.0 * 16;
    UIImageView *password = [UIImageView new];
    password.image = [UIImage imageNamed:@"password"];
    [passwordView addSubview:password];
    [password makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordView.centerY);
        make.left.equalTo(passwordView.left).offset(W(20));
        make.width.equalTo(@17);
        make.height.equalTo(h);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"密码";
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordView addSubview:self.passwordTextField];
    [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(passwordView);
        make.left.equalTo(password.right).offset(W(20));
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.bottom);
        make.left.right.equalTo(passwordView);
        make.height.equalTo(@1);
    }];
    
    UIButton *forget = [UIButton buttonWithType:UIButtonTypeCustom];
    [forget setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:14];
    [forget setTitleColor:[UIColor colorWithRGB:69 green:124 blue:228] forState:UIControlStateNormal];
    forget.titleLabel.textAlignment = NSTextAlignmentRight;
    [forget addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:forget];
    [forget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(H(5));
        make.right.equalTo(self.right).offset(W(-30));
//        make.width.equalTo(@100);
        make.height.equalTo(@(H(40)));
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登    录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:H(25)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:69 green:124 blue:228]] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forget.mas_bottom).offset(H(5));
        make.left.equalTo(self.left).offset(W(30));
        make.right.equalTo(self.right).offset(W(-30));
        make.height.equalTo(@(H(50)));
    }];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegister setTitle:@"注    册" forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegister.layer setMasksToBounds:YES];
    [btnRegister.layer setCornerRadius:H(25)];
    btnRegister.layer.borderWidth = 2;
    btnRegister.layer.borderColor = [UIColor colorWithRGB:69 green:124 blue:228].CGColor;
    [btnRegister setTitleColor:[UIColor colorWithRGB:69 green:124 blue:228] forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnRegister setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self addSubview:btnRegister];
    [btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.bottom).offset(H(15));
        make.left.right.height.equalTo(loginBtn);
    }];

//    UIButton *vpnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [vpnBtn setTitle:@"VPN设置" forState:UIControlStateNormal];
//    [vpnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [vpnBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
//    vpnBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    vpnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
//    [vpnBtn addTarget:self action:@selector(vpnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:vpnBtn];
//    [vpnBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.bottom).offset(H(20));
//        make.right.equalTo(loginBtn.right);
//    }];
//
    UILabel *lab = [UILabel new];
    [self addSubview:lab];
    [lab setText:@"东莞市档案馆"];
    [lab setTextColor:[UIColor colorWithRGB:69 green:124 blue:228]];
    [lab setFont:[UIFont systemFontOfSize:14]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.bottom).offset(H(-33));
//        make.height.equalTo(@20);
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

- (void)forgetClick:(UIButton *)sender
{
    [_delegate didClickForget];
}

- (void)registerClick:(UIButton *)sender
{
    [_delegate didClickRegister];
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
    
    self.usernameTextField.text = userModel.username;
    self.passwordTextField.text = userModel.password;
    
//    if(0 == self.usernameTextField.text.length)
//    {
//        [self.usernameTextField becomeFirstResponder];
//    }
//    else
//    {
//        if(0 == self.passwordTextField.text.length)
//        {
//            [self.passwordTextField becomeFirstResponder];
//        }
//    }
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
