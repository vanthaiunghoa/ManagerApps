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
    return nil;
}

- (NSString *)getLoginUrl
{
//    return @"http://121.15.203.82:9210/EIM_PIC/WebService/WebService.asmx";
    return @"http://gcjg.baoan.gov.cn:9250/wan_mpda_pic//WebService/WebService.asmx";
}

- (NSString *)getSingleUrl
{
//    return @"http://121.15.203.82:9210/EIM_PIC/Handlers/SingleSignOnHandler.ashx?Action=SingleSignOnByXML";
    return @"http://gcjg.baoan.gov.cn:9250/WAN_MPDA_PIC/Handlers/SingleSignOnHandler.ashx?Action=SingleSignOnByXML";
}

- (NSString *)getWebUrl
{
//    return @"http://121.15.203.82:9210//WAN_MPDA_Pic/Handlers/SingleSignOnHandler.ashx?Action=Redirect";
    return @"http://gcjg.baoan.gov.cn:9250/WAN_MPDA_PIC/Handlers/SingleSignOnHandler.ashx?Action=Redirect";
}

@end
