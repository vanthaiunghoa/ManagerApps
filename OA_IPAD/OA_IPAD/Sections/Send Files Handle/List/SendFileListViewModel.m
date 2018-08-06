//
//  SendFileListViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/4.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "SendFileListViewModel.h"
#import "SendFileService.h"
#import "SendFileListItem.h"
#import "SendFileHandleViewController.h"
#import "FilePresentationViewController.h"
#import "SendFilePresentationViewModel.h"
#import "SendHandlerDetailViewController.h"
#import "ModelManager.h"
#import "UIColor+color.h"

@interface SendFileListViewModel()

@end

@implementation SendFileListViewModel

- (NSString *)appendingURL {
    return SendFileServiceURL;
}

- (NSString *)action {
    return SendFileHandleListAction;
}

- (Class)modelType {
    return SendFileListItem.class;
}


// 点击标题下一步
- (UIViewController *)touchTitleNextViewControllerWithIndex:(NSInteger)index {
    SendFileListItem *item = self.listItems[index];
    FilePresentationViewController *next = [[FilePresentationViewController alloc] initWithViewModel:[SendFilePresentationViewModel new] mainGuid:item.GUID whereGUID:item.Where_GUID];
    next.title = @"发文办理";
    return next;
}

// 点击办理按钮
- (UIViewController *)touchButtonNextViewControllerWithIndex:(NSInteger)index {
//    SendFileHandleViewController *next = [[UIStoryboard storyboardWithName:@"SendFileHandle" bundle:nil] instantiateViewControllerWithIdentifier:@"SendFileHandleViewController"];
    SendFileListItem *item = self.listItems[index];
//    next.identifier = item.GUID;
//    next.recordIdentfier = item.Where_GUID;
//    next.shouldHiddenAdviseCell = NO;
//    next.title = @"发文办理";
    
    [ModelManager sharedModelManager].mainIdentifier = item.GUID;
    [ModelManager sharedModelManager].recordIdentfier = item.Where_GUID;
    
    SendHandlerDetailViewController *vc = [[SendHandlerDetailViewController alloc] init];
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
    return @"办理";
}
@end
