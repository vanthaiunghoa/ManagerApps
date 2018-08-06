//
//  AdviseCell.h
//  OA_IPAD
//
//  Created by cello on 2018/4/1.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *assignmentTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseDateButton;
@property (weak, nonatomic) IBOutlet UIButton *doing;
@property (weak, nonatomic) IBOutlet UIButton *done;

@end

@interface NSDate(AdviceCell)

- (NSString *)adviceCellDateString;

@end
