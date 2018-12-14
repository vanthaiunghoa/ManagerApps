#import "UrlManager.h"

@implementation UrlManager

static id _instance;

//  水务局
//    static NSString *baseUrl = @"http://19.104.11.182:80";

// 科技局
//    static NSString *baseUrl = @"http://kjjoa.dg";
// 农业局
//    static NSString *baseUrl = @"http://nyj.dg";
//    static NSString *baseUrl = @"http://19.104.9.233:80";
// 滨海湾新区
//    static NSString *baseUrl = @"http://19.111.48.16:80";

// 智慧政务
static NSString *baseUrl = @"http://47.107.91.155:8080";
// 塘厦
//    static NSString *baseUrl = @"http://19.108.192.125";
// 规划局
//    static NSString *baseUrl = @"http://19.104.9.125";

// 中共东莞市委统战部
//    static NSString *baseUrl = @"http://19.104.9.73";
// 广东省渔政总队东莞支队
//    static NSString *baseUrl = @"http://19.104.39.4";
// 招商创新办
//    static NSString *baseUrl = @"http://19.104.39.10";

// 测试
//    static NSString *baseUrl = @"http://172.27.35.1";
// 交投 即 自动化办公
//    static NSString *baseUrl = @"http://221.4.134.50:8081";

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
    return [NSString stringWithFormat:@"%@/DMS_Phone", baseUrl];
}

- (NSString *)getMD5Url
{
    return [NSString stringWithFormat:@"%@/oasystem2018/", baseUrl];
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
