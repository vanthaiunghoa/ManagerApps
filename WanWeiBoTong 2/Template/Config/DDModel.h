//
//  DDModel.h
//  Template
//
//  Created by Apple on 2017/10/20.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDModel : NSObject<NSCoding>

@property (nonatomic , copy ) NSString * userName;
    
@property (nonatomic , copy ) NSString * pwdName;
    
@property (nonatomic , copy ) NSString * vpnUserName;

@property (nonatomic , copy ) NSString * vpnPwdName;
    
@property (nonatomic , copy ) NSString *   isRecode;
    
@property (nonatomic , copy ) NSString *   isAutoLogin;
    
@property (nonatomic , copy ) NSString *   isOpenLogin;

@property (nonatomic , copy ) NSString *   isYetLoginVPN;

//注销
@property (nonatomic , copy ) NSString*  isLogout ;
@property (nonatomic , copy ) NSString*  isGotoVpn ;
@property (nonatomic , copy ) NSString * tempName;

@property (nonatomic , copy ) NSString * tempPwd;

@property (nonatomic , copy ) NSString * twoLogin ;


@end
