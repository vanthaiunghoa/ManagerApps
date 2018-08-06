#import <UIKit/UIKit.h>
#import "ListCellProtocol.h"


@interface SendRetrievalCell : UITableViewCell

/**
 根据数据模型建立起cell的样式
 
 @param dataSource 数据模型协议；model需遵循这个协议，返回相应控件显示的数据
 */
//- (void)setDataSource:(id<ListCellDataSource>)dataSource;

@property (nonatomic, strong) id<ListCellDataSource> model;

@end
