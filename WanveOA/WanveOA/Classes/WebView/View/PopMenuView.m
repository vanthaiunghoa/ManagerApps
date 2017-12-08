//
//  PopMenuView.m
//  彩票
//
//  Created by xiaomage on 15/9/21.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "PopMenuView.h"
#import "UIColor+color.h"

// 开发思想:高聚合,低耦合

@interface PopMenuView()

@end

@implementation PopMenuView

/*
 void (^completion)() = ^(){
 // 隐藏完成的时候,需要做事情
 
 // 移除蒙版
 [XMGCover hide];
 };
 */
- (void)hideInPoint:(CGPoint)point completion:(void (^ __nullable)())completion
{
    // pop菜单(平移+缩放)
    [UIView animateWithDuration:1 animations:^{
        
//        self.center = point;
//        
//        // 形变
//        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        // 移除
        [self removeFromSuperview];
        
        // 隐藏蒙版
        completion();
    }];
}

+ (instancetype)showInPoint:(CGPoint)point
{
   
    PopMenuView *menu = [[PopMenuView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 74, 60, 90)];
    
//    menu.center = point;
    
    // 获取主窗口
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
    
    return menu;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat y = 0;
        CGFloat h = self.bounds.size.height / 3.0;
        CGFloat w = self.bounds.size.width;
        for(int i = 0; i < 3; ++i)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            
            if(0 == i)
            {
                [btn setTitle:@"通讯录" forState:UIControlStateNormal];
            }
            else if(1 == i)
            {
                [btn setTitle:@"注销" forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:@"退出" forState:UIControlStateNormal];
            }
            
            //        [btn setBackgroundColor:UIColor.redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchDown];
            //        [btn.layer setMasksToBounds:YES];
            //        [btn.layer setCornerRadius:5.0];
            [btn.layer setBorderColor:[UIColor whiteColor].CGColor];
            [btn.layer setBorderWidth:1.0];
            btn.frame = CGRectMake(0, y, w, h);
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#6B6B6B"]];
            [self addSubview:btn];
            
            y += h;
        }
    }
    return self;
}


// 点击选择按钮
- (void)selected:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    
    // 通知代理,移除菜单 移除蒙版
//    if ([_delegate respondsToSelector:@selector(popMenuDidHide::)])
//    {
        [_delegate popMenuDidHide:self tag:btn.tag];
//    }
}

@end
