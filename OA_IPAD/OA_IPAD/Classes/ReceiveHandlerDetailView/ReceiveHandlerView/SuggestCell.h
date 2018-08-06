#import <UIKit/UIKit.h>

@protocol SuggestCellDelegate<NSObject>

- (void)handlerStatus:(BOOL )isDone;
- (void)didClickedUsual;

@end

@interface SuggestCell : UITableViewCell

@property (nonatomic, weak) id<SuggestCellDelegate> delegate;
@property (nonatomic, assign) BOOL isDone;

- (void)setText:(NSString *)text;
- (NSString *)getText;

@end
