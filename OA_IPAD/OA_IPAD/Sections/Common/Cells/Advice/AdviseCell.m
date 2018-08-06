//
//  AdviseCell.m
//  OA_IPAD
//
//  Created by cello on 2018/4/1.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "AdviseCell.h"

@implementation AdviseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation NSDate(AdviceCell)

- (NSString *)adviceCellDateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *str = [formatter stringFromDate:self];
    return str;
}

@end
