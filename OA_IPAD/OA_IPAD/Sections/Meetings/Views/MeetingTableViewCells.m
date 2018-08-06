//
//  MeetingTableViewCells.m
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MeetingTableViewCells.h"
#import "UIColor+Scheme.h"

// 标题
@implementation TitleCell

@end


@implementation PlaceAndTimeCell

@end

@implementation InternalMeetingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

@end

@implementation OtherMeetingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

}

@end


@implementation AttendenceCell


#pragma mark - getters and setters


- (YYLabel *)label {
    if (!_label) {
        _label = [[YYLabel alloc] init];
        [self.contentView addSubview:_label];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(4, 31, 4, 31));
        }];
        
        _label.font = [UIFont systemFontOfSize:18];
        _label.numberOfLines = 0;
//        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
//        modifier.fixedLineHeight = 32;
//        _label.linePositionModifier = modifier;
        _label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 62;
//        _label.displaysAsynchronously = YES;
        _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _label.numberOfLines = 0;
        [_label sizeToFit];
    }
    return _label;
}

@end
