//
//  Excel.m
//  OA_IPAD
//
//  Created by cello on 2018/3/29.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "Excel.h"
#import "UIColor+Scheme.h"

@implementation Excel

- (void)setBorder:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1.0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
