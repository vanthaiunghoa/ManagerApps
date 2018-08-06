#import <UIKit/UIKit.h>

@class ReceiveFileHandleRecord;
@interface RecordCell : UITableViewCell

@property (nonatomic, strong) ReceiveFileHandleRecord *model;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
