#import <UIKit/UIKit.h>

@class DetailModel;
@interface PeopleCell : UITableViewCell

@property (nonatomic, strong) DetailModel *model;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
