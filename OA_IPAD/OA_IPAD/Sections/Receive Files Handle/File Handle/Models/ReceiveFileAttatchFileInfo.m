//
//  ReceiveFileAttatchFileInfo.m
//  Auto Created by CreateModel on 2018-04-14 02:44:50 +0000.
//

#import "ReceiveFileAttatchFileInfo.h"
#import "ReceiveTransactionService.h"

@implementation ReceiveFileAttatchFileInfo

- (NSString *)name {
    return self.Name;
}

- (void)setName:(NSString *)Name {
    _Name = Name;
}
- (NSString *)identifier {
    return self.GUID;
}
- (NSString *)getSizeAction {
    return AttatchFileGetSizeAction;
}
- (NSString *)downloadAction {
    return AttatchFileGetStreamAction;
}
- (NSString *)serviceURL {
    return ReceiveFileServiceURL;
}



@end
