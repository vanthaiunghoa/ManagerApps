//
//  AttachedFilesCell.m
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "AttachedFilesCell.h"

@implementation AttachedFilesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)fileTouched:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(attachedFilesCell:didSelectFileAtIndex:)]) {
        [self.delegate attachedFilesCell:self didSelectFileAtIndex:sender.tag];
    }
}

@end
