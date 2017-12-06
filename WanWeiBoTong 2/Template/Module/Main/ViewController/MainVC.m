
//  MainVC.m
//  Template
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "MainVC.h"

#import "UINavigationController+WXSTransition.h"

#import "VPNSettingVC.h"

#import "VPNManager.h"
#import "WebVC.h"

#import "MBProgressHUD+MJ.h"

#import "webTwoVC.h"

typedef enum {
    STA_IDEL,
    STA_LOGIN,
    STA_REGISTER
}LoginStatus;

@interface MainVC ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *allMethods;

@property (nonatomic,assign) LoginStatus loginStatus;

@property (nonatomic , strong )  UITextField*  userNameTextfield ;

@property (nonatomic , strong ) UITextField*    pwdTextfield ;



@end

@implementation MainVC{
    
    UIImageView*_icon;
    UILabel*_titleLabel;
    
    UIView*_userNameView;
    UIImageView*_userNameIcon;
   
    UIImageView*_userRightImg;
    
    
    UIView*_pwdView;
    UIImageView*_pwdIcon;
    
    UIImageView*_pwdRightImg;
    
    
    UIButton*_btn1;
    UIButton*_btn2;
    
    
    UIButton*_loginBtn;
    
    UILabel*_setLabel;
    UIImageView*_setImg;
    
    
    UIButton*_settingBtn;
    
    
    UIButton*_bigBtn;
    
    BOOL _isFirst;
    
    BOOL _VPNLogin;
    
    BOOL _isYetLoginVPN;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationItem.title=@"登录";
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    model.twoLogin = @"0";
    
    [DDGetUserInformationTool saveUserInformationWithModel:model];

    if ([model.isLogout isEqualToString:@"1"]) {

        _userNameTextfield.text = @"";
        _pwdTextfield.text = @"";
        _btn1.selected = NO;
        _btn2.selected = NO;

    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kVPNMessageNotification object:nil];
    
    


    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//  self.navigationController.navigationBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    _loginBtn.selected = NO;
    
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    model.isLogout = @"0";

    [DDGetUserInformationTool saveUserInformationWithModel:model];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVPNMessageNotification object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    [self creatUI];
    
    [self layout];
    
    [self getData];
    

}

-(void)configNav{
    
    self.view.backgroundColor=[UIColor whiteColor];

 
    
}
-(void)creatUI{
    
    _icon = [UIImageView new];
    _icon.image = [UIImage imageWithFileName:@"logo_company"];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"智慧政务管理平台";
    _titleLabel.textColor = [UIColor colorWithHex:0x132E65];
    _titleLabel.font = [UIFont systemFontOfSize:kfont(20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _userNameView = [UIView new];
    
    
    _userNameIcon = [UIImageView new];
    _userNameIcon.image = [UIImage imageWithFileName:@"个人-(2)"];
    
    
    _userNameTextfield = [UITextField new];
    _userNameTextfield.placeholder = @"请输入用户名";
    _userNameTextfield.textColor = [UIColor colorWithHex:0x3A3A3A];
    _userNameTextfield.font = [UIFont systemFontOfSize:kfont(14)];
   _userNameTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextfield.clearsOnBeginEditing = NO;
    
    
    _userRightImg = [UIImageView new];
    _userRightImg.image = [UIImage imageWithFileName:@""];
    _userRightImg.hidden=YES;
    
    
    [_userNameView addSubview:_userNameIcon];
    [_userNameView addSubview:_userNameTextfield];
    [_userNameView addSubview:_userRightImg];
    
    
    
    
    
    
    _pwdView= [UIView new];
    
    
    _pwdIcon = [UIImageView new];
    _pwdIcon.image = [UIImage imageWithFileName:@"密码-(2)"];
    
    
    _pwdTextfield = [UITextField new];
    _pwdTextfield.placeholder = @"请输入密码";
    _pwdTextfield.textColor = [UIColor colorWithHex:0x3A3A3A];
    _pwdTextfield.font = [UIFont systemFontOfSize:kfont(14)];
    _pwdTextfield.secureTextEntry=YES;
    _pwdTextfield.clearsOnBeginEditing = NO;
    _pwdTextfield.delegate = self;
    
    
    _pwdRightImg = [UIImageView new];
    _pwdRightImg.image = [UIImage imageWithFileName:@"闭眼"];
    _pwdRightImg.tag=0;
    
//    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pwdIsSecure:)];
//    _pwdRightImg.userInteractionEnabled=YES;
//    [_pwdRightImg addGestureRecognizer:tap];
    
    _bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_bigBtn addTarget:self action:@selector(pwdIsSecure:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_pwdView addSubview:_pwdIcon];
    [_pwdView addSubview:_pwdTextfield];
    [_pwdView addSubview:_pwdRightImg];
    [_pwdView addSubview:_bigBtn];
    
    _btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setTitle:@"记住账号" forState:UIControlStateNormal];
    [_btn1 setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageWithFileName:@"1-登录-记住密码-拷贝"] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageWithFileName:@"1-登录-记住密码"] forState:UIControlStateSelected];
    _btn1.titleLabel.font=[UIFont systemFontOfSize:kfont(14)];
    _btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kpt(-10));
    
    _btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 setTitle:@"自动登录" forState:UIControlStateNormal];
    [_btn2 setTitleColor:[UIColor colorWithHex:0x3A3A3A] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageWithFileName:@"1-登录-记住密码-拷贝"] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageWithFileName:@"1-登录-记住密码"] forState:UIControlStateSelected];
    _btn2.titleLabel.font=[UIFont systemFontOfSize:kfont(14)];
    _btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kpt(-10));
    
    
    [_btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font=[UIFont systemFontOfSize:kfont(18)];
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x2badda]] forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = kfont(10);
    _loginBtn.clipsToBounds =  YES;
    
    
    @weakify(self);
    _loginBtn.block = ^(UIButton *btn) {
        @strongify(self);
        
        [self loginBtnAction:btn];
        
        
    };
    
    _setLabel=[UILabel new];
    _setLabel.text=@"VPN设置";
    _setLabel.textColor=[UIColor colorWithHex:0x3A3A3A];
    _setLabel.font=[UIFont systemFontOfSize:kfont(14)];
    
    
    _setImg = [UIImageView new];
    _setImg.image =[ UIImage imageWithFileName:@"设置-(1)"];
    
    
    
    _settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];

    
    _settingBtn.block = ^(UIButton *btn) {
        @strongify(self);
        
        VPNSettingVC*vc=[VPNSettingVC new];
        
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        
        model.isGotoVpn = @"1";
        
        
        model.tempName=self.userNameTextfield.text;
        
        model.tempPwd=self.pwdTextfield.text;
        
        [DDGetUserInformationTool saveUserInformationWithModel:model];

        [self wxs_presentViewController:vc animationType:WXSTransitionAnimationTypeSysPushFromRight completion:^{
            
        }];
        
        
        
        
        
    };
    
    _userNameView.backgroundColor = [UIColor colorWithHex:0xE4E4E4 alpha:0.5];
    _userNameView.layer.cornerRadius=kfont(5);
    _userNameView.clipsToBounds=YES;
    
    _pwdView.backgroundColor = [UIColor colorWithHex:0xE4E4E4 alpha:0.5];
    _pwdView.layer.cornerRadius=kfont(5);
    _pwdView.clipsToBounds=YES;
    
    
    
    
    [self.view addSubview:_icon];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_userNameView];
    [self.view addSubview:_pwdView];
    [self.view addSubview:_btn1];
    [self.view addSubview:_btn2];
    
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_setLabel];
    [self.view addSubview:_setImg];
    
    [self.view addSubview:_settingBtn];
    
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    if(model.userName!=nil){
        
        _userNameTextfield.text=model.userName;
        
        if (model.pwdName != nil) {
            
            
            _pwdTextfield.text=model.pwdName;
        }
        
        
        
        
        
    }
    
   
    
    if([model.isRecode isEqualToString:@"1"]){
        
        
        _btn1.selected=YES;
        
    }else{
        
        
         _btn1.selected=NO;
    }
    
    
   //自动登录
    if([model.isAutoLogin isEqualToString:@"1"]){
    
        [self loginBtnAction:nil];
        
        _btn2.selected=YES;
    
    }
    
    
}

- (void)autoAction:(UIButton*)btn{
    
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    if([model.isAutoLogin isEqualToString:@"1"]){
        
        
        _btn1.selected=YES;
        _btn2.selected=YES;
        
//        [self loginBtnAction:_loginBtn];
        
        
    }else{
        
        _btn2.selected=NO;
        
    }
    
    
     [self loginNormal:_loginBtn];//登录
    
}

- (void)layout{
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(kph(93)));
        make.width.equalTo(@(kpt(119)));
        make.height.equalTo(@(kph(62)));
        
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_icon.mas_centerX);
        make.top.equalTo(_icon.mas_bottom).with.offset(kph(14));
        make.width.equalTo(@(kpt(200)));
        make.height.equalTo(@(kph(25)));
        
        
        
    }];
    
    [_userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(@(kpt(20)));
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(kph(50));
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
        
        make.width.equalTo(@(kpt(267.5)));//280
        
        make.height.equalTo(@(kph(45)));
        
        
        
    }];
    
    [_userRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(kpt(-14)));
        
         make.centerY.equalTo(_userNameView.mas_centerY);
        
        
        
        
    }];
    
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_userNameView.mas_left);
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
        make.width.equalTo(@(kpt(280)));
        make.height.equalTo(@(kph(45)));
        
        
        
    }];
    
    [_pwdRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(kpt(-14)));
        make.centerY.equalTo(_pwdView.mas_centerY);
        
//        make.width.equalTo(@(kpt(18)));
//        
//        make.height.equalTo(@(kph(30)));
        
    }];
    
    [_bigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        make.right.equalTo(@0);
        
        make.top.bottom.equalTo(@0);
        
        make.width.equalTo(@(kpt(60)));
        
        
        
    }];
    
    
    
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(35)));
        make.top.equalTo(_pwdView.mas_bottom).with.offset(kph(20));
  
        
        
        
        
    }];
    
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.equalTo(_btn1.mas_centerY);
        make.right.equalTo(_pwdView.mas_right);
        
        
        
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(kpt(320)));
        make.height.equalTo(@(kph(42)));
        make.top.equalTo(_btn1.mas_bottom).with.offset(kph(20));
        
        
        
    }];
    
    [_setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_setImg.mas_left).with.offset(kpt(-6));
        
        make.centerY.equalTo(_setImg.mas_centerY);
        
        
        
        
    }];
    
    [_setImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.right.equalTo(@(kpt(-20)));
        make.bottom.equalTo(@(kph(-35)));
        
        
        
        
        
    }];
    
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_setLabel.mas_left);
        make.right.equalTo(_setImg.mas_right);
        make.top.equalTo(_setLabel.mas_top);
        make.bottom.equalTo(_setLabel.mas_bottom);
        
        
        
    }];
    
    
    
    
    
    
    
    
    
    
    
    
}
- (void)getData{}



- (void)pwdIsSecure:(UITapGestureRecognizer*)tap{
    
    
    _pwdTextfield.secureTextEntry=!_pwdTextfield.secureTextEntry;
    
    if (_pwdTextfield.secureTextEntry) {//要
        
        _pwdRightImg.image = [UIImage imageWithFileName:@"闭眼"];
        
    }else{
        
         _pwdRightImg.image = [UIImage imageWithFileName:@"Bitmap"];
        
    }
    
    
    
    
    
}



/**
 记住账号

 @param button 按钮
 */
- (void)btn1Action:(UIButton*)button {
    
    if (![self isValidOne]) {
        
        return;
    }
    
    
    button.selected=!button.selected;
    
 
    if(button.selected){
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        
        model.isRecode = @"1";
        model.userName=_userNameTextfield.text;
//        model.pwdName=_pwdTextfield.text;
        
        
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        
        
    }else{
        
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        model.isRecode = @"0";
        model.userName=nil;
//        model.pwdName=nil;
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        
        if (_btn2.selected) {
            
            [self btn2Action:_btn2];
        }
        
    }

    
    
}



/**
 自动登录

 @param button 按钮
 */
- (void)btn2Action:(UIButton*)button {
    
    if (![self isValid]) {
        
        return;
    }
    
    
    button.selected=!button.selected;
    
    
    if(button.selected){
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        model.isAutoLogin = @"1";
        model.userName=_userNameTextfield.text;
        model.pwdName=_pwdTextfield.text;
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        _btn1.selected=YES;
        
    }else{
        
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        model.isAutoLogin = @"0";
//        model.userName=nil;
        model.pwdName=nil;
        [DDGetUserInformationTool saveUserInformationWithModel:model];
        
        
    }
    
    
}



/**
 登录

 @param button 按钮
 */
- (void)loginBtnAction:(UIButton*)button{
    
    _isFirst = NO;
    
    self.loginStatus = STA_IDEL;
    
//    button.selected = !button.selected;
//
//    if (!button.selected) {
//
//        return;
//    }
    
//    http://121.15.203.82:9210/DMS_Phone/Login/LoginHandler.ashx?Action=Login&cmd={UserID:%27cwq%27,UserPsw:%27123456%27}
    
    if(_userNameTextfield.text.length<=0||_pwdTextfield.text.length<=0){
        
        [MBProgressHUD showError:@"请填写完整"];
        
        return;
    }
    
  
     //正常登录
//     [self loginNormal:button];
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    if ([model.isOpenLogin isEqualToString:@"1"]) {
        
        
        if (_isYetLoginVPN){
            
             [self loginNormal:button];
            
            
        }else{
            
        [self loginVpn];
            
        }
        
    }else{
        
        
        [self loginNormal:button];
        
    }
    
    
}

- (void)loginNormal:(UIButton*)button{
    
    
    MBProgressHUD*hud = [MBProgressHUD showMessage:@"请稍候..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud setHidden:YES];
    });
    
    
    NSMutableDictionary*param = [NSMutableDictionary dictionary];
    //    param[@"UserID"]=_userNameTextfield.text;
    //    param[@"UserPsw"]=_pwdTextfield.text;
    
    param[@"Action"]=@"Login";
    param[@"cmd"]=[NSString stringWithFormat:@"{UserID:\'%@\',UserPsw:\'%@\'}",_userNameTextfield.text,_pwdTextfield.text];
    
    param[@"appName"]=@"iOS";
    
    //    param[@"Action"]=@"Login";
    //    param[@"cmd"]=@"{UserID:\'cwq\',UserPsw:\'123456\'}";
    
    
    NSString*url = [NSString stringWithFormat:@"%@/Login/LoginHandler.ashx",BaseUrl];
//    http://121.15.203.82:9210/DMS_Phone/Login/LoginHandler.ashx
    //                    ?Action=Login&cmd={UserID:%@,UserPsw:%@}",_userNameTextfield.text,_pwdTextfield.text];
    
    
    
    [DDNetworkTool GET:url parameters:param success:^(id responseObject) {
        
        NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"dict===%@",dict);
        
        [hud setHidden:YES];
        
        if([dict.allKeys containsObject:@"Result"]&&[dict.allKeys containsObject:@"Message"]){
            
            if([dict[@"Result"] isEqual:@1]){
                
                [[NSUserDefaults standardUserDefaults]setValue:_userNameTextfield.text forKey:@"userNameStr"];
                
                [[NSUserDefaults standardUserDefaults]setValue:_pwdTextfield.text forKey:@"pwdStr"];
                
                [self gotoMain:button];
                
                
            }else{
                
                
                
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",dict[@"Message"]]];
                
            }
            
            
        }
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        [hud setHidden:YES];
        
    }];
    
    
    
    
    
    NSLog(@"登录");
    
    
}


/**
 登录VPN
 */
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
    
    
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    if ([model.isOpenLogin isEqualToString:@"1"]) {//开启了vpn
        
        if (self.loginStatus == STA_IDEL) {
            
            //            Setting
            
            
            //        mobile.dg.cn  13728179021  759164
            VPNAccount *accout = [[VPNAccount alloc] initWithHost:host userName:model.vpnUserName passWord:model.vpnPwdName];
            
//            accout.port = @"80";
//            accout.alias = @"我是iOS设备";
//            accout.methodName = @"name";
//            accout.deviceName = @"iOS设备";
            //            @"mobile.dg.cn"
            //13728179021  612691
            //759164
            
//            [[VPNManager sharedVPNManager] setLogLevel:LOG_DEBUG];
            //  accout.certificatePath = [[NSBundle mainBundle] pathForResource:@"client2" ofType:@"p12"];
          
//            [[VPNManager sharedVPNManager] setHttpProxyEnable:YES];
            
            
            
//            [[VPNManager sharedVPNManager] createTCPProxyEntry:@"mobile.dg.cn" port:9021];
            
//            - (void)loginWithAccount:(VPNAccount *)account;
            
            if (_VPNLogin) {
                
                
                [[VPNManager sharedVPNManager]loginWithAccount:accout];
                
                
                
            }else{
                
                
                [[VPNManager sharedVPNManager] startVPN:accout];
                
                
                
                _VPNLogin = YES;
                
            }
            

            
        }
        
        
        
    }
    
    
    
}



/**
 进入主页

 @param button 按钮
 */
- (void)gotoMain:(UIButton*)button{
    
   
    
//    WebVC*vc = [WebVC new];

   //
    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    if ([model.isOpenLogin isEqualToString:@"1"]) {
        
        
        webTwoVC*vc = [webTwoVC new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
         WebVC*vc = [WebVC new];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
  
    
    
    
    
    
}

/**
 vpn 事件处理

 @param n 通知
 */
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
        
    
        
//      NSLog(@"http端口号==%ld",[VPNManager sharedVPNManager].httpProxyPort);
        
        DDModel*model = [DDGetUserInformationTool getUserInformation];
        
//        model.isYetLoginVPN = @"1";
        
//        _isYetLoginVPN = YES;
        model.twoLogin = @"1";
        
        [DDGetUserInformationTool saveUserInformationWithModel:model];//不需要持久化
        
        [self autoAction:nil];
//
//        WebVC*vc = [WebVC new];
//
//        [self.navigationController pushViewController:vc animated:YES];
       
        
        
    } else if (message.code == VPN_CB_DISCONNECTED) {
        self.loginStatus = STA_IDEL;
//        [self showLoginActivity:NO];
        
        NSLog(@"连接失败");
        
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
        
        aMessage  = [NSString stringWithFormat:@"VPN %@",aMessage];
        
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
                                                            message:NSLocalizedString(@"Login failed, please check vpn username and password",nil)
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


- (BOOL)isValidOne{
    
    if (_userNameTextfield.text.length>0) {
        
        
        return YES;
        
    }else{
        
        [MBProgressHUD showError:@"请填写完整"];
        
        return NO;
        
        
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

#pragma mark textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    textField.text = updatedString;
    
    return NO;
}





@end
