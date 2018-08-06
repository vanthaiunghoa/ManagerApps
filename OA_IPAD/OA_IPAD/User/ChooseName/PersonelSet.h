//
//  PersonelSet.h
//  OA_IPAD
//
//  Created by cello on 2018/5/21.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Personel;
@interface PersonelSet : NSObject

@property (strong, nonatomic) NSMutableOrderedSet *orderSet;

- (BOOL)containsObject:(Personel *)object;

- (void)addObject:(Personel *)object;

- (void)removeObject:(Personel *)object;

+ (PersonelSet *)setWithArray:(NSArray<Personel *> *)array;
@end
