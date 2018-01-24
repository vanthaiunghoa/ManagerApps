#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, assign) BOOL isLogout;
@property (nonatomic, assign) BOOL isRememberUsername;
@property (nonatomic, assign) BOOL isAutoLogin;

@end
