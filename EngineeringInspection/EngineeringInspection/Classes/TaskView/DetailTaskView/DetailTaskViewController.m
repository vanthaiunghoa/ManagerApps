#import "DetailTaskViewController.h"
#import "ListViewController.h"
#import "InspectionItemViewController.h"
#import "UIColor+color.h"
#import "ZLImageTextButton.h"
#import "NSString+extension.h"
#import <FTPopOverMenu.h>

@interface DetailTaskViewController ()

@property (nonatomic, strong) ZLImageTextButton *btnRegion;

@end

@implementation DetailTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitleNavBtn:@"全部区域"];
}

- (void)setupTitleNavBtn:(NSString *)projectName
{
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutClicked:)];
    
    CGFloat width = [NSString calculateRowWidth:44 string:projectName fontSize:ZLFontSize] + ImageWidth + ImageTextDistance;
    
    _btnRegion = [ZLImageTextButton buttonWithType:UIButtonTypeCustom];
    _btnRegion.zlButtonType = ZLImageRightTextLeft;
    [_btnRegion setImage:[UIImage imageNamed:@"white-arrow-down"] forState:UIControlStateNormal];
    [_btnRegion setTitle:projectName forState:UIControlStateNormal];
    [_btnRegion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnRegion.frame = CGRectMake(0, 0, width, 44);
    //    [self.view addSubview:_btnRegion];
    
    [_btnRegion addTarget:self action:@selector(regionClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _btnRegion;
}

#pragma mark - clicked

- (void)regionClicked:(UIButton *)sender
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = SCREEN_WIDTH - 8.0;
    configuration.textColor = [UIColor colorWithRGB:28 green:120 blue:255];
    configuration.menuRowHeight = 44;
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor darkGrayColor];
    
    NSMutableArray *projects = [NSMutableArray array];
    [projects addObject:@"全部区域"];
    [projects addObject:@"方形区域"];
    [projects addObject:@"通信区域"];
    [projects addObject:@"检查区域"];
    [projects addObject:@"区域去与区域"];
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:projects
                       doneBlock:^(NSInteger selectedIndex)
     {
         NSString *text = projects[selectedIndex];
         if(text.length != _btnRegion.titleLabel.text.length)
         {
             [_btnRegion removeFromSuperview];
             [self setupTitleNavBtn:text];
         }
         else
         {
             [_btnRegion setTitle:text forState:UIControlStateNormal];
         }
     }
                    dismissBlock:^{
                        NSLog(@"user canceled. do nothing.");
                    }];
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
        case 2: return [[InspectionItemViewController alloc] init];
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
