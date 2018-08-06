//
//  AttachedFilesCell.h
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Excel.h"

@class AttachedFilesCell;

@protocol AttachedFilesCellDelegate<NSObject>

@optional
/**
 点击文件按钮的回调

 @param cell 被点击的cell
 @param index 目前支持两个文件显示，即0或者1
 */
- (void)attachedFilesCell:(AttachedFilesCell *)cell didSelectFileAtIndex:(NSInteger)index;

@end

@interface AttachedFilesCell : UITableViewCell

@property (weak, nonatomic) id<AttachedFilesCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet Excel *ex1;
@property (weak, nonatomic) IBOutlet Excel *ex2;
@property (weak, nonatomic) IBOutlet UIButton *file1;
@property (weak, nonatomic) IBOutlet UIButton *file2;
@property (weak, nonatomic) IBOutlet UIImageView *file2LittleIcon;

@end

