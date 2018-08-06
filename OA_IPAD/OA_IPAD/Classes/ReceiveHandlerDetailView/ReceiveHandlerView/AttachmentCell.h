#import <UIKit/UIKit.h>

@class ReceiveFileAttatchFileInfo;
@interface AttachmentCell : UITableViewCell

@property (nonatomic, strong) ReceiveFileAttatchFileInfo *model;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
