#import "ReceiveHandlerDetailViewController.h"
#import "ReceiveHandlerDetailHandlerView/ReceiveHandlerDetailHandlerViewController.h"

@interface ReceiveHandlerDetailViewController ()

@end

@implementation ReceiveHandlerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"办理";
        case 1: return @"办理记录";
        case 2: return @"转派记录";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[ReceiveHandlerDetailHandlerViewController alloc] init];
//        case 1: return [[ReceiveHandlingViewController alloc] init];
//        case 2: return [[ReceiveDoneHandlerViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    CGFloat leftMargin = 0;
    CGFloat originY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}


@end
