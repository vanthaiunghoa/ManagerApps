#import <UIKit/UIKit.h>

@class ListModel;

@protocol ListCellDelegate <NSObject>

@optional

- (void)didSelectClicked:(ListModel *)model selected:(BOOL )isSelected;

@end

@interface ListCell : UITableViewCell

@property (nonatomic, weak) id<ListCellDelegate> delegate;
@property (nonatomic, strong) ListModel *model;

@end
