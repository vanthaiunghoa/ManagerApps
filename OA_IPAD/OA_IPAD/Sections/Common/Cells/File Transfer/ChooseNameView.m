//
//  ChooseNameView.m
//  OA_IPAD
//
//  Created by cello on 2018/4/2.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ChooseNameView.h"

@interface ChooseNameView()
@property (weak, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation ChooseNameView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.chooseNameButton addTarget:self action:@selector(chooseName) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    if (!self.cancelButton && !self.tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseName)];
        [self.chooseNameContainer addGestureRecognizer:tap];
    }
}
- (void)setState:(ChooseNameState)state {
    BOOL chosen = (state == ChooseNameStateChosen);
    self.chooseNameButton.hidden = chosen;
    self.chooseNameContainer.hidden = !chosen;
    self.cancelButton.hidden = !chosen; //失误了，位置没放对；不过将就使用一下
    _state = state;
}

- (void)chooseName {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseNameFromView:)]) {
        [self.delegate chooseNameFromView:self];
    }
}

- (void)cancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelNameFromView:)]) {
        [self.delegate cancelNameFromView:self];
    }
}

@end

@implementation RACSignal(StringMapToState)

- (RACSignal *)mapToState {
    return [self map:^NSNumber *(id value) {
        if ([value isKindOfClass:Personel.class] || ([value isKindOfClass:NSArray.class] && [value count])) {
            return @(ChooseNameStateChosen);
        } else {
            return @(ChooseNameSateUnchosen);
        }
    }];
}

- (RACSignal *)mapToName {
    return [self map:^NSString *(id value) {
        if ([value isKindOfClass:[Personel class]]) {
            return ((Personel*)value).UserName;
        } else if ([value isKindOfClass:[NSArray class]]){
            return [value mapToNames];
        } else {
            return @"";
        }
    }];
}


@end

@implementation NSArray(StringMapToState)


- (NSString *)mapToNames {
    if (self.count < 1) {
        return @"";
    }
    // 区分科室
    NSMutableDictionary *departmentDict = [NSMutableDictionary dictionaryWithCapacity:8];
    
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < self.count; i++) {
        Personel *p = self[i];
        if (!p.KSName) {continue;}
        NSMutableArray *staff = departmentDict[p.KSName];
        if (!staff) {
            staff = [NSMutableArray arrayWithCapacity:5];
            departmentDict[p.KSName] = staff;
        }
        [staff addObject:p];
    }
    
    NSArray *departments = departmentDict.allValues;
    for (NSArray<Personel *> *staff in departments) {
        [str appendString:staff.firstObject.KSName];
        for (Personel *p in staff) {
            [str appendString:p.UserName];
            if (staff.lastObject != p) {
                [str appendString:@"、"];
            }
        }
        if (departments.lastObject != staff) {
            [str appendString:@"、"];
        }
    }
    return str;
}

@end
