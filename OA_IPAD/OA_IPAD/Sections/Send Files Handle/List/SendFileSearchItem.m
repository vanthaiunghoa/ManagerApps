//
//  SendFileSearchItem.m
//  Auto Created by CreateModel on 2018-04-06 13:36:49 +0000.
//

#import "SendFileSearchItem.h"
#import "UIColor+color.h"

@implementation SendFileSearchItem

- (NSString *)title {
    return self.BT;
}
- (NSString *)code {
    return self.FWH;
}
- (NSAttributedString *)secondLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"文   号：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *next = @"";
    if (self.WH) {
        next = self.WH;
        next = [next stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        next = [next stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        next = [next stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        next = [next stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:next attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}
- (NSAttributedString *)thirdLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"签发日期：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *date = @"";
    if (self.QFDate) {
        date = self.QFDate;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}
- (NSAttributedString *)fourthLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"拟稿人：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *date = @"";
    if (self.NGR) {
        date = self.NGR;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}

- (NSAttributedString *)fifthLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"文   种：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *content = @"";
    if (self.WZ) {
        content = self.WZ;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:241 green:84 blue:82]}]];
    return str;
}
- (NSString *)status {
    return self.BLState ;
}
- (BOOL)shouldShowHandleButton {
    return YES;
}

@end
