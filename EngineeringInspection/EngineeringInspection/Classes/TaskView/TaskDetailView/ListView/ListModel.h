#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property (nonatomic, copy) NSString *Title;         // 内容  标题
@property (nonatomic, copy) NSString *SendDate;      // 交办时间
@property (nonatomic, copy) NSString *WhoGiveName;   // 交办人
@property (nonatomic, copy) NSString *HJ;            // 类型  缓急
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) NSInteger keyForIndex;

@end
