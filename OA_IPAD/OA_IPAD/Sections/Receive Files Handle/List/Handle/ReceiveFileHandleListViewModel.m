//
//  ReceiveFileHandleListViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/3/28.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveFileHandleListViewModel.h"
#import "ReceiveTransactionService.h"
#import "ReceiveFileHandleViewController.h"
#import "FilePresentationViewController.h"
#import "ReceiveFileHandleListModel.h"
#import "ReceiveFilePresentationViewModel.h"
#import "AdviseCell.h"
#import "UserService.h"
#import "ReceiveHandlerDetailViewController.h"
#import "UIColor+color.h"
#import "ModelManager.h"

@interface ReceiveFileHandleListViewModel()

@end

@implementation ReceiveFileHandleListViewModel

- (NSString *)appendingURL
{
    return @"Handlers/SWMan/SWHandler.ashx";
}

- (NSString *)action
{
    if(self.isSearch)
    {
        return @"GetSWHandleList";
    }
    return @"GetSWHandleListOfBLState";
}
- (Class)modelType
{
    return ReceiveFileHandleListModel.class;
}

/**
 快速处理
 
 @param models 模型数组
 @return 一个信号；成功或者失败
 */
- (RACSignal *)quickHandleModels:(NSArray<ReceiveFileHandleListModel *> *)models advice:(NSString *)advice {
    
    NSMutableArray *signals = [NSMutableArray arrayWithCapacity:1];
    for (ReceiveFileHandleListModel *model in models) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"Where_GUID"] = model.WhereGUID;
        params[@"IFOK"] = @(1);
        params[@"YiJian"] = advice? : @"";
        params[@"BLTime"] = [[NSDate new] adviceCellDateString];
        params[@"SignUp"] = [UserService shared].currentUser.UserName?: @"";
        params[@"SendUserLastDate"] = @"";
        params[@"SendUserSNID"] = @"";
        params[@"SendUserBLSort"] = @"";
        RACSignal *this = [[ReceiveTransactionService shared] saveHandleInfo:params];
        [signals addObject:this];
    }
    
    return [RACSignal merge:signals];
}

// 点击标题下一步
- (UIViewController *)touchTitleNextViewControllerWithIndex:(NSInteger)index
{
    ReceiveFileHandleListModel *model = nil;
    if(self.isSearch)
    {
        model = [self.searchItems objectAtIndex:index];
    }
    else
    {
        model = [self.listItems objectAtIndex:index];
    }
    FilePresentationViewController *next = [[FilePresentationViewController alloc] initWithViewModel:[ReceiveFilePresentationViewModel new] mainGuid:model.MGUID whereGUID:model.WhereGUID];
    next.title = @"收文办理";
    return next;
}

// 点击办理按钮
- (UIViewController *)touchButtonNextViewControllerWithIndex:(NSInteger)index {
//    ReceiveFileHandleViewController *next = [[UIStoryboard storyboardWithName:@"ReceiveFileHandle" bundle:nil] instantiateViewControllerWithIdentifier:@"ReceiveFileHandleViewController"];
    
    ReceiveHandlerDetailViewController *vc = [[ReceiveHandlerDetailViewController alloc] init];
    vc.selectIndex = 0;
    vc.titleColorSelected = [UIColor colorWithHex:0x3D98FF];
    vc.titleColorNormal = [UIColor blackColor];
    vc.titleSizeSelected = 20;
    vc.titleSizeNormal = 20;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;
   
    ReceiveFileHandleListModel *model = nil;
    if(self.isSearch)
    {
        model = [self.searchItems objectAtIndex:index];
    }
    else
    {
        model = [self.listItems objectAtIndex:index];
    }
    [ModelManager sharedModelManager].model = model;
    
    return vc;
}


- (BOOL)shouldShowQuickHandleButton {
    return YES;
}


@end
