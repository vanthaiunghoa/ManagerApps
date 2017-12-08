#import "LoginView.h"
#import "SVProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIColor+color.h"

@interface LoginView ()<UITextFieldDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UITextField  *usernameTextField;
@property (nonatomic, strong) UITextField  *passwordTextField;

@end

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.bounds];
        
        [self addSubview:self.scrollView];

        [self initView];
    }
    return self;
}

- (void)initView
{
    CGFloat x = 15;
    CGFloat y = 0.35*SCREEN_HEIGHT;
    CGFloat h = 44;
    CGFloat w = SCREEN_WIDTH - 2.0*x;
    CGFloat margin = 25;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
   
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameTextField.placeholder = @"请输入用户名";
    self.usernameTextField.text = username;
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.usernameTextField.secureTextEntry = YES;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.returnKeyType =UIReturnKeyNext;
    self.usernameTextField.keyboardType = UIKeyboardTypeDefault;
    self.usernameTextField.delegate = self;
//    [self addSubview:self.usernameTextField];
    [self.scrollView addSubview:self.usernameTextField];

    y += h + margin;
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.placeholder = @"请输入密码";
    self.passwordTextField.text = password;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.delegate = self;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.returnKeyType =UIReturnKeyDone;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
//    [self addSubview:self.passwordTextField];
    [self.scrollView addSubview:self.passwordTextField];
    
    y += h + margin;
    
    UIButton *longinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [longinBtn setTitle:@"登陆" forState:UIControlStateNormal];
//    [longinBtn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//    [longinBtn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [longinBtn setBackgroundColor:UIColor.redColor];
    [longinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [longinBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [longinBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [longinBtn.layer setMasksToBounds:YES];
    [longinBtn.layer setCornerRadius:5.0];
    longinBtn.frame = CGRectMake(x, y,w, h);
  
//    longinBtn.userInteractionEnabled = NO;
//    [longinBtn titleColorForState:UIControlStateHighlighted];
//    [longinBtn imageForState:UIControlStateHighlighted];
//    [longinBtn setBackgroundColor:[UIColor colorWithRed:50/255 green:50/255 blue:30/255 alpha:1]];
    [longinBtn setBackgroundColor:[UIColor colorWithHexString : @"#FFC125"]];
    [self.scrollView addSubview:longinBtn];
//    [longinBtn sizeToFit];
}


- (void)loginClick:(UIButton *)button
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(username.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return;
    }
    if(password.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return;
    }
    
//    [SVProgressHUD showWithStatus:@"正在登录中，请稍等..." maskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在登录中，请稍等..."];
    [_delegate didClickLoginBtn:self.usernameTextField.text withPwd:self.passwordTextField.text];
}

//-(void)read
//{
//    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
//    BOOL isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoLogin"];
//}

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
        [textField resignFirstResponder];
        [self loginClick:nil];
    }
    
    return YES;
}

//- (void)textFieldResignFirstResponder
//{
//    if ([self.usernameTextField isFirstResponder])
//        [self.usernameTextField resignFirstResponder];
//    
//    if ([self.passwordTextField isFirstResponder])
//        [self.passwordTextField resignFirstResponder];
//    
//    PLog(@"zifuchuandebianhua2222");
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    return YES;
//}
//
//// 隐藏键盘
//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
//    
//    [self endEditing:YES];
//    
//}

@end
