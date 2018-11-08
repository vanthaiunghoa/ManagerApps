#import <UIKit/UIKit.h>

@protocol RegisterViewDelegate <NSObject>

@optional

- (void)didRegisterWithUserName:(NSString *)username code:(NSString *)code password:(NSString *)password;
- (void)didGetCode:(NSString *)num;

@end

@interface RegisterView : UIView

@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

- (void)reloadData;
- (void)countDown;

@end

