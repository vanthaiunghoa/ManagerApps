#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password;
- (void)didClickVPNSettingBtn;
- (void)didClickRegister;
- (void)didClickForget;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

- (void)reloadData;

@end

