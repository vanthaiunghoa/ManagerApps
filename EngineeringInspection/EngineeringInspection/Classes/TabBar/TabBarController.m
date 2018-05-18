#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "UIColor+color.h"
#import "UserModel.h"
#import "UserManager.h"

#define IndexClassKey   @"rootVCClassString"
#define IndexTitleKey   @"title"
#define IndexImgKey     @"imageName"
#define IndexSelImgKey  @"selectedImageName"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    NSArray *childItemsArray = [NSArray array];

        childItemsArray = @[
                             @{IndexClassKey  : @"TaskViewController",
                               IndexTitleKey  : @"我的任务",
                               IndexImgKey    : @"task-off",
                               IndexSelImgKey : @"task-on"},

                             @{IndexClassKey  : @"RecordViewController",
                               IndexTitleKey  : @"问题记录",
                               IndexImgKey    : @"record-off",
                               IndexSelImgKey : @"record-on"},

                             @{IndexClassKey  : @"StatisticsViewController",
                               IndexTitleKey  : @"统计及进度",
                               IndexImgKey    : @"statistics-off",
                               IndexSelImgKey : @"statistics-on"},

                             @{IndexClassKey  : @"SetUpViewController",
                               IndexTitleKey  : @"设置",
                               IndexImgKey    : @"setup-off",
                               IndexSelImgKey : @"setup-on"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[IndexClassKey]) new];
        vc.title = dict[IndexTitleKey];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[IndexTitleKey];
        item.image = [UIImage imageNamed:dict[IndexImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[IndexSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#555555"]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#2CA5CF"]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    BaseNavigationController *nav =(BaseNavigationController *)viewController;
//    HomeViewController *home = nav.viewControllers.firstObject;
//
//    if(home)
//    {
//        if([home isKindOfClass:[HomeViewController class]])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHomeViewAgain" object:nil];
//        }
//    }
}

@end
