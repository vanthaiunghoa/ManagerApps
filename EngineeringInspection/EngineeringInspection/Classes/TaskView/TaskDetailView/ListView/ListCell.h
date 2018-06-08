#import <UIKit/UIKit.h>

@class ListModel;

@protocol ListCellDelegate <NSObject>

@optional

- (void)didSelectClicked:(ListModel *)model selected:(BOOL )isSelected;

@end

typedef void(^CellSelectedBlock)(ListModel *model);

@interface ListCell : UITableViewCell

@property (nonatomic, weak) id<ListCellDelegate> delegate;
@property (nonatomic, strong) ListModel *model;
- (void)cellSelectedWithBlock:(CellSelectedBlock)block;

@end
