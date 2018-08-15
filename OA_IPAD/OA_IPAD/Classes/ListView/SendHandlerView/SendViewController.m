#import "SendViewController.h"
#import "SendNeedViewController.h"
#import "SendWaitingViewController.h"
#import "SendPrewViewController.h"
#import "SendAllViewController.h"
#import "UIColor+color.h"

@interface SendViewController ()


@end

@implementation SendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发文办理";
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

- (void)showSearchController:(id)sender {
//    TransactionSearchResultsViewController *vc = [TransactionSearchResultsViewController new];
//    vc.viewModel = self.viewModel;
//    vc.title = self.title;
//    [self.navigationController pushViewController:vc animated:NO];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: return @"须办理";
        case 1: return @"待办";
        case 2: return @"预览";
        case 3: return @"全部";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: return [[SendNeedViewController alloc] init];
        case 1: return [[SendWaitingViewController alloc] init];
        case 2: return [[SendPrewViewController alloc] init];
        case 3: return [[SendAllViewController alloc] init];
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
