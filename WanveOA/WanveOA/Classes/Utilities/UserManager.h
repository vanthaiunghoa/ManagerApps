#import <Foundation/Foundation.h>

@class UserModel;
@class ReceiveCommonModel;
@interface UserManager : NSObject

+ (instancetype)sharedUserManager;
- (NSString *)getUserModelPath;
- (void)saveUserModel:(UserModel *)model;
- (UserModel *)getUserModel;
- (void)deleteUserModel;
//- (void)logout;

// 收发文模型数据
- (NSString *)getReceiveCommonModelPath;
- (void)saveReceiveCommonModel:(ReceiveCommonModel *)model;
- (ReceiveCommonModel *)getReceiveCommonModel;
- (void)deleteReceiveCommonModel;

@end
