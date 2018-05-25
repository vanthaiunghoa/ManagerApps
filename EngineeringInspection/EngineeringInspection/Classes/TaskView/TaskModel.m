#import "TaskModel.h"

@implementation TaskModel

//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_type forKey:@"type"];
}

//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _time = [aDecoder decodeObjectForKey:@"time"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _type = [aDecoder decodeObjectForKey:@"type"];
    }
    
    return self;
}


@end
