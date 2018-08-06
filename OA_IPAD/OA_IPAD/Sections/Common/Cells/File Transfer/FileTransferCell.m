//
//  FileTransferCell.m
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "FileTransferCell.h"

@implementation FileTransferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation NSDate(FileTransferCell)

- (NSString *)fileTransferDateString {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:self];
    return str;
}

@end

