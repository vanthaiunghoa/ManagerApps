#import "StatisticsDetailViewController.h"
#import "SchemaViewController.h"
#import "UIColor+color.h"
#import "TrackViewController.h"
#import <FTPopOverMenu.h>
#import "NSString+extension.h"
#import "ZLImageTextButton.h"

@interface StatisticsDetailViewController ()

@property (nonatomic, strong) ZLImageTextButton *btnProject;

@end

@implementation StatisticsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitleNavBtn:@"万维博通大厦"];
}

- (void)setupTitleNavBtn:(NSString *)projectName
{
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalImageName:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logoutClicked:)];
    
    CGFloat width = [NSString calculateRowWidth:44 string:projectName fontSize:ZLFontSize] + ImageWidth + ImageTextDistance;
    
    _btnProject = [ZLImageTextButton buttonWithType:UIButtonTypeCustom];
    _btnProject.zlButtonType = ZLImageRightTextLeft;
    [_btnProject setImage:[UIImage imageNamed:@"white-arrow-down"] forState:UIControlStateNormal];
    [_btnProject setTitle:projectName forState:UIControlStateNormal];
    [_btnProject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnProject.frame = CGRectMake(0, 0, width, 44);
    //    [self.view addSubview:_btnProject];
    
    [_btnProject addTarget:self action:@selector(projectClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _btnProject;
}

#pragma mark -clicked

- (void)projectClicked:(UIButton *)sender
{
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.menuWidth = SCREEN_WIDTH - 8.0;
    configuration.textColor = [UIColor colorWithRGB:28 green:120 blue:255];
    configuration.menuRowHeight = 44;
    configuration.tintColor = [UIColor whiteColor];
    configuration.borderColor = [UIColor darkGrayColor];
    
    NSMutableArray *projects = [NSMutableArray array];
    [projects addObject:@"万维博通大厦"];
    [projects addObject:@"万维博通大厦一二"];
    [projects addObject:@"万维博通大厦三四五"];
    [projects addObject:@"万维博通大"];
    [projects addObject:@"万维博通大厦六"];
    [projects addObject:@"万维博通大厦八九十十一"];
    
    [FTPopOverMenu showForSender:sender
                   withMenuArray:projects
                       doneBlock:^(NSInteger selectedIndex)
     {
         NSString *text = projects[selectedIndex];
         if(text.length != _btnProject.titleLabel.text.length)
         {
             [_btnProject removeFromSuperview];
             [self setupTitleNavBtn:text];
         }
         else
         {
             [_btnProject setTitle:text forState:UIControlStateNormal];
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
