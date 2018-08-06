//
//  SelectCell.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCellDelegate<NSObject>

- (void)updateDepartmentSelectStatus:(NSIndexPath *)indexPath;

@end

@class Personel;
@interface SelectCell : UITableViewCell

@property (nonatomic, weak) id<SelectCellDelegate> delegate;
@property (nonatomic, strong) Personel *model;
@property (nonatomic, assign) BOOL isHiddenLine;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
