#import <UIKit/UIKit.h>

@class ReceiveFileHandleRecord;
@protocol DistributeOperatorCellDelegate<NSObject>

- (void)selectedModel:(ReceiveFileHandleRecord *)model;

@end

@interface DistributeOperatorCell : UITableViewCell

@property (nonatomic, weak) id<DistributeOperatorCellDelegate> delegate;
@property (nonatomic, strong) ReceiveFileHandleRecord *model;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
