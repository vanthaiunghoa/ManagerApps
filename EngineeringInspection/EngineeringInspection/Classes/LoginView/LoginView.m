#import "LoginView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "UserModel.h"
#import "UserManager.h"

@interface LoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
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
    topView.backgroundColor = [UIColor colorWithRGB:28 green:120 blue:255];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.right.equalTo(self);
        make.height.equalTo(@(H(250)));
    }];
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo"];
    [topView addSubview:logoIcon];
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(H(75));
        make.width.equalTo(@(W(140)));
        make.height.equalTo(@(H(60.8)));
    }];
    
    CGFloat waveH = 111.0*SCREEN_WIDTH/750.0;
    UIImageView *wave = [UIImageView new];
    wave.image = [UIImage imageNamed:@"wave"];
    [topView addSubview:wave];
    [wave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView.mas_bottom);
        make.left.right.equalTo(topView);
        make.height.equalTo(@(waveH));
    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor whiteColor];
    
    [usernameBkg.layer setBorderWidth:2];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 211.0/255.0, 211.0/255.0, 211.0/255.0, 1 });
    [usernameBkg.layer setBorderColor:colorref];
    
    usernameBkg.layer.cornerRadius = 20;
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    [usernameBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(topView.mas_bottom).with.offset(H(50));
        make.left.equalTo(self).offset(H(30));
        make.right.equalTo(self).offset(H(-30));
        make.height.equalTo(@(H(40)));
    }];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [usernameBkg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.mas_centerY);
        make.left.equalTo(@(W(20)));
        make.width.height.equalTo(@(W(18)));
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"手机号/用户名";
    self.usernameTextField.textColor = [UIColor blackColor];
    self.usernameTextField.font = [UIFont systemFontOfSize:18];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [usernameBkg addSubview:self.usernameTextField];
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(W(20));
        make.top.bottom.equalTo(usernameBkg);
        make.right.equalTo(usernameBkg.mas_right).offset(W(-20));
    }];
    
    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor whiteColor];
    
    [passwordBkg.layer setBorderWidth:2];
    [passwordBkg.layer setBorderColor:colorref];
    
    passwordBkg.layer.cornerRadius = 20;
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    [passwordBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameBkg.mas_left);
        make.top.equalTo(usernameBkg.mas_bottom).with.offset(H(20));
        make.width.height.equalTo(usernameBkg);
    }];
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.width.height.equalTo(@(W(18)));
        make.left.equalTo(@(W(20)));
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
    [passwordBkg addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.width.height.equalTo(self.usernameTextField);
    }];
    
//    self.accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.accountBtn setTitle:@"记住账号" forState:UIControlStateNormal];
//    [self.accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.accountBtn setImage:[UIImage imageNamed:@"remember-unselected"] forState:UIControlStateNormal];
//    [self.accountBtn setImage:[UIImage imageNamed:@"remember-selected"] forState:UIControlStateSelected];
//    self.accountBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    self.accountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
//    [self.accountBtn addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.accountBtn];
//    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(passwordBkg.mas_left);
//        make.top.equalTo(passwordBkg.mas_bottom).with.offset(H(20));
//    }];
//
//    self.autoLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self.autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
//    [self.autoLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember-unselected"] forState:UIControlStateNormal];
//    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember-selected"] forState:UIControlStateSelected];
//    self.autoLoginBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    self.autoLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
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
    [loginBtn.layer setCornerRadius:20];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
//    [loginBtn setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:28 green:120 blue:255]] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.equalTo(passwordBkg);
        make.top.equalTo(passwordBkg.mas_bottom).with.offset(H(30));
    }];
    
    UILabel *labCompany = [UILabel new];
    [labCompany setText:@"万维博通信息技术有限公司"];
    [labCompany setTextColor:[UIColor colorWithRGB:98 green:173 blue:249]];
    [labCompany setFont:[UIFont systemFontOfSize:14]];
    [labCompany setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:labCompany];
    [labCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.left.right.equalTo(self);
    }];

    return self;
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
//    self.passwordTextField.secureTextEntry = YES;
//    self.accountBtn.selected = userModel.isRememberUsername;
//    self.autoLoginBtn.selected = userModel.isAutoLogin;
    
    if(userModel.isLogout)
    {
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        [self.usernameTextField becomeFirstResponder];
    }
    else
    {
//        if(self.autoLoginBtn.isSelected)
//        {
            self.usernameTextField.text = userModel.username;
            self.passwordTextField.text = userModel.password;
//        }
//        else
//        {
//            self.usernameTextField.text = @"";
//            self.passwordTextField.text = @"";
//            if(self.accountBtn.isSelected)
//            {
//                self.usernameTextField.text = userModel.username;
//                self.passwordTextField.text = userModel.password;
//            }
//        }
//
//        if(0 == self.usernameTextField.text.length)
//        {
//            [self.usernameTextField becomeFirstResponder];
//        }
//        else
//        {
//            if(0 == self.passwordTextField.text.length)
//            {
//                [self.passwordTextField becomeFirstResponder];
//            }
//        }
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
