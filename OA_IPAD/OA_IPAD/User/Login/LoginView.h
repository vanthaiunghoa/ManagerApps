#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional

- (void)didLoginWithUserName:(NSString *)username AndPassWord:(NSString *)password;
- (void)didClickVPNSettingBtn;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

- (void)reloadData:(NSString *)account AndPassword:(NSString *)password;

@end

