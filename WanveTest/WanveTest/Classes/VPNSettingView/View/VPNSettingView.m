#import "VPNSettingView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "UserModel.h"
#import "UserManager.h"

@interface VPNSettingView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *accountTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *useBtn;
@property (nonatomic, strong) UIButton *unuseBtn;

@end

@implementation VPNSettingView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIButton *backBtn =[ UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"arrow_back_black"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"智慧政务管理平台";
    titleLab.textColor = [UIColor colorWithHex:0x2badda];
    titleLab.font = [UIFont systemFontOfSize:kfont(28)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    UILabel *welcomeCNLab = [UILabel new];
    welcomeCNLab.text = @"欢迎使用 VPN 接入系统";
    welcomeCNLab.textColor = [UIColor colorWithHex:0x252525];
    welcomeCNLab.font = [UIFont systemFontOfSize:kfont(16)];
    welcomeCNLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeCNLab];

    UILabel *welcomeENLab = [UILabel new];
    welcomeENLab.text = @"Welcome to the VPN access system";
    welcomeENLab.textColor = [UIColor colorWithHex:0x5C5C5C];
    welcomeENLab.font = [UIFont systemFontOfSize:kfont(16)];
    welcomeENLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:welcomeENLab];

    UIView *accountBkg = [UIView new];
    accountBkg.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    accountBkg.layer.cornerRadius = 5;
    accountBkg.clipsToBounds = YES;
    [self addSubview:accountBkg];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [accountBkg addSubview:userIcon];
    
    self.accountTextField = [UITextField new];
    self.accountTextField.placeholder = @"请输入vpn账号";
    self.accountTextField.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
    self.accountTextField.font = [UIFont systemFontOfSize:kfont(14)];
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTextField.clearsOnBeginEditing = NO;
    self.accountTextField.returnKeyType =UIReturnKeyNext;
    self.accountTextField.delegate = self;
    [accountBkg addSubview:self.accountTextField];

    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    passwordBkg.layer.cornerRadius = 5;
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入vpn密码";
    self.passwordTextField.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
    self.passwordTextField.font = [UIFont systemFontOfSize:kfont(14)];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.returnKeyType =UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    
    UILabel *useLab = [UILabel new];
    useLab.text = @"启用";
    useLab.textColor = [UIColor colorWithHex:0x3A3A3A];
    useLab.font = [UIFont systemFontOfSize:kfont(14)];
//    useLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:useLab];
    
    self.useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.useBtn setTitle:@"是" forState:UIControlStateNormal];
    [self.useBtn setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [self.useBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
    [self.useBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
    self.useBtn.titleLabel.font=[UIFont systemFontOfSize:kfont(14)];
    self.useBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kpw(-10));
    [self.useBtn addTarget:self action:@selector(useClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.useBtn];
    
    self.unuseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.unuseBtn setTitle:@"否" forState:UIControlStateNormal];
    [self.unuseBtn setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [self.unuseBtn setImage:[UIImage imageNamed:@"remember_unselected"] forState:UIControlStateNormal];
    [self.unuseBtn setImage:[UIImage imageNamed:@"remember_selected"] forState:UIControlStateSelected];
    self.unuseBtn.titleLabel.font=[UIFont systemFontOfSize:kfont(14)];
    self.unuseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kpw(-10));
    [self.unuseBtn addTarget:self action:@selector(unuseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.unuseBtn];
    
    
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kpw(0)));
        make.top.equalTo(@(kph(15)));
        make.width.height.equalTo(@44);
    }];
    
    [titleLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(@(kph(100)));
        make.width.equalTo(@(kpw(250)));
        make.height.equalTo(@(kph(30)));
    }];
    
    [welcomeCNLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLab.centerX);
        make.top.equalTo(titleLab.bottom).with.offset(kph(32));
        make.left.right.equalTo(@0);;
        make.height.equalTo(@(kph(18)));
    }];

    [welcomeENLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(welcomeCNLab.centerX);
        make.top.equalTo(welcomeCNLab.bottom).with.offset(kph(8));
        make.width.equalTo(welcomeCNLab.width);
        make.height.equalTo(@(kph(25)));
    }];

    [accountBkg makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(@(kpw(320)));
        make.height.equalTo(@(kph(44)));
        make.top.equalTo(welcomeENLab.bottom).with.offset(kph(50));
    }];

    [userIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accountBkg.centerY);
        make.left.equalTo(@(kpw(14)));
    }];

    [self.accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(userIcon.right).with.offset(kpw(10));
        make.width.equalTo(@(kpw(267.5)));
    }];

    [passwordBkg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountBkg.left);
        make.top.equalTo(accountBkg.bottom).with.offset(kph(25));
        make.width.height.equalTo(accountBkg);
    }];

    [passwordIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordBkg.mas_centerY);
        make.left.equalTo(@(kpw(14)));
    }];

    [self.passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self.accountTextField.left);
        make.width.equalTo(self.accountTextField.width);
    }];
    
    [useLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordBkg.left);
        make.top.equalTo(passwordBkg.bottom).with.offset(kph(27));
//        make.height.equalTo(@(kph(20)));
    }];

    [self.useBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(useLab.right).with.offset(kpw(10));
        make.centerY.equalTo(useLab.centerY);
    }];

    [self.unuseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.useBtn.right).with.offset(kpw(90));
        make.centerY.equalTo(self.useBtn.centerY);
    }];

    return self;
}

- (void)backClick:(UIButton *)sender
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    userModel.vpnAccount = self.accountTextField.text;
    userModel.vpnPassword = self.passwordTextField.text;
    [[UserManager sharedUserManager] saveUserModel:userModel];
    [_delegate didClickBackBtn];
}

- (void)useClick:(UIButton *)sender
{
    if([self isValid])
    {
        UIButton *btn = (UIButton *)sender;
        btn.selected = YES;
        self.unuseBtn.selected = NO;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isVPNLogin = YES;
        userModel.vpnAccount = self.accountTextField.text;
        userModel.vpnPassword = self.passwordTextField.text;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
}

- (void)unuseClick:(UIButton *)sender
{
    if([self isValid])
    {
        UIButton *btn = (UIButton *)sender;
        btn.selected = YES;
        self.useBtn.selected = NO;
        UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
        userModel.isVPNLogin = NO;
        userModel.vpnAccount = self.accountTextField.text;
        userModel.vpnPassword = self.passwordTextField.text;
        [[UserManager sharedUserManager] saveUserModel:userModel];
    }
}

- (BOOL)isValid
{
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(account.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入vpn账号"];
        return NO;
    }
    if(password.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入vpn密码"];
        return NO;
    }
    
    return YES;
}

- (void)reloadData
{
    UserModel *userModel = [[UserManager sharedUserManager] getUserModel];
    if(userModel.isVPNLogin)
    {
        self.useBtn.selected = YES;
        self.unuseBtn.selected = NO;
    }
    else
    {
        self.useBtn.selected = NO;
        self.unuseBtn.selected = YES;
    }
    self.accountTextField.text = userModel.vpnAccount;
    self.passwordTextField.text = userModel.vpnPassword;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.accountTextField == textField) {
        if ([self.passwordTextField canBecomeFirstResponder]) {
            [self.passwordTextField becomeFirstResponder];
            return NO;
        }
    }
    
    if (self.passwordTextField == textField) {
        [self.passwordTextField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldResignFirstResponder
{
    if ([self.accountTextField isFirstResponder])
        [self.accountTextField resignFirstResponder];
    
    if ([self.passwordTextField isFirstResponder])
        [self.passwordTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


@end
