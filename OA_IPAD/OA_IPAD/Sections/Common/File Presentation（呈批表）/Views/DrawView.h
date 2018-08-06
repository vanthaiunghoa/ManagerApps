//
//  DrawView.h
//  画板
//
//  Created by zyj on 2017/12/13.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface _InternalDrawView: UIView{
    CGFloat referenceMinX;
    CGFloat referenceMaxX;
    CGFloat referenceMinY;
    CGFloat referenceMaxY;
    CGFloat thisMinX;
    CGFloat thisMaxX;
    CGFloat thisMinY;
    CGFloat thisMaxY;
}

@property (nonatomic, strong) NSMutableArray *paths;//用来管理画板上所有的路径
@property(nonatomic,assign) CGFloat lineWidth;//画笔宽度
@property(nonatomic,strong) UIColor* lineColor;//画笔颜色

@end

@interface DrawView : UIScrollView
@property(nonatomic,assign) CGFloat lineWidth;//画笔宽度
@property(nonatomic,strong) UIColor* lineColor;//画笔颜色
@property (nonatomic) CGFloat originalOffset;
- (void)clean;//清除画板
- (void)undo;//回退上一步
- (void)eraser;//橡皮擦

@property (weak, nonatomic) UIView *refrenceView;
@property (nonatomic, strong) _InternalDrawView *internal;

@property (weak, nonatomic) UIScrollView *chainableScrollView;
- (CGRect)referenceRect; //获取轨迹最小的位置和大小

//- (CGRect)thisMinRect ;
@end

