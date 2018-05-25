#import "DetailTaskViewController.h"
#import "ListViewController.h"
#import "UIColor+color.h"
//#import "ReceiveDoneHandlerView/ReceiveDoneHandlerViewController.h"
//#import "ReceiveHandlingView/ReceiveHandlingViewController.h"
//#import "ReceiveAllHandlerView/ReceiveAllHandlerViewController.h"

@interface DetailTaskViewController ()

@end

@implementation DetailTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"图纸模式";
        case 1: return @"清单模式";
        case 2: return @"检查项模式";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
//        case 0: return [[ReceiveNeedHandlerViewController alloc] init];
        case 1: return [[ListViewController alloc] init];
//        case 2: return [[ReceiveDoneHandlerViewController alloc] init];
//        case 3: return [[ReceiveAllHandlerViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index
{
    return [UIColor whiteColor];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    menuView.backgroundColor = [UIColor colorWithRGB:28 green:120 blue:255];
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
