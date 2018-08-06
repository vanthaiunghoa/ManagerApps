//
//  InfoCell.h
//  OA_IPAD
//
//  Created by cello on 2018/3/29.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *info1DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *info1ContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *info2DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *info2ContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *info3DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *info3ContentLabel;

@end
