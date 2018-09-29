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
//    return @"http://19.104.11.182:80/DMS_Phone";
    
    // 科技局
//    return @"http://kjjoa.dg/DMS_Phone";
    // 农业局
//    return @"http://nyj.dg/DMS_Phone";
//    return @"http://19.104.9.233:80/DMS_Phone";
    // 滨海湾新区
//    return @"http://19.111.48.16:80/DMS_Phone";
    
    // 智慧政务
//    return @"http://121.15.203.82:9210/DMS_Phone";
    // 塘厦
//    return @"http://19.108.192.125/DMS_Phone";
    // 规划局
//    return @"http://19.104.9.125/DMS_Phone";
    
    // 测试md5
//    return @"http://121.15.203.82:9210/oasystem2018/";
    // 中共东莞市委统战部
//    return @"http://19.104.9.73/DMS_Phone";
    // 广东省渔政总队东莞支队
    return @"http://19.104.39.4/DMS_Phone";
    // 招商创新办
//    return @"http://19.104.39.10/DMS_Phone";
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
