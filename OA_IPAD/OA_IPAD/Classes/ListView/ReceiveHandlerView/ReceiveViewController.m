#import "ReceiveViewController.h"
#import "ReceiveHandlingViewController.h"
#import "ReceiveWaitingViewController.h"
#import "ReceiveDoneViewController.h"
#import "ReceiveAllViewController.h"
#import "ReceiveSearchViewController.h"
#import "UIColor+color.h"

@interface ReceiveViewController ()


@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收文办理";
    [self addSearchButton];
}

- (void)addSearchButton
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"search"];
    [searchButton setImage:image forState:0];
    [searchButton setTintColor:[UIColor whiteColor]];
    [searchButton setTitle:@"查询" forState:0];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [searchButton sizeToFit];
    [searchButton addTarget:self action:@selector(showSearchController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

- (void)showSearchController:(id)sender
{
    ReceiveSearchViewController *vc = [ReceiveSearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: return @"待办";
        case 1: return @"办理中";
        case 2: return @"办完";
        case 3: return @"全部";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: return [[ReceiveWaitingViewController alloc] init];
        case 1: return [[ReceiveHandlingViewController alloc] init];
        case 2: return [[ReceiveDoneViewController alloc] init];
        case 3: return [[ReceiveAllViewController alloc] init];
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
