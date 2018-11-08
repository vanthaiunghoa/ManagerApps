//
//  UIBarButtonItem+common.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14/11/5.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "UIBarButtonItem+common.h"

@implementation UIBarButtonItem (common)
+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:obj action:selector];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    return buttonItem;
}

@end
