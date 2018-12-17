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
    bkg.image = [UIImage imageWithName:@"login_bkg"]; // 大图耗内存
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"login_bkg"];
//    bkg.image = [UIImage imageWithContentsOfFile:path];
    bkg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:bkg];
//    [bkg makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(self);
//    }];
    
    UIImageView *logoIcon = [UIImageView new];
//    // 勤智资本
//    logoIcon.image = [UIImage imageWithName:@"logo-qzzb"];
//    logoIcon.image = [UIImage imageWithName:@"logo_company"];
    // 自动办公
    logoIcon.image = [UIImage imageNamed:@"logo-zdhoa"];
    [self addSubview:logoIcon];
    [logoIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(@(H(85)));
//        make.width.equalTo(@(W(129)));
//        make.height.equalTo(@(H(44)));
        // 自动化办公
        make.width.equalTo(@(W(65)));
        make.height.equalTo(@(H(65)));
    }];

    UILabel *company = [UILabel new];
//    company.text = @"东莞市科学技术局";
//    company.text = @"东莞市水务局";
//    company.text = @"流转系统";
//    company.text = @"滨海湾新区管委会";
//    company.text = @"万维博通";
//    company.text = @"塘厦镇人民政府";
//    company.text = @"东莞市规划局文件流转系统";
//    company.text = @"中共东莞市委统战部";
//    company.text = @"广东省渔政总队东莞支队";
//    company.text = @"东莞市招商引资创新办公室";
    // 自动化办公
    company.text = @"东莞交投集团";
    company.textColor = [UIColor colorWithRGB:249 green:248 blue:11];
    
//    company.textColor = [UIColor whiteColor];
//    company.font = [UIFont systemFontOfSize:28];
    company.font = [UIFont boldSystemFontOfSize:32];
    company.textAlignment = NSTextAlignmentCenter;
    [self addSubview:company];
    [company makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(H(130)));
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(logoIcon.bottom).offset(H(10));
        make.left.right.equalTo(self);
    }];
    
    UILabel *titleLab = [UILabel new];
    // 滨海湾  水务局
//    titleLab.text = @"智慧办公系统";
    // 渔政支队
//    titleLab.text = @"智慧政务管理平台";
//    titleLab.text = @"投资数据管理平台";
//    titleLab.text = @"智慧政务平台";
    // 自动化办公
    titleLab.text = @"移动办公系统";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:26];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(logoIcon.centerX);
        make.centerX.equalTo(company.centerX);
        make.top.equalTo(company.bottom).with.offset(H(15));
//        make.top.equalTo(logoIcon.bottom).with.offset(H(15));
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
//        make.top.equalTo(company.bottom).with.offset(H(40));
        make.left.equalTo(self).offset(H(30));
        make.right.equalTo(self).offset(H(-30));
        make.height.equalTo(@(H(40)));
    }];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageWithName:@"user"];
    [usernameBkg addSubview:userIcon];
    [userIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(usernameBkg.centerY);
        make.left.equalTo(@(W(12)));
        make.width.height.equalTo(@18);
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.textColor = [UIColor blackColor];
    self.usernameTextField.font = [UIFont systemFontOfSize:16];
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
    passwordIcon.image = [UIImage imageWithName:@"password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.width.height.equalTo(@18);
        make.left.equalTo(@(W(12)));
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.font = [UIFont systemFontOfSize:16];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    
    self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.eyeBtn setImage:[UIImage imageWithName:@"eye_close"] forState:UIControlStateNormal];
    [self.eyeBtn setImage:[UIImage imageWithName:@"eye_open"] forState:UIControlStateSelected];
    [self.eyeBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBkg addSubview:self.eyeBtn];
    [self.eyeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(W(-12)));
        make.width.equalTo(@30);
        make.height.equalTo(@18);
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
    [self.accountBtn setImage:[UIImage imageWithName:@"remember_unselected"] forState:UIControlStateNormal];
    [self.accountBtn setImage:[UIImage imageWithName:@"remember_selected"] forState:UIControlStateSelected];
    self.accountBtn.titleLabel.font=[UIFont systemFontOfSize:15];
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
    [self.autoLoginBtn setImage:[UIImage imageWithName:@"remember_unselected"] forState:UIControlStateNormal];
    [self.autoLoginBtn setImage:[UIImage imageWithName:@"remember_selected"] forState:UIControlStateSelected];
    self.autoLoginBtn.titleLabel.font=[UIFont systemFontOfSize:15];
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
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#3ECE89"]] forState:UIControlStateNormal];
    [self addSubview:loginBtn];
    [loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.height.equalTo(passwordBkg);
        make.top.equalTo(self.autoLoginBtn.bottom).with.offset(H(20));
    }];
    
    // 自动化去掉
//    UIButton *vpnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [vpnBtn setTitle:@"VPN设置" forState:UIControlStateNormal];
//    [vpnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [vpnBtn setImage:[UIImage imageWithName:@"setting"] forState:UIControlStateNormal];
//    vpnBtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    vpnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, W(-10));
//    [vpnBtn addTarget:self action:@selector(vpnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:vpnBtn];
//    [vpnBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.bottom).offset(H(20));
//        make.right.equalTo(loginBtn.right);
//    }];

    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    UILabel *labVersion = [UILabel new];
    labVersion.text = [NSString stringWithFormat:@"V%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    labVersion.textColor = [UIColor whiteColor];
    labVersion.font = [UIFont systemFontOfSize:16];
    labVersion.textAlignment = NSTextAlignmentRight;
    [self addSubview:labVersion];
    [labVersion makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom).offset(-20);
        make.right.equalTo(self.right).offset(-30);
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
