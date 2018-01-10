#import "EIMTabBarController.h"
#import "BaseNavigationController.h"
#import "UIColor+color.h"

#define EIMClassKey   @"rootVCClassString"
#define EIMTitleKey   @"title"
#define EIMImgKey     @"imageName"
#define EIMSelImgKey  @"selectedImageName"

@interface EIMTabBarController ()

@end

@implementation EIMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *childItemsArray = @[
                                 @{EIMClassKey  : @"HomeViewController",
                                   EIMTitleKey  : @"首页",
                                   EIMImgKey    : @"index-off",
                                   EIMSelImgKey : @"index-on"},
  
                                 @{EIMClassKey  : @"MapViewController",
                                   EIMTitleKey  : @"项目地图",
                                   EIMImgKey    : @"map-off",
                                   EIMSelImgKey : @"map-on"},
  
                                 @{EIMClassKey  : @"StatisticsViewController",
                                   EIMTitleKey  : @"汇总统计",
                                   EIMImgKey    : @"statistics-off",
                                   EIMSelImgKey : @"statistics-on"},
  
                                 @{EIMClassKey  : @"CenterViewController",
                                   EIMTitleKey  : @"知识中心",
                                   EIMImgKey    : @"center-off",
                                   EIMSelImgKey : @"center-on"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[EIMClassKey]) new];
        vc.title = dict[EIMTitleKey];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[EIMTitleKey];
        item.image = [UIImage imageNamed:dict[EIMImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[EIMSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#555555"]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#2CA5CF"]} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
}

@end
