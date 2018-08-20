//
//  TransactionListViewModel.h
//  OA_IPAD
//
//  Created by cello on 2018/4/6.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@protocol ListCellDataSource;
@class UIViewController;

@interface TransactionListViewModel : NSObject

#pragma mark - 需要配置的属性
/** 接口路径 */
@property (nonatomic, copy) NSString *appendingURL;
/** 操作方法 */
@property (nonatomic, copy) NSString *action;

@property (strong, nonatomic) RACCommand *requestListCommand;
@property (strong, nonatomic) NSMutableArray *listItems;
@property (strong, nonatomic) NSMutableArray *searchItems; //🔍搜索结果
@property (nonatomic) NSInteger totalPage;
@property (nonatomic, assign) BOOL isSearch;

#pragma mark - 提供给列表界面的方法；有一部分需要重写
/** 列表模型数据 */
@property (nonatomic, strong) NSArray<id<ListCellDataSource>> *models;

/** 列表的模型类；需要重写这个方法 */
- (Class )modelType;

/**
 请求列表; execute 传参：@{@"PageSize":@(_pageSize),@"PageNum":@(_pageNum)， @“SearchType”:@"ALL"}
 PageNum为1则为第一页；而不是0
 
 @return RACCommand；signal返回的数据是包含多个ListCellDataSource
 @see ListCellDataSource
 */
- (RACCommand *)requestListCommand;

/**
 快速处理

 @param models 模型数组
 @return 一个信号；成功或者失败
 */
- (RACSignal *)quickHandleModels:(NSArray<id<ListCellDataSource>> *)models advice:(NSString *)advice;

/**
 点击列表标题下一步跳转的页面
 
 @param index 索引
 @return 点击列表跳转的界面
 */
- (UIViewController *)touchTitleNextViewControllerWithIndex:(NSInteger)index;

/**
 创建点击标题右方显示的界面
 
 @param index 索引
 @return 点击标题右方显示的界面
 */
- (UIViewController *)touchButtonNextViewControllerWithIndex:(NSInteger)index;

/**
 是否要显示快速办理按钮
 */
- (BOOL)shouldShowQuickHandleButton;

- (NSString *)nextButtonTitle;

@end
