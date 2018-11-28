#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password;
- (void)didClickVPNSettingBtn;
- (void)didClickRegister;
- (void)didClickForgotPassword;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

- (void)reloadData;
- (void)bindUserNamePassword;

@end

