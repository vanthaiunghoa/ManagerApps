#import "SendHandlerViewController.h"
#import "SendNeedHandlerView/SendNeedHandlerViewController.h"
#import "SendAllHandlerView/SendAllHandlerViewController.h"
#import "SendDoneHandlerView/SendDoneHandlerViewController.h"
#import "SendWaitHandlerView/SendWaitHandlerViewController.h"

@interface SendHandlerViewController ()

@end

@implementation SendHandlerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: return @"需办理";
        case 1: return @"待办";
        case 2: return @"办完";
        case 3: return @"全部";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: return [[SendNeedHandlerViewController alloc] init];
        case 1: return [[SendWaitHandlerViewController alloc] init];
        case 2: return [[SendDoneHandlerViewController alloc] init];
        case 3: return [[SendAllHandlerViewController alloc] init];
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
