//
//  DDModel.m
//  Template
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "DDModel.h"

@implementation DDModel
    
//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
    {
     
        [aCoder encodeObject:_userName forKey:@"kuserName"];
        [aCoder encodeObject:_pwdName forKey:@"kpwdName"];
        [aCoder encodeObject:_vpnUserName forKey:@"kvpnUserName"];
        [aCoder encodeObject:_vpnPwdName forKey:@"kvpnPwdName"];
        [aCoder encodeObject:_isRecode forKey:@"kisRecode"];
        [aCoder encodeObject:_isAutoLogin forKey:@"kisAutoLogin"];
        [aCoder encodeObject:_isOpenLogin forKey:@"kisOpenLogin"];
        
        [aCoder encodeObject:_isLogout forKey:@"isLogout"];
        [aCoder encodeObject:_isGotoVpn forKey:@"isGotoVpn"];
        [aCoder encodeObject:_tempName forKey:@"tempName"];
        [aCoder encodeObject:_tempPwd forKey:@"tempPwd"];
        [aCoder encodeObject:_isYetLoginVPN forKey:@"isYetLoginVPN"];
        [aCoder encodeObject:_twoLogin forKey:@"twoLogin"];
       

        
        
    }
    
//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
    {
        if (self = [super init]) {
            
            _userName = [aDecoder decodeObjectForKey:@"kuserName"];
            _pwdName = [aDecoder decodeObjectForKey:@"kpwdName"];
            _vpnUserName = [aDecoder decodeObjectForKey:@"kvpnUserName"];
            _vpnPwdName = [aDecoder decodeObjectForKey:@"kvpnPwdName"];
            _isRecode = [aDecoder decodeObjectForKey:@"kisRecode"];
            _isAutoLogin = [aDecoder decodeObjectForKey:@"kisAutoLogin"];
            _isOpenLogin = [aDecoder decodeObjectForKey:@"kisOpenLogin"];
            
            _isLogout = [aDecoder decodeObjectForKey:@"isLogout"];
            _isGotoVpn = [aDecoder decodeObjectForKey:@"isGotoVpn"];
            _tempName = [aDecoder decodeObjectForKey:@"tempName"];
            _tempPwd = [aDecoder decodeObjectForKey:@"tempPwd"];
            _isYetLoginVPN = [aDecoder decodeObjectForKey:@"isYetLoginVPN"];
            _twoLogin = [aDecoder decodeObjectForKey:@"twoLogin"];
        
        }
        
        
        
        return self;
    }

    

@end
