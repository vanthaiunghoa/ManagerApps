#import <UIKit/UIKit.h>

@class ListModel;

@protocol FilterCellDelegate <NSObject>

@optional

- (void)didSelectClicked:(ListModel *)model selected:(BOOL )isSelected;

@end

@interface FilterCell : UITableViewCell

@property (nonatomic, weak) id<FilterCellDelegate> delegate;
@property (nonatomic, strong) ListModel *model;

@end
