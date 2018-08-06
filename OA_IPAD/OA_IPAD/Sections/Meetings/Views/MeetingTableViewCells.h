//
//  MeetingTableViewCells.h
//  OA_IPAD
//
//  Created by 廖超龙 on 2018/4/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+AddIndexPath.h"
#import <YYText/YYText.h>

// 标题
@interface TitleCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

// 时间、地点
@interface PlaceAndTimeCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *holdPlace;
@property (weak, nonatomic) IBOutlet UILabel *holdDate;

@end

// 内部会议
@interface InternalMeetingsCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

// 其他会议
@interface OtherMeetingsCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

// 参与人员
@interface AttendenceCell: UITableViewCell

@property (nonatomic) CGFloat height;


@property (strong, nonatomic) YYLabel *label; //使用富文本

@end
