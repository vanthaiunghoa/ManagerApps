//
//  SendFileAttatchFileInfo.m
//  Auto Created by CreateModel on 2018-04-07 02:22:04 +0000.
//

#import "SendFileAttatchFileInfo.h"
#import "SendFileService.h"

@implementation SendFileAttatchFileInfo

- (NSString *)name {
    return self.FileName;
}

- (void)setName:(NSString *)name {
    _FileName = name;
}
- (NSString *)identifier {
    return self.FileGUID;
}

- (NSString *)getSizeAction {
    return SendFileAttatchFileGetMaxSizeAction;
}
- (NSString *)downloadAction {
    return SendFileAttatchFileGetStream;
}
- (NSString *)serviceURL {
    return SendFileServiceURL;
}
@end
