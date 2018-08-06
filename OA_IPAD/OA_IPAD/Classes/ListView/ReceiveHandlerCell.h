#import <UIKit/UIKit.h>
#import "ListCellProtocol.h"

@protocol ReceiveHandlerCellDelegate<NSObject>

- (void)handlerModel:(NSIndexPath *)indexPath isSelected:(BOOL )isSelected;
- (void)approval:(NSIndexPath *)indexPath;

@end

@interface ReceiveHandlerCell : UITableViewCell

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<ReceiveHandlerCellDelegate> delegate;


/**
 根据数据模型建立起cell的样式
 
 @param dataSource 数据模型协议；model需遵循这个协议，返回相应控件显示的数据
 */
//- (void)setDataSource:(id<ListCellDataSource>)dataSource;

@property (nonatomic, strong) id<ListCellDataSource> model;

@end
