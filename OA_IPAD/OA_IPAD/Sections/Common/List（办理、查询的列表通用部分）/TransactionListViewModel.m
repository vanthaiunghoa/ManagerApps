//
//  TransactionListViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/6.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "TransactionListViewModel.h"
#import "RequestManager.h"
#import "NSDictionary+CreateModel.h"
#import <MJExtension/MJExtension.h>

@interface TransactionListViewModel()

@end

@implementation TransactionListViewModel

- (RACCommand *)requestListCommand
{
    if (!_requestListCommand) {
        
        @weakify(self);
        _requestListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);

            RACSignal *responseSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:input];
                [[RequestManager shared] requestWithAction:self.action appendingURL:self.appendingURL parameters:dict callback:^(BOOL success, id data, NSError *error)
                 {
                    if (success)
                    {
                        NSString *strTotalPage = data[@"PageCount"];
                        self.totalPage = [strTotalPage integerValue];

                        NSArray *models = [self.modelType mj_objectArrayWithKeyValuesArray:data[@"Datas"]];
                        [[data[@"Datas"] firstObject] createModelWithName:NSStringFromClass(self.modelType)];
                        [subscriber sendNext:models];
                    }
                    else
                    {
                        [subscriber sendError:error];
                    }
                }];
                return nil;
            }];
            @weakify(self);
            return [responseSignal map:^id _Nullable(id  _Nullable value) {
                @strongify(self);
                
                if(self.isSearch)
                {
                    [self.searchItems addObjectsFromArray:value];
                }
                else
                {
                    [self.listItems addObjectsFromArray:value];
                }
                
                self.requestListCommand = nil; //允许下一个任务执行
                return value;
            }];
        }];
    }
    return _requestListCommand;
}

/**
 快速处理
 
 @param models 模型数组
 @return 一个信号；成功或者失败
 */
- (RACSignal *)quickHandleModels:(NSArray<id<ListCellDataSource>> *)models {
    return [RACSignal error:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"未实现"}]];
}

- (__unsafe_unretained Class )modelType {
    return [NSObject class];
}

// 点击标题下一步
- (UIViewController *)touchTitleNextViewControllerWithIndex:(NSInteger)index {
    return nil;
}

// 点击办理按钮
- (UIViewController *)touchButtonNextViewControllerWithIndex:(NSInteger)index {
    return nil;
}

@synthesize models = _models;
- (NSArray<id<ListCellDataSource>> *)models
{
    if(self.isSearch)
    {
        return self.searchItems;
    }
    return self.listItems;
}

- (void)setModels:(NSArray<id<ListCellDataSource>> *)models
{
    if(self.isSearch)
    {
        self.searchItems = [NSMutableArray arrayWithArray:models];
    }
    self.listItems = [NSMutableArray arrayWithArray:models];
}

- (BOOL)shouldShowQuickHandleButton {
    return NO;
}

- (NSString *)nextButtonTitle {
    return @"处理";
}

@end
