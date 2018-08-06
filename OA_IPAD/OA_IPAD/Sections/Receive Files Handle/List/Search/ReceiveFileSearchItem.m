//
//  ReceiveFileSearchItem.m
//  Auto Created by CreateModel on 2018-04-08 14:22:26 +0000.
//

#import "ReceiveFileSearchItem.h"
#import "UIColor+color.h"
#import <MJExtension/MJExtension.h>

@implementation ReceiveFileSearchItem


- (NSString *)title {
    return self.Title;
}
- (NSString *)code {
    return self.SWBH;
}
- (NSAttributedString *)secondLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"文    号：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
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
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"登记日期：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *date = @"";
    if (self.RecDate) {
        date = self.RecDate;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}
- (NSAttributedString *)fourthLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"来文单位：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *date = @"";
    if (self.LWDW) {
        date = self.LWDW;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:date attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:62 green:62 blue:82]}]];
    return str;
}

- (NSAttributedString *)fifthLabelContent {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"办理类型：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:135 green:135 blue:135]}]];
    NSString *content = @"";
    if (self.SWBL_Type) {
        content = self.SWBL_Type;
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:241 green:84 blue:82]}]];
    return str;
}
- (NSString *)status {
    return @"";
}
- (BOOL)shouldShowHandleButton {
    return YES;
}

@end
