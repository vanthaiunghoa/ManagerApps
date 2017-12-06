
//

#import "DDGetUserInformationTool.h"

@implementation DDGetUserInformationTool

//归档
+(void)saveUserInformationWithModel:(DDModel *)model{
    
    //保存用户信息
    [NSKeyedArchiver archiveRootObject:model toFile:DDUserInformationPath];
    
}

//解档
+(DDModel *)getUserInformation{
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:DDUserInformationPath];
}

+(void)deleteUserInformation{
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:DDUserInformationPath]) {
        [defaultManager removeItemAtPath:DDUserInformationPath error:nil];
    }
}





@end
