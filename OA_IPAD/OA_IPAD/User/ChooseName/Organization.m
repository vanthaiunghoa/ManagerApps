//
//  Organization.m
//  Auto Created by CreateModel on 2018-04-07 08:21:33 +0000.
//

#import "Organization.h"
#import "Personel.h"

@implementation Organization

- (instancetype)init
{
    if(self = [super init])
    {
        self.isExpand = NO;
        self.isSelect = NO;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Organization *cpy  = [[[self class] allocWithZone:zone] init];
    
    cpy.KSName = self.KSName;
    cpy.KSCode = self.KSCode;
    cpy.XH = self.XH;
    cpy.KSHisName = self.KSHisName;
    cpy.ParkLeaderName = self.ParkLeaderName;
    cpy.SWYName = self.SWYName;
    cpy.KSMasterName = self.KSMasterName;
    cpy.QZH = self.QZH;
    cpy.ParkLeaderID = self.ParkLeaderID;
    cpy.SWYID = self.SWYID;
    cpy.KSMasterUserID = self.KSMasterUserID;
//    cpy.staff = self.staff;
    
    cpy.staff = [NSMutableArray array];
    for(Personel *p in self.staff)
    {
        [cpy.staff addObject:[p copy]];
    }
    
    cpy.isExpand = self.isExpand;
    cpy.isSelect = self.isSelect;

    return cpy;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    Organization *cpy  = [[[self class] allocWithZone:zone] init];
    
    
    cpy.KSName = self.KSName;
    cpy.KSCode = self.KSCode;
    cpy.XH = self.XH;
    cpy.KSHisName = self.KSHisName;
    cpy.ParkLeaderName = self.ParkLeaderName;
    cpy.SWYName = self.SWYName;
    cpy.KSMasterName = self.KSMasterName;
    cpy.QZH = self.QZH;
    cpy.ParkLeaderID = self.ParkLeaderID;
    cpy.SWYID = self.SWYID;
    cpy.KSMasterUserID = self.KSMasterUserID;
//    cpy.staff = self.staff;
    
    cpy.staff = [NSMutableArray array];
    for(Personel *p in self.staff)
    {
        [cpy.staff addObject:[p copy]];
    }
    
    cpy.isExpand = self.isExpand;
    cpy.isSelect = self.isSelect;
    
    return cpy;
}



@end
