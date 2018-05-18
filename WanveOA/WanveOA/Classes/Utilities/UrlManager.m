#import "UrlManager.h"

@implementation UrlManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedUrlManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

static NSString *ip = @"http://121.15.203.82:9210/oasystem2018/Handlers/";
static NSString *loginIp = @"http://121.15.203.82:9210/oasystem2018/Handlers/DMS_FileMan_Handler.ashx?";

- (NSString *)getLoginUrl
{
    return loginIp;
}

- (NSString *)getSWHandlerListUrl
{
    return [NSString stringWithFormat:@"%@SWMan/SWHandler.ashx?", ip];
}

- (NSString *)getFWHandlerListUrl
{
    return [NSString stringWithFormat:@"%@FWMan/FWHandler.ashx?", ip];
}


@end
