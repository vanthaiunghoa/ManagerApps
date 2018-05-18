#import <Foundation/Foundation.h>

@interface ReceiveCommonModel : NSObject

@property (nonatomic, copy) NSString *Title;         // 内容  标题
@property (nonatomic, copy) NSString *LWDW;          // 标题  来文单位
@property (nonatomic, copy) NSString *SendDate;      // 交办时间
@property (nonatomic, copy) NSString *WhoGiveName;   // 交办人
@property (nonatomic, copy) NSString *BLSort;        // 权限
@property (nonatomic, copy) NSString *HJ;            // 类型  缓急
@property (nonatomic, copy) NSString *BLStatus;      // 办理状态
@property (nonatomic, copy) NSString *SWBH;          // 收文编号
@property (nonatomic, copy) NSString *LastDate;      // 要求办完日期
@property (nonatomic, copy) NSString *WH;            // 文号

@end
