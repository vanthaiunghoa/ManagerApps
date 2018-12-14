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

- (NSString *)getPassword
{
    // 内网
//        return @"vJo06/qsLDOK5p2FvLqujo8G9eCsjrLJGcg8TGN0QZexSchZjBfneZ1vL4h3BN/EEId5hEBxZWM=";
    // 保安工务局
//    return @"tKB1F69J4TgRTM7QRN1+NxDaURCluPAAYFaWJfMEdhryuqvuoRIA7sF7CzKsSngLPPpy5gmaOu4=";
    // 勤智资本
//    return @"ysmi8nF7R3L/64UB2oGK4Zo1sRZx8CJEQAxXXZD7pOp1WaQv2bc7qNcjbR5W5Ybc5twNwOzg+8I=";
    // 盐田
//    return @"ysmi8nF7R3L/64UB2oGK4Zo1sRZx8CJEQAxXXZD7pOp1WaQv2bc7qNcjbR5W5Ybc5twNwOzg+8I=";
    // 南山
//    return @"8PDuOH1Qql6d0t3CpZGKjmZv3cVzOviVfg+TRCIeJ2wt54AO0hBUcJk49db2CFY2QOOMyv2ih0E=";
//     福田
//    return @"TwpbzQknBxj+S14WhfNRLuDZULBFHAJSKM2mGQ4kOpqWCIFPHJVfkE0L5trFFmR6ktXExDT0eGY=";
    // 龙华工务局
//    return @"ysmi8nF7R3L/64UB2oGK4d7kx3kgvJ4PF2Uwk7k3jLeN1U1O+clGj7Jm0EFZLzYPaJ512P+SE3I=";
    // 深圳水务集团
//    return @"jSR1XXg886K4S0P79d4yZxUSQ5w8r29LXheaKy1EfT07gdII61vSTP7o4HQGwodyscijcMvyXxI=";
    // 北京房地置业
//    return @"P5a6ahvUcIBrnh6M1/cfoH3tezVohAV6zZxNqIrkIQCI6MehPDBJSMBTYltTRVocZv5+PgDkyIw=";
    // 北京天运房地产
//    return @"dySAs+Yf0csjYgKunsi84GjwENwW+ktGCR2hf/JvL8rdPVeEXnaDKG7zEES/2/8ZQMgBgfcukIo=";
    // 松山湖工程管理局工程数据管理平台
//    return @"jSR1XXg886K4S0P79d4yZxtd21xaGJf79CnZFYP38LPZt8bBoeyOBs25nHg2Xt6hy4D6WwjRXOA=";
    // 东莞市路桥投资
//    return @"tKB1F69J4TiAVCrC6SRNGiMnDqVMEJGQ2QdFlvMnpUhyBsjP/BDuILz16j4A1q3JO1YFUlt7Fm0=";
    // 深圳市建筑工务署
//    return @"jSR1XXg886K4S0P79d4yZ+5Y1U/7PtdhzAvTqnlTkSEKqq7N14zS0hocyct0ZfqI74Gq1I+Orok=";
//     万维
//    return @"ysmi8nF7R3L/64UB2oGK4Zo1sRZx8CJEQAxXXZD7pOp1WaQv2bc7qNcjbR5W5Ybc5twNwOzg+8I=";
    // 光明新区
//    return @"ysmi8nF7R3L/64UB2oGK4Zo1sRZx8CJEQAxXXZD7pOp1WaQv2bc7qNcjbR5W5Ybc5twNwOzg+8I=";
    // 东江区工务局
//    return @"vJo06/qsLDN1UvbshDmf6nLwNciVtZ4/cUW8JTQv32V+Y9Mh3hjCoOAL9zF8YnjL0EW4c/gQE/U=";
    // 北京房地集团
    return @"ysmi8nF7R3L/64UB2oGK4Zo1sRZx8CJEQAxXXZD7pOp1WaQv2bc7qNcjbR5W5Ybc5twNwOzg+8I=";

}

- (NSString *)getSPID
{
    // 内网
//    return  @"ToWanPic";
    
    return @"ToEIM_PIC";
}

- (NSString *)getBaseUrl
{
    // 内网
//    return @"http://121.15.203.82:9210/wan_mpda_pic";
    // 勤智资本
//    return @"http://134.175.118.134:9120/WAN_MPDA_PIC";
//     保安工务局
//    return @"http://gcjg.baoan.gov.cn:9250/wan_mpda_pic";
    // 盐田
//    return @"http://134.175.118.134:9130/WAN_MPDA_PIC";
    // 南山
//    return @"http://183.62.232.185:8011/wan_mpda_pic";
    // 福田
//    return @"http://183.62.232.185:8010/wan_mpda_pic";
    // 龙华工务局
//    return @"http://121.15.203.82:9140/wan_mpda_pic";
    // 深圳水务集团
//    return @"http://183.62.232.185:8005/wan_mpda_pic";
    // 北京房地置业
//    return @"http://202.104.110.143:8006/wan_mpda_pic";
    // 北京天运房地产
//    return @"http://121.15.203.82:9810/wan_mpda_pic";
    // 松山湖工程管理局
//    return @"http://202.104.110.143:8008/wan_mpda_pic";
    // 东莞市路桥投资
//    return @"http://120.86.117.106/wan_mpda_pic";
    // 深圳市建筑工务署
//    return @"http://202.104.110.143:8001/wan_mpda_pic";
    // 万维
//    return @"http://134.175.118.134:9120/WAN_TZ_PIC";
    // 光明新区
//    return @"http://134.175.118.134:9876/wan_mpda_pic";
    // 东江区工务局
//    return @"http://47.107.91.155:8080/WAN_MPDA_PIC";
    // 北京房地集团
    return @"http://134.175.118.134:9810/WAN_MPDA_PIC";
}

- (NSString *)getLoginUrl
{
//    return @"http://121.15.203.82:9210/EIM_PIC/WebService/WebService.asmx";
//    return [NSString stringWithFormat:@"%@/EIM_PIC/WebService/WebService.asmx", [self getBaseUrl]];

    return [NSString stringWithFormat:@"%@//WebService/WebService.asmx", [self getBaseUrl]];
}

- (NSString *)getSingleUrl
{
//    return @"http://121.15.203.82:9120/EIM_PIC/Handlers/SingleSignOnHandler.ashx?Action=SingleSignOnByXML";
    
    return [NSString stringWithFormat:@"%@/Handlers/SingleSignOnHandler.ashx?Action=SingleSignOnByXML", [self getBaseUrl]];
}

- (NSString *)getWebUrl
{
//    return @"http://121.15.203.82:9120//WAN_MPDA_Pic/Handlers/SingleSignOnHandler.ashx?Action=Redirect";
    
    return [NSString stringWithFormat:@"%@/Handlers/SingleSignOnHandler.ashx?Action=Redirect", [self getBaseUrl]];
}

@end
