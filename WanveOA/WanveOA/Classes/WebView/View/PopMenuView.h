//
//  PopMenuView.h
//  彩票
//
//  Created by xiaomage on 15/9/21.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopMenuView;

@protocol PopMenuViewDelegate <NSObject>

@optional

- (void)popMenuDidHide:(PopMenuView *)popMenu tag:(NSInteger)tag;

@end

@interface PopMenuView : UIView


@property (nonatomic, weak) id<PopMenuViewDelegate> delegate;

+ (instancetype)showInPoint:(CGPoint)point;
// completion:隐藏完成的时候需要做的事情
- (void)hideInPoint:(CGPoint)point completion:(void (^ __nullable)())completion;

@end
