
//

#import "DDNetworkTool.h"

#import "MBProgressHUD+MJ.h"

#define version  @"1.1"

#define isDebug @"1"

#define version_moreThan @"1.1"



@interface DDNetworkTool()


//@property (nonatomic , strong ) NSInteger   ;

@end


@implementation DDNetworkTool

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{

    DDModel*model = [DDGetUserInformationTool getUserInformation];
    
    AFHTTPSessionManager *session;
    //如果登录成功
    if ([model.twoLogin isEqualToString:@"1"]) {
        
        if (![URLString containsString:@"appName"]) {
            
            
            session = [[AFHTTPSessionManager manager]initWithBaseURL:nil sessionConfiguration:[self setProxyWithConfig]];
            
        }else{
            
            session = [AFHTTPSessionManager manager];
            
        }
         session = [AFHTTPSessionManager manager];
        
    }else{
    
       session = [AFHTTPSessionManager manager];
    }
    
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 10.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
//    session.responseSerializer = response;
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

   
    
    

   
    
                [session GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    
                    if (success) {
                        
                        
                        
                        success(responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    
                    
                    if (failure) {
                        
                         
                        
                        failure(error);
                    }
                }];

    
    
    
}

+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    

    

    
    NSMutableDictionary*dd=parameters;
    
    __block    NSString*encryptStr=[NSString string];
    
    encryptStr=@"platform=ios";
    
    [dd enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSLog(@"start%@", obj);
        
        if ([obj isKindOfClass:[NSString class]]) {
            if([obj isEqualToString:@""]||[obj isEqual:[NSNull null]]){
                [dd removeObjectForKey:key];
                
                
            }else{
            

             dd[key]=obj;
            NSLog(@"end%@",obj);
                

                
            }
        }
    }];
    
    

    parameters=dd;
    

    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 设置超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 10.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        [session.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"os_type"];
    
    
        NSString*token=[[NSUserDefaults standardUserDefaults]valueForKey:@"token"]?[[NSUserDefaults standardUserDefaults]valueForKey:@"token"]:@"";
    

    
        [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    
    NSString*tmp=[NSString stringWithFormat:@"?v=%@",Application_Version];
    URLString= [URLString stringByAppendingString:tmp];
    URLString=[URLString stringByAppendingString:@"&p=ios"];
    URLString=[URLString stringByAppendingString:@"&app=999"];

    
                    [session POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                      

                        
                    
                        
   
                  

                        if (success) {
                            
           
                        
                                
                                success(responseObject);
                            
                            
                            
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        

                        
                        if (failure) {
                    
                            failure(error);
                        }
                        
                    }];

    
}

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure NOMessage:(BOOL)isMessage
{

    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    session.requestSerializer.timeoutInterval = 10.f;
    [session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [session.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"os_type"];
//    [session.requestSerializer setValue:[NSData data].mj_JSONString forHTTPHeaderField:@"time"];
    
//    NSString*token=[[NSUserDefaults standardUserDefaults]valueForKey:@"token"]?[[NSUserDefaults standardUserDefaults]valueForKey:@"token"]:@"";
    
    
//    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [session GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [hud hide:YES];
        if (success) {
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        

        
        if (failure) {
            failure(error);
        }
    }];

    
    
    
}

//+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure  NOMessage:(BOOL)isMessage
//{
//
//
//
//}



//上传多张图片

+ (void)requestWithUrl:(NSString *)url

      withPostedImages:(NSArray *)imagesArray

      WithSuccessBlock:(void (^)(NSArray * resultArray))successBlock

           WithNeebHub:(BOOL)needHub

              WithView:(UIView *)viewWithHub

              WithData:(NSDictionary *)dataDic

{
    
    if (imagesArray.count > 0) {
        
        
        
        //创建一个临时的数组，用来存储回调回来的结果
        
        NSMutableArray *temArray = [NSMutableArray array];
        
        
//        MBProgressHUD * hud =  [MBProgressHUD showMessage:@"正在上传图片，请稍候.."];
        
        for (int i = 0;  i < imagesArray.count; i++)
        {
            
            UIImage *imageObj = imagesArray[i];
            
            //截取图片
            
            NSData *imageData = UIImageJPEGRepresentation(imageObj, 0.5);
            
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            // 访问路径
            [manager POST:url parameters:dataDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                
                
                // 上传文件
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                formatter.dateFormat = @"yyyyMMddHHmmss";
                
                NSString *str = [formatter stringFromDate:[NSDate date]];
                
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                
                
                
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
                
                
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
//                NSLog(@"%@",uploadProgress);
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                
                
                
                [temArray addObject:dic];
                
                
                
                //当所有图片上传成功后再将结果进行回调
                
                if (temArray.count == imagesArray.count) {
//                    [hud hide:YES];
//                    [SVProgressHUD showSuccessWithStatus:@"图片上传成功"];
                    successBlock(temArray);
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
                
            }];
            
        }
        
    }
    
}

//+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject,id task))success failure:(void (^)(NSError * error))failure  NOMessage:(BOOL)isMessage  cancel:(BOOL)isCancel{
//
//
//}

/**
 * 代理设置
 */
+ (NSURLSessionConfiguration *)setProxyWithConfig
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
//    [[NSURLSessionConfiguration defaultSessionConfiguration]setConnectionProxyDictionary:@
//     {
//         @"HTTPEnable":@YES,
//         (id)kCFStreamPropertyHTTPProxyHost:@"mobile.dg.cn",
//         (id)kCFStreamPropertyHTTPProxyPort:@8080,
//         @"HTTPSEnable":@YES,
//         (id)kCFStreamPropertyHTTPSProxyHost:@"mobile.dg.cn",//121.10.6.251
//         (id)kCFStreamPropertyHTTPSProxyPort:@8080
//     }];
    
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    config.connectionProxyDictionary = @
    {
        @"HTTPEnable":@YES,
        (id)kCFStreamPropertyHTTPProxyHost:@"mobile.dg.cn",
        (id)kCFStreamPropertyHTTPProxyPort:@8080,
        @"HTTPSEnable":@YES,
        (id)kCFStreamPropertyHTTPSProxyHost:@"mobile.dg.cn",//121.10.6.251
        (id)kCFStreamPropertyHTTPSProxyPort:@8080
    };
    
    return config;


}



@end
