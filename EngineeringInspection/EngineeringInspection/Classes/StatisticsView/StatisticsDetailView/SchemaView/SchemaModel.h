#import <Foundation/Foundation.h>

@interface SchemaModel : NSObject

@property (nonatomic, strong) NSString *name;     
@property (nonatomic, strong) NSString *distribute;     // 待指派
@property (nonatomic, strong) NSString *unrepair;       // 待修复
@property (nonatomic, strong) NSString *undestroy;      // 待销项
@property (nonatomic, strong) NSString *destroy;        // 已销项
@property (nonatomic, strong) NSString *record;         // 记录

@end
