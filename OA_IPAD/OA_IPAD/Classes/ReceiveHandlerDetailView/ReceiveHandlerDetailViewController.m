#import "ReceiveHandlerDetailViewController.h"
#import "ReceiveHandlerViewController.h"
#import "ReceiveRecordViewController.h"
#import "ReceiveDistributeViewController.h"
#import "UIColor+color.h"

@interface ReceiveHandlerDetailViewController ()


@end

@implementation ReceiveHandlerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收文办理";
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"文件办理";
        case 1: return @"办理记录";
        case 2: return @"转派记录";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[ReceiveHandlerViewController alloc] init];
        case 1: return [[ReceiveRecordViewController alloc] init];
        case 2: return [[ReceiveDistributeViewController alloc] init];
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
