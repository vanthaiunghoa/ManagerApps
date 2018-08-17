//
//  InputCell.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputCellDelegate<NSObject>

- (void)textFieldDidChange:(NSString *)valueOfKey value:(NSString *)value;

@end

@interface InputCell : UITableViewCell

@property (nonatomic, weak) id<InputCellDelegate> delegate;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL isHiddenLine;

@end
