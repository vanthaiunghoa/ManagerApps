#import <Foundation/Foundation.h>

@interface SendCommonModel : NSObject

@property (nonatomic, copy) NSNumber *IFok;        // "办完标志",[0(未办), 1(办完), 2(办理中)]
@property (nonatomic, copy) NSString *BT;          // 标题
@property (nonatomic, copy) NSString *FinishDate;  // 办完日期
@property (nonatomic, copy) NSString *WhoGiveName; // 交办人


@end
