//
//  VPNSettingVC.m
//  Template
//
//  Created by Apple on 2017/10/19.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "VPNSettingVC.h"

#import "VPNManager.h"

typedef enum {
    STA_IDEL,
    STA_LOGIN,
    STA_REGISTER
}LoginStatus;



@interface VPNSettingVC ()

@property (nonatomic,assign) LoginStatus loginStatus;

@end

@implementation VPNSettingVC{
    
    UIButton*_backBtn;
    UILabel*_label1;
    UILabel*_label2;
    UILabel*_label3;
    
    UIView*_userNameView;
    UIImageView*_userNameIcon;
    UITextField*_userNameTextfield;
    
    
    
    UIView*_pwdView;
    UIImageView*_pwdIcon;
    UITextField*_pwdTextfield;
    
    UILabel*_openStatusLabel;
    UIButton*_btn1;
    UIButton*_btn2;
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBar.hidden=YES;
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationItem.title = @"VPN设置";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationController.navigationBar.hidden=YES;
    
    //出这个页面的时候保存数据
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    model.vpnUserName=_userNameTextfield.text;
    model.vpnPwdName=_pwdTextfield.text;
    [DDGetUserInformationTool saveUserInformationWithModel:model];
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    [self creatUI];
    
    [self layout];
    
    [self getData];
    
    
    
    
    
    
}

- (void)configNav{
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kVPNMessageNotification object:nil];
    
    self.loginStatus = STA_IDEL;
    
}
- (void)creatUI{
    
    _backBtn =[ UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageWithFileName:@"返回-(3)"] forState:UIControlStateNormal];
    @weakify(self);
    _backBtn.block = ^(UIButton *btn) {
        @strongify(self);
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    };
    
    
    _label1 = [UILabel new];
    _label1.text = @"智慧政务管理平台";
    _label1.textColor = [UIColor colorWithHex:0x2badda];
    _label1.font = [UIFont systemFontOfSize:kfont(28)];
    _label1.textAlignment = NSTextAlignmentCenter;
    
    _label2 = [UILabel new];
    _label2.text = @"欢迎使用 VPN 接入系统";
    _label2.textColor = [UIColor colorWithHex:0x252525];
    _label2.font = [UIFont systemFontOfSize:kfont(16)];
    _label2.textAlignment = NSTextAlignmentCenter;
    
    
    _label3 = [UILabel new];
    _label3.text = @"Welcome to the VPN access system";
    _label3.textColor = [UIColor colorWithHex:0x5C5C5C];
    _label3.font = [UIFont systemFontOfSize:kfont(11)];
    _label3.textAlignment = NSTextAlignmentCenter;
    
    
    _userNameView = [UIView new];
    
    
    _userNameIcon = [UIImageView new];
    _userNameIcon.image = [UIImage imageWithFileName:@"个人-(2)"];
    
    
    _userNameTextfield = [UITextField new];
    _userNameTextfield.placeholder = @"vpn帐号";
    _userNameTextfield.textColor = [UIColor colorWithHex:0x3A3A3A];
    _userNameTextfield.font = [UIFont systemFontOfSize:kfont(14)];
    _userNameTextfield.clearsOnBeginEditing = NO;
    
    

    
    
    [_userNameView addSubview:_userNameIcon];
    [_userNameView addSubview:_userNameTextfield];
    
    
    
    
    
    
    
    _pwdView= [UIView new];
    
    
    _pwdIcon = [UIImageView new];
    _pwdIcon.image = [UIImage imageWithFileName:@"密码-(2)"];
    
    
    _pwdTextfield = [UITextField new];
    _pwdTextfield.placeholder = @"vpn密码";
    _pwdTextfield.textColor = [UIColor colorWithHex:0x3A3A3A];
    _pwdTextfield.font = [UIFont systemFontOfSize:kfont(14)];
    _pwdTextfield.clearsOnBeginEditing = NO;
    
    

    
    
    [_pwdView addSubview:_pwdIcon];
    [_pwdView addSubview:_pwdTextfield];
    
    
    _openStatusLabel=[UILabel new];
    _openStatusLabel.text=@"启用";
    _openStatusLabel.textColor=[UIColor colorWithHex:0x3A3A3A];
    _openStatusLabel.font=[UIFont systemFontOfSize:kfont(14)];
    
    
    
    
    _btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setTitle:@"是" forState:UIControlStateNormal];
    [_btn1 setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageWithFileName:@"1-登录-记住密码-拷贝"] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageWithFileName:@"1-登录-记住密码"] forState:UIControlStateSelected];
    _btn1.titleLabel.font=[UIFont systemFontOfSize:kfont(14)];
    _btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kpt(-10));
    
    _btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 setTitle:@"否" forState:UIControlStateNormal];
    [_btn2 setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageWithFileName:@"1-登录-记住密码-拷贝"] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageWithFileName:@"1-登录-记住密码"] forState:UIControlStateSelected];
    _btn2.titleLabel.font=[UIFont systemFontOfSize:kfont(14)];
    _btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kpt(-10));
    
    
    
    [_btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _userNameView.backgroundColor = [UIColor colorWithHex:0xE4E4E4 alpha:0.5];
    _userNameView.layer.cornerRadius=kfont(5);
    _userNameView.clipsToBounds=YES;
    
    _pwdView.backgroundColor = [UIColor colorWithHex:0xE4E4E4 alpha:0.5];
    _pwdView.layer.cornerRadius=kfont(5);
    _pwdView.clipsToBounds=YES;
    
    
    
    [self.view addSubview:_backBtn];
    [self.view addSubview:_label1];
    [self.view addSubview:_label2];
    [self.view addSubview:_label3];
    [self.view addSubview:_userNameView];
    [self.view addSubview:_pwdView];
    [self.view addSubview:_openStatusLabel];
    [self.view addSubview:_btn1];
    [self.view addSubview:_btn2];
 
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    if(model.vpnUserName!=nil&&model.vpnPwdName!=nil){
        
        _userNameTextfield.text=model.vpnUserName;
        
        _pwdTextfield.text=model.vpnPwdName;
        
        
    }
    
    
    if([model.isOpenLogin isEqualToString:@"1"]){
        
        
        _btn1.selected=YES;
        _btn2.selected=NO;
        
        
    }else{
        
        _btn1.selected=NO;
        _btn2.selected=YES;
        
        
    }
    
    
    
}
- (void)layout{
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(15)));
        make.top.equalTo(@(kph(25)));
        
        
    }];
    
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(kph(100)));
        make.width.equalTo(@(kpt(250)));
        make.height.equalTo(@(kph(30)));
        
        
        
    }];
    
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerX.equalTo(_label1.mas_centerX);
        make.top.equalTo(_label1.mas_bottom).with.offset(kph(32));
        make.width.equalTo(@(kpt(200)));
        make.height.equalTo(@(kph(18)));
        
    }];
    
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_label2.mas_centerX);
        make.top.equalTo(_label2.mas_bottom).with.offset(kph(8));
        make.width.equalTo(@(kpt(200)));
        make.height.equalTo(@(kph(25)));
        
        
    }];
    
    [_userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(@(kpt(20)));
        make.top.equalTo(_label3.mas_bottom).with.offset(kph(60));
        make.width.equalTo(@(kpt(320)));
        make.height.equalTo(@(kph(45)));
        
        
        
        
    }];
    
    [_userNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_userNameView.mas_centerY);
        make.left.equalTo(@(kpt(14)));
        
        
    }];
    
    [_userNameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.bottom.equalTo(@0);
        make.left.equalTo(_userNameIcon.mas_right).with.offset(kpt(10));
//        make.width.equalTo(@(kpt(280)));
        make.right.equalTo(@0);
        make.height.equalTo(@(kph(45)));
        
    }];
    
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(20)));
        make.top.equalTo(_userNameView.mas_bottom).with.offset(kph(25));
        make.width.equalTo(@(kpt(320)));
        make.height.equalTo(@(kph(45)));
        
    }];
    
    [_pwdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.equalTo(_pwdView.mas_centerY);
        make.left.equalTo(@(kpt(14)));
        
    }];
    
    [_pwdTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.bottom.equalTo(@0);
        make.left.equalTo(_pwdIcon.mas_right).with.offset(kpt(10));
        //        make.width.equalTo(@(kpt(280)));
        make.right.equalTo(@0);
        make.height.equalTo(@(kph(45)));
        
    }];
    
    [_openStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pwdView.mas_left);
        make.top.equalTo(_pwdView.mas_bottom).with.offset(kph(27));
        make.height.equalTo(@(kph(20)));
        
        
        
    }];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_openStatusLabel.mas_right).with.offset(kpt(10));
        make.centerY.equalTo(_openStatusLabel.mas_centerY);
        
        
        
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_btn1.mas_right).with.offset(kpt(90));
        make.centerY.equalTo(_openStatusLabel.mas_centerY);
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
- (void)getData{}




- (void)btn1Action:(UIButton*)button {
    
    if (![self isValid]) {
        
        return;
    }
    
    //先看登不登的上去,登上去,存储,不上,不存储.
    
//    [self loginVpn];
    
     [self openVpn:nil];
    
//    if (!button.selected) {
//        
//
//
//    }else{
//
//
//        [[VPNManager sharedVPNManager]stopVPN];//停止VPN
//
//
//    }
    
    
    
    
    
 
    
    
}

- (void)openVpn:(UIButton*)button{
    
    button = _btn1;
    

        
    _btn1.selected=YES;
    _btn2.selected=NO;
        
    
    
    if(button.selected){
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        model.isOpenLogin = @"1";
        model.vpnUserName=_userNameTextfield.text;
        model.vpnPwdName=_pwdTextfield.text;
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        
        
    }else{
        
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        model.isOpenLogin = @"0";
        model.vpnUserName=_userNameTextfield.text;
        model.vpnPwdName=_pwdTextfield.text;
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        
    }
    
}

- (void)btn2Action:(UIButton*)button {
    

//
//    if (button.selected) {
//
//        button.selected=!button.selected;
//
//    }else{
    
    _btn1.selected=NO;
        
    _btn2.selected=YES;
    
//    }
    
    if (_btn2.selected) {
        
//        [[VPNManager sharedVPNManager]stopVPN];
//        
//        self.loginStatus = STA_IDEL ;
        
    }
    
        
    if(button.selected){
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        model.isOpenLogin = @"0";
        model.vpnUserName=_userNameTextfield.text;
        model.vpnPwdName=_pwdTextfield.text;
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        
        
    }else{
        
        if (_btn1.selected) {
            
            DDModel*model = [DDGetUserInformationTool getUserInformation];
            model.isOpenLogin = @"1";
            model.vpnUserName=_userNameTextfield.text;
            model.vpnPwdName=_pwdTextfield.text;
            [DDGetUserInformationTool saveUserInformationWithModel:model];
            
        }
        
       
        
        
    }
    
}


- (BOOL)isValid{
    
    if (_userNameTextfield.text.length>0 &&_pwdTextfield.text.length>0) {
        
        
        return YES;
        
    }else{
        
        [MBProgressHUD showError:@"请填写完整"];
        
        return NO;
        
        
    }
    
    
    
    
}

- (void)handleMessage:(NSNotification *)n
{
    [self handleVPNMessage:n.object];
}


- (void)handleVPNMessage:(VPNMessage *)message
{
    VPNManager *manager = [VPNManager sharedVPNManager];
    int error = [VPNManager sharedVPNManager].errorCode;
    NSLog(@"<handleVPNMessage> %@, errorcode: %d",message,[VPNManager sharedVPNManager].errorCode);
    
    
    if (message.code == VPN_CB_CONNECTED) {
        self.loginStatus = STA_IDEL;
        //        [self showLoginActivity:NO];
        
        //        [self performSegueWithIdentifier:@"loginsucc" sender:self];
        
        NSLog(@"登录成功");
        
       
        //
        //        WebVC*vc = [WebVC new];
        //
        //        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    } else if (message.code == VPN_CB_DISCONNECTED) {
        self.loginStatus = STA_IDEL;
        //        [self showLoginActivity:NO];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"MotionProFgo disconnected",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil, nil];
        
        [alert show];
    } else if (message.code == VPN_CB_CONN_FAILED) {
        self.loginStatus = STA_IDEL;
        //        [self showLoginActivity:NO];
        
        NSString *aMessage;
        BOOL showAlert = YES;
        switch (error) {
            case ERR_DEVID_APPROVE_PENDING:
                aMessage = NSLocalizedString(@"Your device is registering, please request manager approval",nil);
                break;
            case ERR_DEVID_APPROVE_DENY:
                aMessage = NSLocalizedString(@"Register device deny, not allow register device auto approve",nil);
                break;
            case ERR_DEVID_USER_LIMIT:
                aMessage = NSLocalizedString(@"User for this device has reached his or her limit",nil);
                break;
            case ERR_DEVID_DEV_LIMIT:
                aMessage = NSLocalizedString(@"Device has reached its limit",nil);
                break;
            case ERR_WRONG_USER_PASS:
                aMessage = NSLocalizedString(@"Login failed, please check username and password",nil);
                break;
            case ERR_CALLBACK_FAILED:
                showAlert = NO;
                break;
            case ERR_CERT_NO:
                aMessage = NSLocalizedString(@"Please select a certificate", nil);
                break;
            case ERR_CERT_INVALID_SIGNTURE:
                aMessage = NSLocalizedString(@"The certificate of client has an invalid signature", nil);
                break;
            case ERR_CERT_UNTRUSTED:
                aMessage = NSLocalizedString(@"The certificate of client is untrusted", nil);
                break;
            case ERR_CERT_EXPIRED:
                aMessage = NSLocalizedString(@"The certificate of client is expired", nil);
                break;
            case ERR_CERT_INVALID:
                aMessage = NSLocalizedString(@"The certificate of client is invalid", nil);
                break;
            case ERR_CERT_REVOKED:
                aMessage = NSLocalizedString(@"The certificate of client is revoked", nil);
                break;
            default:
                aMessage = NSLocalizedString(@"Connection to server failed",nil);
                NSLog(@"connect to server failed");
                showAlert = YES;
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:aMessage
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil, nil];
        
        if (showAlert) {
            // alert.tag = LOGIN_FAILED_ALERT_TAG;
            [alert show];
        }
    } else if (message.code == VPN_CB_DEVID_REG) {
        //        [self showLoginActivity:NO];
        
        //        [self.btnLogin setTitle:@"Register" forState:UIControlStateNormal];
        self.loginStatus = STA_REGISTER;
        
        [[[UIAlertView alloc] initWithTitle:@"WORING"
                                    message:@"Your device has not been registered, please register it first"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        //        self.allMethods = message.object;
        //        [self resetTableDictWithMethod:[self selectMethod]];
        //        [self.tableView reloadData];
    } else if (message.code == VPN_CB_LOGIN) {
        //        [self showLoginActivity:NO];
        if (error == ERR_WRONG_USER_PASS) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"Login failed, please check username and password",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        //when the login account wrong and try count less max count, or register succeful and redirct to login again or the register wrong.
        
        if (self.loginStatus == STA_REGISTER && message.error == ERR_SUCCESS) {
            //when the register success
            
            self.loginStatus = STA_IDEL;
            //return;
        }
        //        self.allMethods = manager.allAAAMehtods;
        //        [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
        self.loginStatus = STA_LOGIN;
//        self.loginStatus = STA_IDEL;
        
        //        [self resetTableDictWithMethod:[self selectMethod]];
        //        [self.tableView reloadData];
    }
    
    
    
    
    
}



- (void)showLoginActivity:(BOOL)aBool
{
    static UIControl *darkControl;
    if (!darkControl) {
        darkControl = [[UIControl alloc] initWithFrame:self.view.frame];
        darkControl.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        [darkControl addTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    }
    
    if (aBool) {
        UIActivityIndicatorView *a = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActionSheetStyleBlackOpaque];
        [a startAnimating];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [view addSubview:a];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(a.frame.size.width + 5, 0, 70, 20)];
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor whiteColor];
        
        UIFont * font = [UIFont boldSystemFontOfSize:17];
        label.font = font;
        label.text = NSLocalizedString(@"Verifying", nil);
        label.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        
        [self.view endEditing:YES];
        //        self.navItem.titleView = view;
        [self.view addSubview:darkControl];
        
    } else {
        //        self.navItem.titleView = nil;
        //        self.navItem.title = NSLocalizedString(@"Login", nil);
        [darkControl removeFromSuperview];
    }
}

//登录vpn
- (void)loginVpn{
    
    NSString*host = [NSString string];
    
    NSString*path = [[NSBundle mainBundle]pathForResource:@"Setting.plist" ofType:nil];
    
    if (path) {
        
        NSDictionary*dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
        
        
        if ([dict.allKeys containsObject:@"vpnHost"]) {
            
            host = dict[@"vpnHost"];
            
        }else{
            
            
            host = @"mobile.dg.cn";
            
            
            
        }
        
        
        
    }
    
    
//    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
//    if ([model.isOpenLogin isEqualToString:@"1"]) {//开启了vpn
    
        if (self.loginStatus == STA_IDEL) {
            
            
            //        mobile.dg.cn  13728179021  759164
            VPNAccount *accout = [[VPNAccount alloc] initWithHost:host userName:_userNameTextfield.text passWord:_pwdTextfield.text];
            //            @"mobile.dg.cn"
            //13728179021
            //759164
            
            [[VPNManager sharedVPNManager] setLogLevel:0];
            //  accout.certificatePath = [[NSBundle mainBundle] pathForResource:@"client2" ofType:@"p12"];
            [[VPNManager sharedVPNManager] startVPN:accout];
            
            
            
        }
        
        
        
//    }
    
    
    
}


@end
