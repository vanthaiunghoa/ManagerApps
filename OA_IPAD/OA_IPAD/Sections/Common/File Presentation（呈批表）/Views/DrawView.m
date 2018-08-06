//
//  DrawView.m
//  画板
//
//  Created by zyj on 2017/12/13.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import "DrawView.h"


@interface MyUIBezierPath : UIBezierPath
@property(nonatomic,strong) UIColor *lineColor;
@end

@implementation MyUIBezierPath

@end



@implementation _InternalDrawView

-(NSArray *)paths{
    if(!_paths){
        _paths=[NSMutableArray array];
    }
    return _paths;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)resetEdge {
    referenceMinX = CGFLOAT_MAX;
    referenceMinY = CGFLOAT_MAX;
    referenceMaxX = CGFLOAT_MIN;
    referenceMaxY = CGFLOAT_MIN;
    
    thisMinX = CGFLOAT_MAX;
    thisMaxX = CGFLOAT_MIN;
    thisMinY = CGFLOAT_MAX;
    thisMaxY = CGFLOAT_MIN;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self mSuperview].scrollEnabled) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    //当手指按下的时候就创建一条路径
    MyUIBezierPath *path=[MyUIBezierPath bezierPath];
    //设置画笔宽度
    if(_lineWidth<=0){
        [path setLineWidth:3];
    }else{
        [path setLineWidth:_lineWidth];
    }
    //设置画笔颜色
    [path setLineColor:_lineColor];
    //设置起点
    [path moveToPoint:point];
    // 把每一次新创建的路径 添加到数组当中
    [self.paths addObject:path];
    //    [self evaluateThisView:point];
    //    CGPoint pointAtReferenceView = [touch locationInView:self.refrenceView];
    [self evaluateReference:point];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self mSuperview].scrollEnabled) {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    // 连线的点
    [[self.paths lastObject] addLineToPoint:point];
    // 重绘
    [self setNeedsDisplay];
    
    //    [self evaluateThisView:point];
    //    CGPoint pointAtReferenceView = [touch locationInView:self.refrenceView];
    [self evaluateReference:point];
    
    //    NSLog(@"%@", NSStringFromCGPoint(point));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self mSuperview].scrollEnabled) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    // 获取触摸对象
    UITouch *touch=[touches anyObject];
    // 获取手指的位置
    CGPoint point=[touch locationInView:touch.view];
    // 连线的点
    [[self.paths lastObject] addLineToPoint:point];
    
    //    [self evaluateThisView:point];
    //    CGPoint pointAtReferenceView = [touch locationInView:self.refrenceView];
    [self evaluateReference:point];
    // 重绘
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self mSuperview].scrollEnabled) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    if (self.paths.count) {
        [self.paths removeLastObject];
    }
}

- (void)evaluateReference:(CGPoint)point  {
    referenceMinX = MIN(point.x, referenceMinX);
    referenceMaxX = MAX(point.x, referenceMaxX);
    referenceMinY = MIN(point.y, referenceMinY);
    referenceMaxY = MAX(point.y, referenceMaxY);
}

- (void)evaluateThisView:(CGPoint)point {
    thisMinX = MIN(point.x, thisMinX);
    thisMaxX = MAX(point.x, thisMaxX);
    thisMinY = MIN(point.y, thisMinY);
    thisMaxY = MAX(point.y, thisMaxY);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (MyUIBezierPath *path in self.paths) {
        //设置颜色
        [path.lineColor set];
        // 设置连接处的样式
        [path setLineJoinStyle:kCGLineJoinRound];
        // 设置头尾的样式
        [path setLineCapStyle:kCGLineCapRound];
        //渲染
        [path stroke];
    }
}


- (CGRect)referenceRect {
    return CGRectMake(referenceMinX, referenceMinY, referenceMaxX-referenceMinX, referenceMaxY-referenceMinY);
}

- (UIScrollView *)mSuperview {
    return (UIScrollView *)(self.superview);
}
@end

@interface DrawView() <UIScrollViewDelegate>

@end

@implementation DrawView


- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self afterInitialize];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self afterInitialize];
    return self;
}
- (void)afterInitialize {
    [self.internal resetEdge];
    self.delegate = self;
    self.scrollEnabled = false; //默认手写模式
    self.maximumZoomScale = 3.0;
    self.bouncesZoom = false;
    self.minimumZoomScale = 1.0;
}


- (void)clean{
    [self.internal.paths removeAllObjects];
    [self.internal resetEdge];
    //重绘
    [self.internal setNeedsDisplay];
}


- (void)undo{
    [self.internal.paths removeLastObject];
    //重绘
    [self.internal setNeedsDisplay];
}

- (void)eraser{
    self.lineColor=self.backgroundColor;
}


//- (CGRect)thisMinRect {
//    return CGRectMake(thisMinX, thisMinY, thisMaxX-thisMinX, thisMaxY-thisMinY);
//}



- (CGRect)referenceRect {
    return [self.internal referenceRect];
}

@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;
- (void)setLineColor:(UIColor *)lineColor {
    self.internal.lineColor = lineColor;
}
- (void)setLineWidth:(CGFloat)lineWidth {
    self.internal.lineWidth = lineWidth;
}

- (UIColor *)lineColor {
    return self.internal.lineColor;
}

- (CGFloat)lineWidth {
    return self.internal.lineWidth;
}

- (_InternalDrawView *)internal {
    if (!_internal) {
        _internal = [[_InternalDrawView alloc] initWithFrame:self.bounds];
        [self addSubview:_internal];
    }
    return _internal;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.internal;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollEnabled) {
        self.chainableScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.originalOffset + scrollView.contentOffset.y);
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.internal.frame = self.bounds;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.scrollEnabled) {
        self.chainableScrollView.zoomScale = scrollView.zoomScale;
    }
}
@end
