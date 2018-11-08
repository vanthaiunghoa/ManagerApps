#import <Foundation/Foundation.h>

@class UserModel;
@interface UserManager : NSObject

+ (instancetype)sharedUserManager;
- (NSString *)getUserModelPath;
- (void)saveUserModel:(UserModel *)model;
- (UserModel *)getUserModel;
- (void)deleteUserModel;

@end
