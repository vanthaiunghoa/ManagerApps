#import "InspectionItemModel.h"

@implementation InspectionItemModel

//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_num forKey:@"num"];
}

//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _type = [aDecoder decodeObjectForKey:@"type"];
        _num = [aDecoder decodeObjectForKey:@"num"];
    }
    
    return self;
}


@end
