#import <Foundation/Foundation.h>

@interface UrlManager : NSObject

+ (instancetype)sharedUrlManager;
- (NSString *)getBaseUrl;
- (NSString *)getLoginUrl;
- (NSString *)getSingleUrl;
- (NSString *)getWebUrl;

@end
