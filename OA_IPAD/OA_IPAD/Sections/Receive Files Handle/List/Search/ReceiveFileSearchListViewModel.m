//
//  ReceiveFileSearchListViewModel.m
//  OA_IPAD
//
//  Created by cello on 2018/4/8.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ReceiveFileSearchListViewModel.h"
#import "ReceiveTransactionService.h"
#import "ReceiveFileSearchItem.h"
#import "ReceiveFileReviewViewController.h"
#import "ModelManager.h"
#import "ReceiveRetrievalDetailViewController.h"
#import "UIColor+color.h"

@implementation ReceiveFileSearchListViewModel

- (NSString *)appendingURL {
    return ReceiveFileServiceURL;
}

- (NSString *)action {
    return ReceiveFileSearchListAction;
}
- (Class)modelType {
    return ReceiveFileSearchItem.class;
}


// 点击标题下一步
- (UIViewController *)touchTitleNextViewControllerWithIndex:(NSInteger)index {
    return [self touchButtonNextViewControllerWithIndex:index];
}

// 点击办理按钮
- (UIViewController *)touchButtonNextViewControllerWithIndex:(NSInteger)index {
//    ReceiveFileReviewViewController *vc = [[UIStoryboard storyboardWithName:@"ReceiveFileHandle" bundle:nil] instantiateViewControllerWithIdentifier:@"ReceiveFileReviewViewController"];
    ReceiveFileSearchItem *item = self.listItems[index];
//    vc.title = @"文件查看";
//    vc.mainIdentifier = item.MainGUID;

    [ModelManager sharedModelManager].mainIdentifier = item.MainGUID;
    ReceiveRetrievalDetailViewController *vc = [[ReceiveRetrievalDetailViewController alloc] init];
    vc.selectIndex = 0;
    vc.titleColorSelected = [UIColor colorWithHex:0x3D98FF];
    vc.titleColorNormal = [UIColor blackColor];
    vc.titleSizeSelected = 20;
    vc.titleSizeNormal = 20;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;
    
    return vc;
}

- (NSString *)nextButtonTitle {
    return @"查看";
}

- (BOOL)shouldShowQuickHandleButton {
    return NO;
}

@end
