#import "TrackModel.h"

@implementation TrackModel

//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_des forKey:@"Title"];
    [aCoder encodeObject:_percent forKey:@"SendDate"];
}

//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _des = [aDecoder decodeObjectForKey:@"Title"];
        _percent = [aDecoder decodeObjectForKey:@"SendDate"];
    }

    return self;
}


@end
