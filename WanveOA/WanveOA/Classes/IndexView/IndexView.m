//
//  IndexView.m
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import "IndexView.h"
#import "IconLabel.h"
#import "UIColor+color.h"

@interface IndexView () <UIScrollViewDelegate> {
    CGFloat _gap, _space;
}
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *pageViews;

@end

@implementation IndexView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization {
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.pagingEnabled = YES;
    _scrollContainer.showsHorizontalScrollIndicator = NO;
    _scrollContainer.delaysContentTouches = YES;
    _scrollContainer.delegate = self;
    [self addSubview:_scrollContainer];
    
    _itemSize = CGSizeMake(75, 95);
    _gap = 15;
    _space = (SCREEN_WIDTH - ROW_COUNT * _itemSize.width) / (ROW_COUNT + 1);
    
    _scrollContainer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _scrollContainer.contentSize = CGSizeMake(PAGES * SCREEN_WIDTH, _scrollContainer.frame.size.height);
    
    _pageViews = @[].mutableCopy;
    CGFloat x = 0.0;
    for (NSInteger i = 0; i < PAGES; i++) {
        UIImageView *pageView = [UIImageView new];
        pageView.frame = CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        pageView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        x += SCREEN_WIDTH;
        pageView.userInteractionEnabled = YES;
        [_scrollContainer addSubview:pageView];
        [_pageViews addObject:pageView];
    }
}

- (void)setModels:(NSArray<IconLabelModel *> *)models
{
    _items = @[].mutableCopy;
    [_pageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < ROWS * ROW_COUNT; i++) {
            NSInteger l = i % ROW_COUNT;
            NSInteger v = i / ROW_COUNT;

            IconLabel *item = [IconLabel new];
            [imageView addSubview:item];
            [_items addObject:item];
            item.tag = i + idx * (ROWS *ROW_COUNT);
            if (item.tag < models.count) {
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)]];
                item.model = [models objectAtIndex:item.tag];
                item.iconView.userInteractionEnabled = NO;
                item.textLabel.font = [UIFont systemFontOfSize:14];
                item.textLabel.textColor = [UIColor colorWithRGB:82 green:82 blue:82];
                [item updateLayoutBySize:_itemSize finished:^(IconLabel *item)
                {
                    item.frame = CGRectMake(_space + (_itemSize.width  + _space) * l, item.frame.origin.y, _itemSize.width, _itemSize.height);
                    item.frame = CGRectMake(item.frame.origin.x, (_itemSize.height + _gap) * v + _gap + TOP_HEIGHT + 15, _itemSize.width, _itemSize.height);
                }];
            }
        }
    }];
}

- (void)itemClicked:(UITapGestureRecognizer *)recognizer  {
    if (ROWS * ROW_COUNT - 1 == recognizer.view.tag) {
        [_scrollContainer setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    } else {
        if (nil != self.didClickItems) {
            self.didClickItems(self, recognizer.view.tag);
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger index = scrollView.contentOffset.x /[UIScreen width] + 0.5;
//    _closeButton.userInteractionEnabled = index > 0;
//    [_closeIcon setImage:[UIImage imageNamed:(index ? @"sina_返回" : @"sina_关闭")] forState:UIControlStateNormal];
}

@end
