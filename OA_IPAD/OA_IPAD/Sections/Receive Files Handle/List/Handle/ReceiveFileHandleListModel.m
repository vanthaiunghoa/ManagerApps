//
//  ReceiveFileHandleListModel.m
//  Auto Created by CreateModel on 2018-03-28 18:04:00 +0000.
//

#import "ReceiveFileHandleListModel.h"
#import "UIColor+color.h"

@implementation ReceiveFileHandleListModel

- (NSString *)title {
    return self.Title;
}
- (NSString *)code {
    return self.SWBH;
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
    if (self.LastDate) {
        date = self.LastDate;
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
    return self.BLStatus;
}

- (BOOL)shouldShowHandleButton {
    return YES;
}

@end
