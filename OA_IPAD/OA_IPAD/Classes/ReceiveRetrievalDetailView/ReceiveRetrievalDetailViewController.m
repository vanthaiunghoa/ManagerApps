#import "ReceiveRetrievalDetailViewController.h"
#import "ReceiveRetrievalContentViewController.h"
#import "ReceiveRetrievalRecordViewController.h"
#import "UIColor+color.h"

@interface ReceiveRetrievalDetailViewController ()


@end

@implementation ReceiveRetrievalDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"文件查看";
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 2) {
        case 0: return @"文件内容";
        case 1: return @"办理记录";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[ReceiveRetrievalContentViewController alloc] init];
        case 1: return [[ReceiveRetrievalRecordViewController alloc] init];
        case 2: return [[UIViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    menuView.backgroundColor = [UIColor whiteColor];
    CGFloat leftMargin = 0;
    CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 55);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}



@end
