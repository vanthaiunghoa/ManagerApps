#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Type) {
    Normal,
    Register,
    ForgetPassword,
};

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

@property (nonatomic, assign) BOOL isRegister;
@property (nonatomic, assign) Type type;

@end
