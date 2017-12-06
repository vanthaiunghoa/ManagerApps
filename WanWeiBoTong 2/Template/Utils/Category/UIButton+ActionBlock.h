//
//  UIButton+ActionBlock.h
//  ProtectEyesGreatMaster
//
//  Created by Apple on 2017/9/28.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ActionBlock)


@property(nonatomic ,copy) void(^block)(UIButton*);


-(void)addTapBlock:(void(^)(UIButton*btn))block;


@end
