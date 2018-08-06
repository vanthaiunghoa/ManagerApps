//
//  PersonelSet.m
//  OA_IPAD
//
//  Created by cello on 2018/5/21.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "PersonelSet.h"
#import "Personel.h"


@implementation PersonelSet

- (instancetype)init {
    self = [super init];
    if (self) {
        _orderSet = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (BOOL)containsObject:(Personel *)object {
    if ([self.orderSet containsObject:object]) {
        return YES;
    }
    for (Personel *p in self.orderSet) {
        if ([p.UserSNID isEqualToString:object.UserSNID]) {
            return YES;
        }
    }
    return NO;
}

- (void)addObject:(Personel *)object {
    if (![self containsObject:object]) {
        [self.orderSet addObject:object];
    }
}
- (void)removeObject:(Personel *)object {
    if ([self.orderSet containsObject:object]) {
        [self.orderSet removeObject:object];
        return;
    }
    
    Personel *foundObject = nil;

    for (Personel *p in self.orderSet) {
        if ([p.UserSNID isEqualToString:object.UserSNID]) {
            foundObject = p;
        }
    }
    if (foundObject) {
        [self.orderSet removeObject:foundObject];
        foundObject = nil;
    }
    
}

+ (PersonelSet *)setWithArray:(NSArray<Personel *> *)array {
    PersonelSet *instance = [PersonelSet new];
    if (array) {
        [instance.orderSet addObjectsFromArray:array];
    }
    return instance;
}

@end
