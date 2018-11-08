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
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo"];
    [self addSubview:logoIcon];
    [logoIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.top).offset(100);
        make.width.equalTo(@(178/132.0 * 80));
        make.height.equalTo(@80);
    }];
    
    UILabel *labName = [UILabel new];
    labName.text = @"农肥未来";
    labName.font = [UIFont systemFontOfSize:18];
    labName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labName];
    [labName makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.centerX);
        make.top.equalTo(logoIcon.bottom).offset(0);
        make.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    int padding = 40;
    int h = 50;
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor clearColor];
    usernameBkg.layer.cornerRadius = h/2.0;
    usernameBkg.layer.borderWidth = 1;
    usernameBkg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    [usernameBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labName.mas_bottom).with.offset(50);
        make.left.equalTo(self).offset(padding);
        make.right.equalTo(self).offset(-padding);
        make.height.equalTo(h);
    }];
    
    CGFloat imgW = 18;
    CGFloat imgH = 35/32.0 * imgW;
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [usernameBkg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.mas_centerY);
        make.left.equalTo(@30);
        make.width.equalTo(imgW);
        make.height.equalTo(imgH);
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"请输入手机号";
//    self.usernameTextField.textColor = [UIColor whiteColor];
//    self.usernameTextField.tintColor = [UIColor whiteColor];
//    [self.usernameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.usernameTextField.font = [UIFont systemFontOfSize:16];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [usernameBkg addSubview:self.usernameTextField];
    
//    UIButton *clean = [self.usernameTextField valueForKey:@"_clearButton"]; //key是固定的
//    [clean setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    //    [clean setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateHighlighted];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(15);
        make.top.bottom.equalTo(usernameBkg);
        make.right.equalTo(usernameBkg.mas_right).offset(-30);
    }];
    
    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor clearColor];
    passwordBkg.layer.cornerRadius = h/2.0;
    passwordBkg.layer.borderWidth = 1;
    passwordBkg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    [passwordBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameBkg.mas_left);
        make.top.equalTo(usernameBkg.mas_bottom).with.offset(15);
        make.width.height.equalTo(usernameBkg);
    }];
    
    imgH = 35/29.0 * imgW;
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.left.equalTo(userIcon);
        make.width.equalTo(imgW);
        make.height.equalTo(imgH);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
//    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    self.passwordTextField.tintColor = [UIColor whiteColor];
//    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:16];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    
//    UIButton *cleanPassword = [self.passwordTextField valueForKey:@"_clearButton"]; //key是固定的
//    [cleanPassword setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    
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

    UIButton *btnForgotPassword = [UIButton new];
    [btnForgotPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [btnForgotPassword.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnForgotPassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnForgotPassword.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:btnForgotPassword];
    [btnForgotPassword makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordBkg.bottom);
        make.right.equalTo(passwordBkg.right);
        make.width.equalTo(@68);
        make.height.equalTo(@44);
    }];
    
    [btnForgotPassword addTarget:self action:@selector(forgotPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:h/2.0];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:108 green:189 blue:117]] forState:UIControlStateNormal];
    [self addSubview:self.loginBtn];
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnForgotPassword.bottom);
        make.left.right.height.equalTo(passwordBkg);
    }];
    
    padding = SCREEN_WIDTH/2.0;
    
    UILabel *labAccount = [UILabel new];
    labAccount.text = @"还没有账户？";
    labAccount.font = [UIFont systemFontOfSize:12];
    labAccount.textColor = [UIColor lightGrayColor];
    labAccount.textAlignment = NSTextAlignmentRight;
    [self addSubview:labAccount];
    [labAccount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.bottom).offset(H(10));
        make.right.equalTo(self.right).offset(@(-padding));
        make.width.equalTo(@90);
        make.height.equalTo(@44);
    }];
    
    UIButton *btnRegister = [UIButton new];
    [btnRegister setTitle:@"立即注册" forState:UIControlStateNormal];
    [btnRegister setTitleColor:[UIColor colorWithRGB:108 green:189 blue:117] forState:UIControlStateNormal];
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
    
    RAC(self.loginBtn, enabled) = [RACSignal
                                   combineLatest:@[self.usernameTextField.rac_textSignal,
                                                   self.passwordTextField.rac_textSignal
                                                   ]
                                   reduce:^(NSString *account, NSString *password){
                                       return @(account.length > 0 && password.length > 0);
                                   }];
    
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
