//
//  DDInfo.h
//  Template
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDInfo : NSObject

@property (nonatomic , assign ) BOOL  isOpenVpn ;



+ (void)SaveOpenVpn:(BOOL)isOpenVpn;

+ (void)SaveUserName:(NSString*)userNameStr;

+ (void)SavePwdName:(NSString*)pwdNameStr;

+ (void)SaveVpnUserName:(NSString*)userNameStr;

+ (void)SaveVpnPwdName:(NSString*)pwdNameStr;


+ (BOOL)GetIsOpenVpn;

+ (NSString*)GetUserName;

+ (NSString*)GetPwdName;

+ (NSString*)GetVpnUserName;

+ (NSString*)GetVpnPwdName;

@end
