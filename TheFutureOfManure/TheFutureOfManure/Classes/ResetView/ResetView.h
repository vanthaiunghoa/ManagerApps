#import <UIKit/UIKit.h>

@protocol ResetViewDelegate <NSObject>

@optional

- (void)didRegisterWithUserName:(NSString *)username AndPassWord:(NSString *)password;
- (void)didGetCode;

@end

@interface ResetView : UIView

@property (nonatomic, weak) id<ResetViewDelegate> delegate;

- (void)reloadData;

@end

