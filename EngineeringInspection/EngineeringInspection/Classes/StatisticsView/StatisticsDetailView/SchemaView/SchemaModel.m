#import "SchemaModel.h"

@implementation SchemaModel

//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_record forKey:@"Title"];
    [aCoder encodeObject:_destroy forKey:@"SendDate"];
    [aCoder encodeObject:_unrepair forKey:@"WhoGiveName"];
    [aCoder encodeObject:_undestroy forKey:@"HJ"];
    [aCoder encodeObject:_distribute forKey:@"HJ"];
    [aCoder encodeObject:_name forKey:@"HJ"];
}

//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _record = [aDecoder decodeObjectForKey:@"Title"];
        _destroy = [aDecoder decodeObjectForKey:@"SendDate"];
        _unrepair = [aDecoder decodeObjectForKey:@"WhoGiveName"];
        _undestroy = [aDecoder decodeObjectForKey:@"HJ"];
        _distribute = [aDecoder decodeObjectForKey:@"HJ"];
        _name = [aDecoder decodeObjectForKey:@"HJ"];
    }
    
    return self;
}


@end
