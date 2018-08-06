//
//  NSDictionary+CreateModel.m
//
//  Created by liaochaolong on 2018/3/29.
//  Copyright © 2018年 liaochaolong. All rights reserved.
//

#import "NSDictionary+CreateModel.h"
#include <objc/runtime.h>

@implementation NSDictionary (CreateModel)

- (void)createModelWithName:(NSString *)modelName {
    // 只支持模拟器；
#if TARGET_IPHONE_SIMULATOR
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //已经有class；检测模型更新情况
        Class aClass = NSClassFromString(modelName);
        if (aClass) {
            
            //遍历已经存在的class的属性列表
            u_int count;
            objc_property_t *properties  =class_copyPropertyList(aClass, &count);
            NSMutableSet *classProperySet = [NSMutableSet setWithCapacity:count];
            for (int i = 0; i<count; i++) {
                const char* propertyName =property_getName(properties[i]);
                [classProperySet addObject: [NSString stringWithUTF8String: propertyName]];
            }
            free(properties);
            
            NSArray *jsonKeys = [self allKeys];
            NSMutableSet *jsonKeySet = [NSMutableSet setWithArray:jsonKeys];
            [jsonKeySet minusSet:classProperySet];
            
            if ([jsonKeySet count] > 0) {
                NSLog(@"\n❗️❗️ Model %@ 存在更新字段:\n %@ 。\n开始创建新的模型文件。🚗 ", modelName, jsonKeySet);
            } else {
                return;
            }
        }
        
        // 拼凑用户的桌面目录
        NSArray *pathComponets = [[NSBundle mainBundle].bundlePath componentsSeparatedByString:@"/"];
        NSString *destinatedDirectory = [NSString stringWithFormat:@"%@/%@/Desktop/Models/", pathComponets[1], pathComponets[2]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:destinatedDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:destinatedDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // .h
        NSMutableString *headerFile = [NSMutableString stringWithFormat:@"//\n//  %@.h\n//  Auto Created by NSDictionary+CreateModel.h on %@.\n//  author: liaochaolong\n//\n\n", modelName, [NSDate new]];
        [headerFile appendString:@"#import <Foundation/Foundation.h>\n\n"];
        NSString *interface = [NSString stringWithFormat:@"@interface %@ : NSObject\n", modelName];
        [headerFile appendString:interface];
        
        NSArray *keys = [self allKeys];
        
        for (NSString *key in keys) {
            id value = [self objectForKey:key];
            NSString *next = nil;;
            NSString *modifiedWord = @"copy";
            NSString *type = @"id";
            if ([value isKindOfClass:[NSNumber class]]) {
                type = @"NSNumber *";
            } else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNull class]]) {
                type = @"NSString *";
            } else if ([value isKindOfClass:[NSArray class]]) {
                modifiedWord = @"strong";
                type = @"NSArray *";
            } else {
                modifiedWord = @"strong";
            }
            next = [NSString stringWithFormat:@"\n/**\n @description:\n @note: etc:%@\n*/\n@property (nonatomic, %@) %@%@;\n", value, modifiedWord, type, key];
            [headerFile appendString:next];
        }
        
        [headerFile appendString:@"\n@end"];
        
        NSData *headerData = [headerFile dataUsingEncoding:NSUTF8StringEncoding];
        NSString *headerPath = [NSString stringWithFormat:@"%@/%@.h", destinatedDirectory, modelName];
        [headerData writeToFile:headerPath atomically:YES];
        
        
        // .m
        NSMutableString *implementationFile = [NSMutableString stringWithFormat:@"//\n//  %@.m\n//  Auto Created by CreateModel on %@.\n//\n\n", modelName, [NSDate new]];
        [implementationFile appendString:[NSString stringWithFormat:@"#import \"%@.h\"\n\n", modelName]];
        [implementationFile appendString:[NSString stringWithFormat:@"@implementation %@\n\n@end", modelName]];
        NSData *implementationData = [implementationFile dataUsingEncoding:NSUTF8StringEncoding];
        NSString *implemtationPath = [NSString stringWithFormat:@"%@/%@.m", destinatedDirectory, modelName];
        [implementationData writeToFile:implemtationPath atomically:YES];
        
        NSLog(@"\n📣📣📣 自动创建模型 %@ 成功。文件存放在%@ 📣📣📣\n", modelName, destinatedDirectory);
    });
#endif
}


@end
