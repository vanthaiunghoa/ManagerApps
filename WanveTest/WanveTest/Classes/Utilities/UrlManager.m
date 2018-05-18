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

- (NSString *)getBaseUrl
{
    //  水务局
//    return @"http://19.104.120.8:80/DMS_Phone";
    
    // 科技局
    return @"http://kjjoa.dg/DMS_Phone";
    // 农业局
//    return @"http://nyj.dg/DMS_Phone";
//    return @"http://19.104.9.233:80/DMS_Phone";
    
    // 智慧政务
//    return @"http://121.15.203.82:9210/DMS_Phone";
}

- (NSString *)getLoginUrl
{
    return @"http://121.15.203.82:9210/EIM_PIC/WebService/WebService.asmx";
//    return @"http://gcjg.baoan.gov.cn:9250/wan_mpda_pic//WebService/WebService.asmx";
}

- (NSString *)getHomePageUrl
{
    return [NSString stringWithFormat:@"%@/Main/JumpToHome.aspx", [self getBaseUrl]];
}

@end
