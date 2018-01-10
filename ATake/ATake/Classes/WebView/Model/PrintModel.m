//
//  PrintModel.m
//  ATake
//
//  Created by wanve on 2018/1/8.
//  Copyright © 2018年 self. All rights reserved.
//

#import "PrintModel.h"

@implementation FeesModel

@end

@implementation OrderClothessModel

@end

@implementation PrintModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"orderClothess" : @"OrderClothessModel",
             @"fees" : @"FeesModel"
             };
}

@end
