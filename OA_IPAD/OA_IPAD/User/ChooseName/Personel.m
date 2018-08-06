//
//  Personel.m
//  Auto Created by CreateModel on 2018-04-07 08:40:44 +0000.
//

#import "Personel.h"

@implementation Personel

- (instancetype)init
{
    if(self = [super init])
    {
        self.selectMode = SelectNone;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Personel *cpy  = [[[self class] allocWithZone:zone] init];
    
    cpy.KSName = self.KSName;
    cpy.KSCode = self.KSCode;
    cpy.JobDuty = self.JobDuty;
    cpy.UserPsw = self.UserPsw;
    cpy.UserName = self.UserName;
    cpy.UserSNID = self.UserSNID;
    cpy.LoginTime = self.LoginTime;
    cpy.QZH = self.QZH;
    cpy.DWName = self.DWName;
    cpy.isKSJR = self.isKSJR;
    cpy.Title = self.Title;
    cpy.vacInfo = self.vacInfo;
    cpy.UserID = self.UserID;
    cpy.selectMode = self.selectMode;
    
    return cpy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    Personel *cpy  = [[[self class] allocWithZone:zone] init];
    
    cpy.KSName = self.KSName;
    cpy.KSCode = self.KSCode;
    cpy.JobDuty = self.JobDuty;
    cpy.UserPsw = self.UserPsw;
    cpy.UserName = self.UserName;
    cpy.UserSNID = self.UserSNID;
    cpy.LoginTime = self.LoginTime;
    cpy.QZH = self.QZH;
    cpy.DWName = self.DWName;
    cpy.isKSJR = self.isKSJR;
    cpy.Title = self.Title;
    cpy.vacInfo = self.vacInfo;
    cpy.UserID = self.UserID;
    cpy.selectMode = self.selectMode;
    
    return cpy;
}



@end
