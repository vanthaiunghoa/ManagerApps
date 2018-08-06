//
//  ListCell.h
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCellProtocol.h"

// 不管后台传过来的数据模型怎么样，都可以转化成这种数据形式；这样model和cell就没有耦合了
//@protocol ListCellDataSource<NSObject>
//
//- (NSString *)title;
//- (NSString *)code;
//- (NSAttributedString *)secondLabelContent;
//- (NSAttributedString *)thirdLabelContent;
//- (NSAttributedString *)fourthLabelContent;
//- (NSAttributedString *)fifthLabelContent;
//- (NSString *)status;
//- (BOOL)shouldShowHandleButton;
//
//@end

@protocol ListCellDelegate<NSObject>

- (void)handleButton:(id)sender touchedAtIndexPath:(NSIndexPath *)indexPath;
- (void)handleTitleButton:(id)sender touchedAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ListCell : UITableViewCell

@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic, weak) id<ListCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifithLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/**
 根据数据模型建立起cell的样式

 @param dataSource 数据模型协议；model需遵循这个协议，返回相应控件显示的数据
 */
- (void)setDataSource:(id<ListCellDataSource>)dataSource;

@end
