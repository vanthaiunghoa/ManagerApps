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
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
//    UIImageView *bkg = [UIImageView new];
//    bkg.image = [UIImage imageNamed:@"login_bkg"]; // 大图耗内存
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"login_bkg"];
//    bkg.image = [UIImage imageWithContentsOfFile:path];
//    bkg.backgroundColor = [UIColor colorWithHexString:@"#1296db"];
//    [self addSubview:bkg];
//    [bkg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(self);
//    }];
    
    UILabel *labLogin = [UILabel new];
    labLogin.text = @"登录";
    labLogin.font = [UIFont systemFontOfSize:24];
    labLogin.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labLogin];
    [labLogin makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(H(70));
        make.left.right.equalTo(self).offset(0);
        make.height.equalTo(@(H(50)));
    }];
    
    UILabel *labPhone = [UILabel new];
    labPhone.text = @"请输入手机号码";
    labPhone.font = [UIFont systemFontOfSize:15];
    labPhone.textColor = [UIColor lightGrayColor];
//    labPhone.backgroundColor = [UIColor redColor];
    [self addSubview:labPhone];
    [labPhone makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labLogin.bottom).offset(H(30));
        make.left.equalTo(self).offset(H(30));
        make.right.equalTo(self).offset(H(-30));
        make.height.equalTo(@20);
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.textColor = [UIColor blackColor];
//    self.usernameTextField.backgroundColor = [UIColor redColor];
    self.usernameTextField.font = [UIFont systemFontOfSize:18];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [self addSubview:self.usernameTextField];
    [self.usernameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labPhone.bottom).offset(H(5));

        make.left.right.equalTo(labPhone);
        make.height.equalTo(@40);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.bottom);
        make.left.right.equalTo(self.usernameTextField);
        make.height.equalTo(@2);
    }];

    UILabel *labPassword = [UILabel new];
    labPassword.text = @"请输入密码";
    labPassword.font = [UIFont systemFontOfSize:15];
    labPassword.textColor = [UIColor lightGrayColor];
    [self addSubview:labPassword];
    [labPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.bottom).offset(H(10));
        make.left.right.equalTo(line);
        make.height.equalTo(@20);
    }];

    self.passwordTextField = [UITextField new];
//    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [self addSubview:self.passwordTextField];
    [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labPassword.bottom).offset(H(5));
        make.left.right.height.equalTo(self.usernameTextField);
//        make.centerX.equalTo(self.centerX);
    }];

    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.bottom);
        make.left.right.equalTo(self.passwordTextField);
        make.height.equalTo(@2);
    }];
    
    UIButton *btnForgotPassword = [UIButton new];
    [btnForgotPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [btnForgotPassword.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnForgotPassword setTitleColor:[UIColor colorWithHexString:@"#3ECE89"] forState:UIControlStateNormal];
    btnForgotPassword.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:btnForgotPassword];
    [btnForgotPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.bottom);
        make.right.equalTo(line2.right);
        make.width.equalTo(@68);
        make.height.equalTo(@44);
    }];
    
    [btnForgotPassword addTarget:self action:@selector(forgotPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.accountBtn setTitle:@"记住账号和密码" forState:UIControlStateNormal];
//    [self.accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.accountBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
//    [self.accountBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
//    self.accountBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    self.accountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
//    [self.accountBtn addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.accountBtn];
//    [self.accountBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(passwordBkg.left);
//        make.top.equalTo(passwordBkg.bottom).with.offset(H(20));
//    }];
    
//    self.autoLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [self.autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
//    [self.autoLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
//    [self.autoLoginBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
//    self.autoLoginBtn.titleLabel.font=[UIFont systemFontOfSize:17];
//    self.autoLoginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
//    [self.autoLoginBtn addTarget:self action:@selector(autoLoginClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.autoLoginBtn];
//    [self.autoLoginBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.accountBtn.centerY);
//        make.right.equalTo(passwordBkg.right);
//    }];
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:5.0];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3ECE89"]] forState:UIControlStateNormal];
    [self addSubview:self.loginBtn];
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnForgotPassword.bottom);
        make.left.right.equalTo(line2);
        make.height.equalTo(@44);
    }];
    
    CGFloat padding = SCREEN_WIDTH/2.0;
    
    UILabel *labAccount = [UILabel new];
    labAccount.text = @"没有账号？";
    labAccount.font = [UIFont systemFontOfSize:12];
    labAccount.textAlignment = NSTextAlignmentRight;
    [self addSubview:labAccount];
    [labAccount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.bottom).offset(H(10));
        make.right.equalTo(self.right).offset(@(-padding));
        make.width.equalTo(@68);
        make.height.equalTo(@44);
    }];
    
    UIButton *btnRegister = [UIButton new];
    [btnRegister setTitle:@"立即注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor colorWithHexString:@"#3ECE89"] forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnRegister.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:btnRegister];
    [btnRegister makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.bottom).offset(H(10));
        make.left.equalTo(self.left).offset(@(padding));
        make.width.equalTo(@55);
        make.height.equalTo(@44);
    }];

    [btnRegister addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)accountClick:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.isRememberUsername = btn.selected;
    [[UserManager sharedUserManager] saveUserModel:userModel];
}

- (void)autoLoginClick:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.isAutoLogin = btn.selected;
    if(btn.isSelected)
    {
        userModel.isRememberUsername = YES;
        self.accountBtn.selected = YES;
    }
    [[UserManager sharedUserManager] saveUserModel:userModel];
}

- (void)loginClick:(UIButton *)sender
{
    [_delegate didLoginWithUserName:self.usernameTextField.text AndPassWord:self.passwordTextField.text];
}

- (void)registerClick:(UIButton *)sender
{
    [_delegate didClickRegister];
}

- (void)forgotPasswordClick:(UIButton *)sender
{
    [_delegate didClickForgotPassword];
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
    
    RAC(self.loginBtn, enabled) = [RACSignal
                                   combineLatest:@[self.usernameTextField.rac_textSignal,
                                                   self.passwordTextField.rac_textSignal
                                                   ]
                                   reduce:^(NSString *account, NSString *password){
                                       return @(account.length > 0 && password.length > 0);
                                   }];
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
