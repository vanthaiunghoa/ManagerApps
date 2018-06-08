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
    
    UIImageView *bkg = [UIImageView new];
//    bkg.image = [UIImage imageNamed:@"login_bkg"]; // 大图耗内存
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"login_bkg"];
    bkg.image = [UIImage imageWithContentsOfFile:path];
    [self addSubview:bkg];
    [bkg makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    UIImageView *logoIcon = [UIImageView new];
//    logoIcon.image = [UIImage imageNamed:@"logo_company"];
//    logoIcon.image = [UIImage imageNamed:@"logo-qzzb"];
//    logoIcon.image = [UIImage imageNamed:@"logo-yt"];
//    logoIcon.image = [UIImage imageNamed:@"logo-ns"];
//    logoIcon.image = [UIImage imageNamed:@"logo-ft"];
//    logoIcon.image = [UIImage imageNamed:@"logo-lhgwj"];
//    logoIcon.image = [UIImage imageNamed:@"logo-szswjt"];
//    logoIcon.image = [UIImage imageNamed:@"logo-bjfdzy"];
//    logoIcon.image = [UIImage imageNamed:@"logo-bjtyfdc"];
    logoIcon.image = [UIImage imageNamed:@"logo-sshgcj"];
    [self addSubview:logoIcon];
    [logoIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(@(H(68)));
        // 勤智资本
//        make.width.equalTo(@(W(171)));
//        make.height.equalTo(@(H(54)));
        // 盐田
//        make.width.equalTo(@(W(94)));
//        make.height.equalTo(@(H(63)));
        // 南山
//        make.width.equalTo(@(W(54)));
//        make.height.equalTo(@(H(52.5)));
        // 福田
//        make.width.equalTo(@(W(60)));
//        make.height.equalTo(@(H(60)));
        // 龙华
//        make.width.equalTo(@(W(54)));
//        make.height.equalTo(@(H(60)));
        // 深圳水务集团
//        make.width.equalTo(@(W(87.7)));
//        make.height.equalTo(@(H(60)));
        // 北京房地置业
//        make.width.equalTo(@(W(56.2)));
//        make.height.equalTo(@(H(60)));
        // 北京天运房地产
//        make.width.equalTo(@(W(60)));
//        make.height.equalTo(@(H(60)));
        // 松山湖工程管理局工程数据管理平台
        make.width.equalTo(@(W(120)));
        make.height.equalTo(@(H(60)));

    }];
    
    UILabel *company = [UILabel new];
//    company.text = @"深圳市宝安区建筑工务局";
//    company.text = @"投资数据管理平台";
//    company.text = @"盐田环水局工程数据管理平台";
//    company.text = @"南山工务局";
//    company.text = @"福田环水局工程数据管理平台";
//    company.text = @"龙华工务局工程数据管理平台";
//    company.text = @"深圳水务集团工程数据管理平台";
//    company.text = @"北京房地置业";
//    company.text = @"北京天运房地产";
    company.text = @"松山湖工程管理局";
    company.textColor = [UIColor whiteColor];
//    company.font = [UIFont fontWithName:@"STHeitiTC-Medium"size:24];
    company.font = [UIFont fontWithName:@"STHeitiTC-Medium"size:26];
    company.textAlignment = NSTextAlignmentCenter;
    [self addSubview:company];
    [company makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(logoIcon.bottom).offset(H(11));
        make.left.right.equalTo(self);
    }];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"工程数据管理平台";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:22];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(company.bottom).with.offset(H(12.5));
        make.left.right.equalTo(self);
    }];

//    UILabel *titleLabEN = [UILabel new];
//    titleLabEN.text = @"（ EIM ）";
//    titleLabEN.textColor = [UIColor whiteColor];
//    titleLabEN.font = [UIFont systemFontOfSize:24];
//    titleLabEN.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:titleLabEN];
//    [titleLabEN makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.centerX);
//        make.top.equalTo(titleLab.bottom).with.offset(H(7.5));
//        make.left.right.equalTo(self);
//    }];
    
    UIView *usernameBkg = [UIView new];
    usernameBkg.backgroundColor = [UIColor whiteColor];
    usernameBkg.layer.cornerRadius = 5;
    usernameBkg.clipsToBounds = YES;
    [self addSubview:usernameBkg];
    [usernameBkg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
//        make.top.equalTo(titleLabEN.bottom).with.offset(H(31));
        make.top.equalTo(titleLab.bottom).with.offset(H(31));
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
    self.passwordTextField.secureTextEntry = YES;
    self.accountBtn.selected = userModel.isRememberUsername;
    self.autoLoginBtn.selected = userModel.isAutoLogin;
    
    if(userModel.isLogout)
    {
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        [self.usernameTextField becomeFirstResponder];
    }
    else
    {
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
                self.passwordTextField.text = userModel.password;
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
