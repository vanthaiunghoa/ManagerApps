#import <Foundation/Foundation.h>

@interface UrlManager : NSObject

+ (instancetype)sharedUrlManager;
- (NSString *)getLoginUrl;
- (NSString *)getSWHandlerListUrl;
- (NSString *)getFWHandlerListUrl;

@end
