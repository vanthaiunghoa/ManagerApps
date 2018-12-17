#import <UIKit/UIKit.h>

@protocol VPNSettingViewDelegate <NSObject>

@optional

- (void)didClickBackBtn;
- (void)didClickGetPassword;

@end

@interface VPNSettingView : UIView

@property (nonatomic, weak) id<VPNSettingViewDelegate> delegate;

- (void)reloadData;
- (void)countDown;

@end

