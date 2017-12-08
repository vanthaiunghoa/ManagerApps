#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell

@property (nonatomic, strong) UIImage *image;

// 告诉cell是不是最后一个cell
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;

@end

