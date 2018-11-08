#import <UIKit/UIKit.h>

@protocol ResetViewDelegate <NSObject>

@optional

- (void)didRegisterWithUserName:(NSString *)username code:(NSString *)code password:(NSString *)password;
- (void)didGetCode:(NSString *)num;

@end

@interface ResetView : UIView

@property (nonatomic, weak) id<ResetViewDelegate> delegate;

- (void)reloadData;
- (void)countDown;

@end

