#import <UIKit/UIKit.h>

@class ReceiveFileHandleRecord;
@interface DistributeCell : UITableViewCell

@property (nonatomic, strong) ReceiveFileHandleRecord *model;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
