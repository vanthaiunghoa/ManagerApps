//
//  DetailCell.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/17.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressDetailModel;
@protocol DetailCellDelegate <NSObject>

@optional

- (void)call:(AddressDetailModel *)model;
- (void)sendMessage:(AddressDetailModel *)model;

@end


@interface DetailCell : UITableViewCell

@property (nonatomic, strong) AddressDetailModel *model;
@property (nonatomic, weak) id<DetailCellDelegate> delegate;

@end
