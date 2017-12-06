
//在afn的基础上再封装网络

#import <Foundation/Foundation.h>


#import "AFNetworking.h"



@interface DDNetworkTool : NSObject
extern BOOL whetherHaveNetwork;

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure;
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure;

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure NOMessage:(BOOL)isMessage;
//+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError * error))failure  NOMessage:(BOOL)isMessage;

//+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject,id task))success failure:(void (^)(NSError * error))failure  NOMessage:(BOOL)isMessage  cancel:(BOOL)isCancel;

+ (void)requestWithUrl:(NSString *)url

      withPostedImages:(NSArray *)imagesArray

      WithSuccessBlock:(void (^)(NSArray * resultArray))successBlock

           WithNeebHub:(BOOL)needHub

              WithView:(UIView *)viewWithHub

              WithData:(NSDictionary *)dataDic;



@end
