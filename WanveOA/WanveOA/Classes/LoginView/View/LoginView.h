#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@optional

- (void)didClickLoginBtn:(NSString *)username withPwd:(NSString *)pwd;

@end

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate>delegate;


//- (id)initWithFrame:(CGRect)frame;
//
//
//- (void)updateData;

@end

