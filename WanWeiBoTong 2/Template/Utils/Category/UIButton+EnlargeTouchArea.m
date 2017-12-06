//
//  UIButton+EnlargeTouchArea.m
//  ProtectEyesGreatMaster
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "UIButton+EnlargeTouchArea.h"
#import <objc/runtime.h>
@implementation UIButton (EnlargeTouchArea)


static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    
//    return nil;
    
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
//        // 1.判断自己能否接收触摸事件
//        if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
//        // 2.判断触摸点在不在自己范围内
//        if (![self pointInside:point withEvent:event]){
//         
//            return nil;
//            
//        }
//        // 3.从后往前遍历自己的子控件，看是否有子控件更适合响应此事件
//        NSInteger count = self.subviews.count;
//        
//        for (NSInteger i = count - 1; i >= 0; i--) {
//            UIView *childView = self.subviews[i];
//            CGPoint childPoint = [self convertPoint:point toView:childView];
//            
//            UIView *fitView = [childView hitTest:childPoint withEvent:event];
//            
//            if (fitView) {
//                
//                return fitView;
//                
//                
//            }
//        }
//        
////         CGPoint lastPoint = [self convertPoint:point toView:self];
//
//         return CGRectContainsPoint(rect, point) ? self : nil;
        
    }
    
      // 没有找到比自己更合适的view
    
    return CGRectContainsPoint(rect, point) ? self : nil;
}




- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
    
    
}
@end

