//
//  WebViewContainerCell.m
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/24.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "WebViewContainerCell.h"

@implementation WebViewContainerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    FilePreViewController *pre = [FilePreViewController new];
    self.preViewer = pre;
    pre.view.frame = self.contentView.bounds;;
    [self.contentView addSubview:pre.view];
    [pre.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    return self;
}

@end
