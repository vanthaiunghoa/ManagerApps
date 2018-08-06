#import <UIKit/UIKit.h>

@interface IssuesCell : UITableViewCell

@property (copy, nonatomic) NSString *titleName;
@property (copy, nonatomic) NSString *flowName;
@property (assign, nonatomic) BOOL isHiddenLine;

@end
