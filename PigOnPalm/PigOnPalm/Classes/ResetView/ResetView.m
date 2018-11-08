#import "ResetView.h"
#import "UIColor+color.h"
#import "UIImage+image.h"

#define TIMECOUNT 60

@interface ResetView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *codeTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;
@property (nonatomic, strong) UIButton *accountBtn;
@property (nonatomic, strong) UIButton *autobtnRegister;
@property (nonatomic, strong) UIButton *btnRegister;
@property (nonatomic, strong) UIButton *btnCode;

@end

@implementation ResetView

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
        make.top.equalTo(self.top).offset(150);
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
        make.left.equalTo(userIcon.mas_right).with.offset(15);
        make.top.bottom.equalTo(usernameBkg);
        make.right.equalTo(usernameBkg.mas_right).offset(-30);
    }];
    
    UIView *codeBkg = [UIView new];
    codeBkg.backgroundColor = [UIColor clearColor];
    codeBkg.layer.cornerRadius = h/2.0;
    codeBkg.layer.borderWidth = 1;
    codeBkg.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    codeBkg.clipsToBounds = YES;
    [self addSubview:codeBkg];
    [codeBkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(usernameBkg.mas_left);
        make.top.equalTo(usernameBkg.mas_bottom).with.offset(15);
        make.width.height.equalTo(usernameBkg);
    }];
    
    UIButton *btnCode = [UIButton new];
    [btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnCode setTitleColor:[UIColor colorWithRGB:243 green:147 blue:49] forState:UIControlStateNormal];
    btnCode.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:btnCode];
    [btnCode makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(codeBkg);
        make.right.equalTo(codeBkg.right).offset(-30);
        make.width.equalTo(@150);
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
        make.top.bottom.equalTo(@0);
        make.left.equalTo(codeBkg.left).offset(30);
        make.right.equalTo(btnCode.left);
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
        make.top.equalTo(codeBkg.mas_bottom).with.offset(15);
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
    self.passwordTextField.placeholder = @"请输入新密码";
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
        make.top.bottom.equalTo(@0);
        make.left.right.equalTo(self.usernameTextField);
    }];

    self.btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnRegister setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.btnRegister addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRegister.layer setMasksToBounds:YES];
    [self.btnRegister.layer setCornerRadius:h/2.0];
    [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnRegister.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.btnRegister setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:243 green:147 blue:49]] forState:UIControlStateNormal];
    [self addSubview:self.btnRegister];
    [self.btnRegister makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordBkg.bottom).offset(44);
        make.left.right.height.equalTo(passwordBkg);
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
