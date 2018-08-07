#import <Foundation/Foundation.h>

@interface UrlManager : NSObject

+ (instancetype)sharedUrlManager;
- (NSString *)getBaseUrl;
- (NSString *)getLoginUrl;
- (NSString *)getSingleUrl;
- (NSString *)getWebUrl;

// 单点登录
- (NSString *)getPassword;
- (NSString *)getSPID;

@end
