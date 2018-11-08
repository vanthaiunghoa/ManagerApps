#import <UIKit/UIKit.h>

@protocol RegisterViewDelegate <NSObject>

@optional

- (void)didRegisterWithUserName:(NSString *)username AndPassWord:(NSString *)password;
- (void)didGetCode;

@end

@interface RegisterView : UIView

@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

- (void)reloadData;

@end

