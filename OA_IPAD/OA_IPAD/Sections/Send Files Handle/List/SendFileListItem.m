//
//  SendFileListItem.m
//  Auto Created by CreateModel on 2018-04-04 14:07:47 +0000.
//

#import "SendFileListItem.h"
#import "UIColor+color.h"

@implementation SendFileListItem

- (NSString *)title {
    return self.BT;
}
- (NSString *)code {
    return self.FWBH;
}
- (NSAttributedString *)secondLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"交办人：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *next = @"";
    if (self.WhoGiveName) {
        next = self.WhoGiveName;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:next attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}
- (NSAttributedString *)thirdLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"交办日期：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *date = @"";
    if (self.SendDate) {
        date = self.SendDate;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}
- (NSAttributedString *)fourthLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"办完日期：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *date = @"";
    if (self.FinishDate) {
        date = self.FinishDate;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}

- (NSAttributedString *)fifthLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"缓   急：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *content = @"";
    if (self.HJ) {
        content = self.HJ;
    }
    
    if([content isEqualToString:@"急件"])
    {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:241 green:85 blue:83]}]];
    }
    else
    {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    }
    return str;
}
- (NSString *)status {
    switch ([self.IFok integerValue]) {
        case 0: return @"未办";
        case 1: return @"办完";
        case 2: return @"办理中";
            
        default: return @"未知";
            break;
    }
}
- (BOOL)shouldShowHandleButton {
    return YES;
}




@end
