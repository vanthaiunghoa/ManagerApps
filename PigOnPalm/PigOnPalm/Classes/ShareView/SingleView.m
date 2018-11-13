//
//  SingleView.m
//  弹出视图
//
//  Created by 李 红宝 on 16/1/16.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "SingleView.h"

@implementation SingleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sheetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.sheetBtn];
        //        self.sheetBtn.clipsToBounds = YES;
        //        self.sheetBtn.layer.cornerRadius = 25;
        //        [self.sheetBtn setCenter:CGPointMake(self.frame.size.width / 2, 30)];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.imageView setCenter:CGPointMake(self.frame.size.width / 2, 30)];
        [self.sheetBtn addSubview:self.imageView];

        
        self.sheetLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 20)];
        [self.sheetBtn addSubview:self.sheetLab];
        [self.sheetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.sheetLab setTextAlignment:NSTextAlignmentCenter];
        self.sheetLab.font = [UIFont systemFontOfSize:14];
    }
    return self;
}


- (void)btnClick:(UIButton *)btn
{
    self.block(self.sheetBtn.tag,self.sheetLab,self.shareType);
}

- (void)selectedIndex:(RRBlock)block
{
    self.block = block;
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
