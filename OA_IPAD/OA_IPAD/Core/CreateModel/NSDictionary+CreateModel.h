//
//  NSDictionary+CreateModel.h
//
//  Created by liaochaolong on 2018/3/29.
//  Copyright © 2018年 liaochaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CreateModel)

/**
 根据字典创建模型文件.h .m
 只支持模拟器；真机不会编译内部的代码

 @param modelName 模型的名字
 */
- (void)createModelWithName:(NSString *)modelName;

@end
