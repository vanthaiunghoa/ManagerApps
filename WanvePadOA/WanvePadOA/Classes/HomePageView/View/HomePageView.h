//
//  HomePageView.h
//  zhPopupControllerDemo
//
//  Created by zhanghao on 2016/12/27.
//  Copyright © 2017年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconLabel;
@class IconLabelModel;

#define ROW_COUNT 4 // 每行显示4个
#define ROWS 2      // 每页显示2行
#define PAGES 2     // 共2页

@interface HomePageView : UIView

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<IconLabelModel *> *models;
@property (nonatomic, strong, readonly) NSMutableArray<IconLabel *> *items;

@property (nonatomic, copy) void (^didClickItems)(HomePageView *homeView, NSInteger index);

@end
