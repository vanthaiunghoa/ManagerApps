#import <Foundation/Foundation.h>

@interface UrlManager : NSObject

+ (instancetype)sharedUrlManager;
- (NSString *)getBaseUrl;
- (NSString *)getLoginUrl;
- (NSString *)getHomePageUrl;
- (NSString *)getMD5Url;

@end
