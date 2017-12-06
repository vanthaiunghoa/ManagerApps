
//

//对用户信息模型进行归档和反归档,删除

#import <Foundation/Foundation.h>

#import "DDModel.h"




@interface DDGetUserInformationTool : NSObject

+(void)saveUserInformationWithModel:(DDModel *)model;

+(DDModel *)getUserInformation;

+(void)deleteUserInformation;





@end
