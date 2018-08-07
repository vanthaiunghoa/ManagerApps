#import "UserModel.h"

@implementation UserModel
    
//归档的时候调用：告诉系统哪个属性要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_status forKey:@"status"];
    
    [aCoder encodeBool:_isLogout forKey:@"isLogout"];
    [aCoder encodeBool:_isRememberUsername forKey:@"isRememberUsername"];
    [aCoder encodeBool:_isAutoLogin forKey:@"isAutoLogin"];
}
    
//解档的时候调用：告诉系统哪个属性要解档，如何归解
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _status = [aDecoder decodeObjectForKey:@"status"];
        
        _isLogout = [aDecoder decodeBoolForKey:@"isLogout"];
        _isRememberUsername = [aDecoder decodeBoolForKey:@"isRememberUsername"];
        _isAutoLogin = [aDecoder decodeBoolForKey:@"isAutoLogin"];
    }
        
    return self;
}

@end
