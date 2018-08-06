#import <UIKit/UIKit.h>

@class SendFileAttatchFileInfo;
@interface SendAttachmentCell : UITableViewCell

@property (nonatomic, strong) SendFileAttatchFileInfo *model;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
