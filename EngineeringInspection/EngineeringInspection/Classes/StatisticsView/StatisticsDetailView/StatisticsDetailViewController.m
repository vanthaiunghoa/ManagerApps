#import "StatisticsDetailViewController.h"
#import "SchemaViewController.h"
#import "UIColor+color.h"
#import "TrackViewController.h"


@interface StatisticsDetailViewController ()

@end

@implementation StatisticsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return @"概况";
        case 1: return @"人员情况";
        case 2: return @"整改追踪";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[SchemaViewController alloc] init];
//        case 1: return [[ListViewController alloc] init];
        case 2: return [[TrackViewController alloc] init];
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
