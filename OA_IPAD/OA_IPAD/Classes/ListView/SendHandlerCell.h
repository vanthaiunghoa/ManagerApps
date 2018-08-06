#import <UIKit/UIKit.h>
#import "ListCellProtocol.h"

@protocol SendHandlerCellDelegate<NSObject>

- (void)approval:(NSIndexPath *)indexPath;

@end

@interface SendHandlerCell : UITableViewCell

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, weak) id<SendHandlerCellDelegate> delegate;


/**
 根据数据模型建立起cell的样式
 
 @param dataSource 数据模型协议；model需遵循这个协议，返回相应控件显示的数据
 */
//- (void)setDataSource:(id<ListCellDataSource>)dataSource;

@property (nonatomic, strong) id<ListCellDataSource> model;

@end
