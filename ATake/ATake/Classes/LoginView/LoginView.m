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
    
    UIImageView *bkg = [UIImageView new];
//    bkg.image = [UIImage imageNamed:@"login_bkg"]; // 大图耗内存
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"login_bkg"];
//    bkg.image = [UIImage imageWithContentsOfFile:path];
    bkg.backgroundColor = [UIColor colorWithHexString:@"#1296db"];
    [self addSubview:bkg];
    [bkg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor whiteColor];
    usernameBkg.layer.cornerRadius = 5;
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    [usernameBkg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(H(200));
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
    self.usernameTextField.placeholder = @"请输入手机号";
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
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.width.height.equalTo(self.usernameTextField);
    }];
    
    self.accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.accountBtn setTitle:@"记住账号和密码" forState:UIControlStateNormal];
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
        make.centerX.equalTo(self.centerX);
        make.width.height.equalTo(passwordBkg);
        make.top.equalTo(self.accountBtn.bottom).with.offset(H(20));
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

- (void)vpnSettingClick:(UIButton *)sender
{
    [_delegate didClickVPNSettingBtn];
}

- (void)reloadData
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    self.accountBtn.selected = userModel.isRememberUsername;
//    self.autoLoginBtn.selected = userModel.isAutoLogin;
    
    if(self.accountBtn.isSelected)
    {
        self.usernameTextField.text = userModel.username;
        self.passwordTextField.text = userModel.password;
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
