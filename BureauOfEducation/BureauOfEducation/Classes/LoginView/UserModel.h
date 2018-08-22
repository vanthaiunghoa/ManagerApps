#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *vpnAccount;
@property (nonatomic, strong) NSString *vpnPassword;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isLogout;
@property (nonatomic, assign) BOOL isRememberUsername;
@property (nonatomic, assign) BOOL isAutoLogin;
@property (nonatomic, assign) BOOL isVPNLogin;

// 深信服VPN
@property (nonatomic, assign) BOOL isL3VPN;
@property (nonatomic, strong) NSString *l3VpnAccount;
@property (nonatomic, strong) NSString *l3VpnPassword;


@end
