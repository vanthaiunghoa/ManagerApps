//
//  RecordHeaderView.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "RecordHeaderView.h"
#import "UIColor+color.h"
#import "RecordModel.h"

@implementation RecordHeaderView
{
    UILabel *_left;
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIView *line = [UILabel new];
    line.backgroundColor = ViewColor;
    [self.contentView addSubview:line];

    _left = [UILabel new];
    [self.contentView addSubview:_left];
    _left.textColor = [UIColor colorWithHex:0x3D98FF];
    _left.textAlignment = NSTextAlignmentLeft;
//    _left.backgroundColor = [UIColor whiteColor];
    _left.font = [UIFont systemFontOfSize:20];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;

    line.sd_layout
    .topEqualToView(contentView)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(TableViewHeaderHeight);
    
    _left.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(50);
}

- (void)setModel:(RecordModel *)model
{
    _model = model;
    _left.text = model.title;
}


@end
