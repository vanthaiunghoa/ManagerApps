#import <Foundation/Foundation.h>
#import "ReceiveFileHandleListModel.h"

@interface ModelManager : NSObject

+ (instancetype)sharedModelManager;

@property (nonatomic, strong) ReceiveFileHandleListModel *model;
@property (nonatomic, strong) NSString *mainIdentifier;
@property (nonatomic, strong) NSString *recordIdentfier;
@property (nonatomic, strong) NSMutableDictionary *dict;        // 发文查询
@property (nonatomic, strong) NSMutableDictionary *receiveDict; // 收文查询

@property (nonatomic, assign) BOOL isRefresh;

- (void)setDictNull;
- (void)setReceiveDictNull;

@end
