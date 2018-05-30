#import <UIKit/UIKit.h>

//@protocol FilterCellDelegate <NSObject>
//
//@optional
//
//- (void)didBtnClicked:(NSString *) selected:(BOOL )isSelected;
//
//@end

@interface FilterCell : UITableViewCell

//@property (nonatomic, weak) id<FilterCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) NSArray *detailArray;

@end
