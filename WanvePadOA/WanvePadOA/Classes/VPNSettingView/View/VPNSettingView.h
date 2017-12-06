#import <UIKit/UIKit.h>

@protocol VPNSettingViewDelegate <NSObject>

@optional

- (void)didClickBackBtn;

@end

@interface VPNSettingView : UIView

@property (nonatomic, weak) id<VPNSettingViewDelegate> delegate;

- (void)reloadData;

@end

