//
//  SendFileSearchListViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/6.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendFileSearchListViewModel.h"
#import "SendFileSearchItem.h"
#import "FilePresentationViewController.h"
#import "SendFileService.h"
#import "SendFileHandleViewController.h"
#import "SendRetrievalDetailViewController.h"
#import "ModelManager.h"
#import "UIColor+color.h"

@interface SendFileSearchListViewModel()

@end

@implementation SendFileSearchListViewModel

- (NSString *)appendingURL {
    return SendFileServiceURL;
}

- (NSString *)action {
    return SendFileSearchListAction;
}

- (Class)modelType {
    return SendFileSearchItem.class;
}



// 点击标题下一步
- (UIViewController *)touchTitleNextViewControllerWithIndex:(NSInteger)index {
    return [self touchButtonNextViewControllerWithIndex :index];
}

// 点击办理按钮
- (UIViewController *)touchButtonNextViewControllerWithIndex:(NSInteger)index {
//    SendFileHandleViewController *next = [[UIStoryboard storyboardWithName:@"SendFileHandle" bundle:nil] instantiateViewControllerWithIdentifier:@"SendFileHandleViewController"];
    SendFileSearchItem *item = self.listItems[index];
//    next.identifier = item.GUID;
//    next.shouldHiddenAdviseCell = YES;
//    next.title = @"文件查看";
    
    [ModelManager sharedModelManager].mainIdentifier = item.GUID;
    SendRetrievalDetailViewController *vc = [[SendRetrievalDetailViewController alloc] init];
    vc.selectIndex = 0;
    vc.titleColorSelected = [UIColor colorWithHex:0x3D98FF];
    vc.titleColorNormal = [UIColor blackColor];
    vc.titleSizeSelected = 20;
    vc.titleSizeNormal = 20;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;

    return vc;
}

- (BOOL)shouldShowQuickHandleButton {
    return NO;
}

- (NSString *)nextButtonTitle {
    return @"查看";
}

@end
