#import "UserManager.h"

@implementation UserManager

static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedUserManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (NSString *)getUserModelPath
{
    // 获取caches文件夹
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"UserModel.data"];
    return filePath;
}

//归档
- (void)saveUserModel:(UserModel *)model
{
    // 任何对象都可以进行归档
    [NSKeyedArchiver archiveRootObject:model toFile:[self getUserModelPath]];
    // 调用自定义对象的 encodeWithCoder:
    // 如果一个自定义对象需要归档,必须遵守NSCoding协议,并且实现协议的方法.
}

//解档
- (UserModel *)getUserModel
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getUserModelPath]];
}

- (void)deleteUserModel
{
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:[self getUserModelPath]])
    {
        [defaultManager removeItemAtPath:[self getUserModelPath] error:nil];
    }
}


@end
