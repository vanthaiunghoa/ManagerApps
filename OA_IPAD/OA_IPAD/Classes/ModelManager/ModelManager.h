#import <Foundation/Foundation.h>
#import "ReceiveFileHandleListModel.h"

@interface ModelManager : NSObject

+ (instancetype)sharedModelManager;

@property (nonatomic, strong) ReceiveFileHandleListModel *model;
@property (nonatomic, strong) NSString *mainIdentifier;
@property (nonatomic, strong) NSString *recordIdentfier;

@end
