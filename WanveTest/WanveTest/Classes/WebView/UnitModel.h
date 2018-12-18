//
//  UnitModel.h
//  WanveTest
//
//  Created by wanve on 2018/12/18.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import <Foundation/Foundation.h>

// {"SNID":"单位编号","SortName":"单位简称","FullName":"单位全称"}

@interface UnitModel : NSObject

@property(nonatomic, copy) NSString *SNID;
@property(nonatomic, copy) NSString *SortName;
@property(nonatomic, copy) NSString *FullName;

+ (instancetype)unitWithDict:(NSDictionary *)dict;

@end
