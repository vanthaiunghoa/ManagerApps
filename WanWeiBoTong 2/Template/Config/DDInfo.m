//
//  DDInfo.m
//  Template
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "DDInfo.h"



@implementation DDInfo

+ (void)SaveUserName:(NSString*)userNameStr{
    
    [[NSUserDefaults standardUserDefaults]setValue:userNameStr forKey:@"userNameStr"];
    
    
}

+ (void)SavePwdName:(NSString*)pwdNameStr{
    
    [[NSUserDefaults standardUserDefaults]setValue:pwdNameStr forKey:@"pwdNameStr"];
    
    
}

+ (void)SaveVpnUserName:(NSString*)userNameStr{
    
    
     [[NSUserDefaults standardUserDefaults]setValue:userNameStr forKey:@"vpnUserNameStr"];
    
}

+ (void)SaveVpnPwdName:(NSString*)pwdNameStr{
    
    
    [[NSUserDefaults standardUserDefaults]setValue:pwdNameStr forKey:@"vpnPwdNameStr"];
    
    
}


+ (NSString*)GetUserName{
    
    
    
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userNameStr"];
    
}

+ (NSString*)GetPwdName{
    
    
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"pwdNameStr"];
}

+ (NSString*)GetVpnUserName{
    
    
    
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"vpnUserNameStr"];
}

+ (NSString*)GetVpnPwdName{
    
    
    
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"vpnPwdNameStr"];
    
}



+ (BOOL)GetIsOpenVpn{
    
    
     return [[NSUserDefaults standardUserDefaults]objectForKey:@"isOpenVpn"];
    
}

+ (void)SaveOpenVpn:(BOOL)isOpenVpn{
    
    
    [[NSUserDefaults standardUserDefaults]setBool:isOpenVpn forKey:@"isOpenVpn"];
    
    
}


@end
