//
//  FileTransferCell.h
//  OA_IPAD
//
//  Created by cello on 2018/3/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Excel.h"
#import "ChooseNameView.h"

@interface FileTransferCell : UITableViewCell

// Part1 请。。。阅示
@property (weak, nonatomic) IBOutlet UILabel *operationText;
@property (weak, nonatomic) IBOutlet UILabel *operationKind;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet ChooseNameView *chooseName1;
@property (weak, nonatomic) IBOutlet UILabel *operationKind2;
@property (weak, nonatomic) IBOutlet UIButton *operation2Button;
@property (weak, nonatomic) IBOutlet UILabel *operation2Text;


// Part2 请？ 。。。 主办、协办、阅
@property (weak, nonatomic) IBOutlet UILabel *operationPart2Text;
@property (weak, nonatomic) IBOutlet UILabel *operationPart2Kind;
@property (weak, nonatomic) IBOutlet UIButton *operationPart2Button;

/** 选择主办人  */
@property (weak, nonatomic) IBOutlet ChooseNameView *mainChooseName;

/** 选择协办人 */
@property (weak, nonatomic) IBOutlet ChooseNameView *assistChooseName;

/** 选择审阅人 */
@property (weak, nonatomic) IBOutlet ChooseNameView *readChooseName;

// 办理类型
@property (weak, nonatomic) IBOutlet UILabel *handleKind;
@property (weak, nonatomic) IBOutlet UIButton *chooseHandleKind;

// 选择办完时间
@property (weak, nonatomic) IBOutlet UIButton *chooseDeadline;
@property (weak, nonatomic) IBOutlet UILabel *deadlineaLabel;

// 选项

/** 选择主办人 */
@property (weak, nonatomic) IBOutlet UIButton *trackingButton;

/**  自动生成语句 */
@property (weak, nonatomic) IBOutlet UIButton *autoGenerateButton;

/** 派送文件  */
@property (weak, nonatomic) IBOutlet UIButton *transferFileButton;

/** 发送短信  */
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;


@end

@interface NSDate(FileTransferCell)

- (NSString *)fileTransferDateString;

@end
