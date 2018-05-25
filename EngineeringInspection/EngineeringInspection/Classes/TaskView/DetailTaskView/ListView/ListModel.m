#import "ListModel.h"

@implementation ListModel

//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_Title forKey:@"Title"];
    [aCoder encodeObject:_SendDate forKey:@"SendDate"];
    [aCoder encodeObject:_WhoGiveName forKey:@"WhoGiveName"];
    [aCoder encodeObject:_HJ forKey:@"HJ"];
}

//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Title = [aDecoder decodeObjectForKey:@"Title"];
        _SendDate = [aDecoder decodeObjectForKey:@"SendDate"];
        _WhoGiveName = [aDecoder decodeObjectForKey:@"WhoGiveName"];
        _HJ = [aDecoder decodeObjectForKey:@"HJ"];
    }
    
    return self;
}


@end
