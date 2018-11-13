#import "RegisterView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"
#import "YYText.h"

#define TIMECOUNT 60

@interface RegisterView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *codeTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *accountBtn;
@property (nonatomic, strong) UIButton *autobtnRegister;
@property (nonatomic, strong) UIButton *btnRegister;
@property (nonatomic, strong) UIButton *btnCode;

@end

@implementation RegisterView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
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
        make.top.mas_equalTo(self.mas_top).offset(150);
        make.left.mas_equalTo(self).offset(padding);
        make.right.mas_equalTo(self).offset(-padding);
        make.height.mas_equalTo(h);
    }];
    
    CGFloat imgW = 18;
    CGFloat imgH = 35/32.0 * imgW;
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.image = [UIImage imageNamed:@"user"];
    [usernameBkg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(usernameBkg.mas_centerY);
        make.left.mas_equalTo(@30);
        make.width.mas_equalTo(imgW);
        make.height.mas_equalTo(imgH);
    }];
    
    self.usernameTextField = [UITextField new];
    self.usernameTextField.placeholder = @"请输入手机号";
    self.usernameTextField.font = [UIFont systemFontOfSize:16];
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.usernameTextField.clearsOnBeginEditing = NO;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.usernameTextField.delegate = self;
    [usernameBkg addSubview:self.usernameTextField];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).with.offset(15);
        make.top.bottom.mas_equalTo(usernameBkg);
        make.right.mas_equalTo(usernameBkg.mas_right).offset(-30);
    }];
    
    UIView *codeBkg = [UIView new];
    codeBkg.backgroundColor = [UIColor clearColor];
    codeBkg.layer.cornerRadius = h/2.0;
    codeBkg.layer.borderWidth = 1;
    codeBkg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    codeBkg.clipsToBounds = YES;
    [self addSubview:codeBkg];
    [codeBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(usernameBkg.mas_left);
        make.top.mas_equalTo(usernameBkg.mas_bottom).with.offset(15);
        make.width.height.mas_equalTo(usernameBkg);
    }];
    
    UIButton *btnCode = [UIButton new];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnCode setTitleColor:[UIColor colorWithRGB:243 green:147 blue:49] forState:UIControlStateNormal];
    btnCode.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:btnCode];
    [btnCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(codeBkg);
        make.right.mas_equalTo(codeBkg.mas_right).offset(-30);
        make.width.mas_equalTo(@150);
    }];
    [btnCode addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnCode = btnCode;
    
    self.codeTextField = [UITextField new];
    self.codeTextField.placeholder = @"验证码";
    self.codeTextField.font = [UIFont systemFontOfSize:16];
    self.codeTextField.secureTextEntry = YES;
    self.codeTextField.clearsOnBeginEditing = NO;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.returnKeyType = UIReturnKeyNext;
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.delegate = self;
    [codeBkg addSubview:self.codeTextField];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(codeBkg.mas_left).offset(30);
        make.right.mas_equalTo(btnCode.mas_left);
    }];
    
    UIView *passwordBkg = [UIView new];
    passwordBkg.backgroundColor = [UIColor clearColor];
    passwordBkg.layer.cornerRadius = h/2.0;
    passwordBkg.layer.borderWidth = 1;
    passwordBkg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    passwordBkg.clipsToBounds = YES;
    [self addSubview:passwordBkg];
    [passwordBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(usernameBkg.mas_left);
        make.top.mas_equalTo(codeBkg.mas_bottom).with.offset(15);
        make.width.height.mas_equalTo(usernameBkg);
    }];
    
    imgH = 35/29.0 * imgW;
    
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [passwordBkg addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(passwordBkg.mas_centerY);
        make.left.mas_equalTo(userIcon);
        make.width.mas_equalTo(imgW);
        make.height.mas_equalTo(imgH);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:16];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearsOnBeginEditing = NO;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.delegate = self;
    [passwordBkg addSubview:self.passwordTextField];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(@0);
        make.left.right.mas_equalTo(self.usernameTextField);
    }];

    self.btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnRegister setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.btnRegister addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRegister.layer setMasksToBounds:YES];
    [self.btnRegister.layer setCornerRadius:h/2.0];
    [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnRegister.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.btnRegister setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:243 green:147 blue:49]] forState:UIControlStateNormal];
    [self addSubview:self.btnRegister];
    [self.btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordBkg.mas_bottom).offset(44);
        make.left.right.height.mas_equalTo(passwordBkg);
    }];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"注册使用掌上真猪即视为同意《掌上真猪软件注册协议》"];
    
    // 2. Set attributes to text, you can use almost all CoreText attributes.
    str.yy_font = [UIFont systemFontOfSize:12];
    str.yy_color = [UIColor lightGrayColor];
    [str yy_setColor:[UIColor colorWithRGB:243 green:147 blue:49] range:NSMakeRange(13, 12)];
    str.yy_lineSpacing = 10;
    
    UILabel *labAgreement = [UILabel new];
    labAgreement.attributedText = str;
    labAgreement.font = [UIFont systemFontOfSize:12];
    labAgreement.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labAgreement];
    [labAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).offset(-40);
        make.left.right.mas_equalTo(self);
    }];
    
    RAC(self.btnRegister, enabled) = [RACSignal
                                   combineLatest:@[self.usernameTextField.rac_textSignal,
                                                   self.codeTextField.rac_textSignal,
                                                   self.passwordTextField.rac_textSignal
                                                   ]
                                   reduce:^(NSString *account, NSString *code, NSString *password){
                                       return @(account.length > 0 && code.length > 0 && password.length > 0);
                                   }];
    
    return self;
}

- (void)registerClick:(UIButton *)sender
{
    [_delegate didRegisterWithUserName:self.usernameTextField.text code:self.codeTextField.text password:self.passwordTextField.text];
}

- (void)getCodeClick:(UIButton *)sender
{
    if(self.usernameTextField.text.length != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码位数不对"];
        return;
    }
    
    [_delegate didGetCode:self.usernameTextField.text];
}

- (void)countDown
{
    __block NSInteger second = TIMECOUNT;
    //(1)
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //(2)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //(3)
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //(4)
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                self.btnCode.enabled = YES;
                [self.btnCode setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
                second = TIMECOUNT;
                //(6)
                dispatch_cancel(timer);
            } else {
                self.btnCode.enabled = NO;
                [self.btnCode setTitle:[NSString stringWithFormat:@"(%ldS)后重新获取",second] forState:UIControlStateNormal];
                second--;
            }
        });
    });
    //(5)
    dispatch_resume(timer);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.usernameTextField == textField) {
        if ([self.codeTextField canBecomeFirstResponder]) {
            [self.codeTextField becomeFirstResponder];
            return NO;
        }
    }
    
    if (self.codeTextField == textField) {
        if ([self.passwordTextField canBecomeFirstResponder]) {
            [self.passwordTextField becomeFirstResponder];
            return NO;
        }
    }

    if (self.passwordTextField == textField) {
        [self registerClick:nil];
    }

    return YES;
}

- (void)textFieldResignFirstResponder
{
    if ([self.usernameTextField isFirstResponder])
        [self.usernameTextField resignFirstResponder];

    if ([self.codeTextField isFirstResponder])
        [self.codeTextField resignFirstResponder];
    
    if ([self.passwordTextField isFirstResponder])
        [self.passwordTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


@end
