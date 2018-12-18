//
//  UnitModel.m
//  WanveTest
//
//  Created by wanve on 2018/12/18.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "UnitModel.h"

@implementation UnitModel

+ (instancetype)unitWithDict:(NSDictionary *)dict
{
    UnitModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
