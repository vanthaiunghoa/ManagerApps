#import "ReceiveCommonModel.h"

@implementation ReceiveCommonModel

//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_Title forKey:@"Title"];
    [aCoder encodeObject:_LWDW forKey:@"LWDW"];
    [aCoder encodeObject:_SendDate forKey:@"SendDate"];
    [aCoder encodeObject:_WhoGiveName forKey:@"WhoGiveName"];
    [aCoder encodeObject:_BLSort forKey:@"BLSort"];
    [aCoder encodeObject:_HJ forKey:@"HJ"];
    [aCoder encodeObject:_BLStatus forKey:@"BLStatus"];
    [aCoder encodeObject:_SWBH forKey:@"SWBH"];
    [aCoder encodeObject:_LastDate forKey:@"LastDate"];
    [aCoder encodeObject:_WH forKey:@"WH"];
}

//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Title = [aDecoder decodeObjectForKey:@"Title"];
        _LWDW = [aDecoder decodeObjectForKey:@"LWDW"];
        _SendDate = [aDecoder decodeObjectForKey:@"SendDate"];
        _WhoGiveName = [aDecoder decodeObjectForKey:@"WhoGiveName"];
        _BLSort = [aDecoder decodeObjectForKey:@"BLSort"];
        _HJ = [aDecoder decodeObjectForKey:@"HJ"];
        _BLStatus = [aDecoder decodeObjectForKey:@"BLStatus"];
        _SWBH = [aDecoder decodeObjectForKey:@"SWBH"];
        _LastDate = [aDecoder decodeObjectForKey:@"LastDate"];
        _WH = [aDecoder decodeObjectForKey:@"WH"];
    }
    
    return self;
}


@end
