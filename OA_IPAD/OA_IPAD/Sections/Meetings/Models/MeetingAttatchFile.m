//
//  MeetingAttatchFile.m
//  Auto Created by CreateModel on 2018-04-27 01:36:43 +0000.
//

#import "MeetingAttatchFile.h"
#import <MJExtension/MJExtension.h>
#import "MeetingsService.h"

@implementation MeetingAttatchFile

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id"
             };
}

- (NSString *)name {
    return self.Name;
}

- (void)setName:(NSString *)Name {
    _Name = Name;
}

- (NSString *)identifier {
    return self.ID;
}

- (NSString *)getSizeAction {
    return nil;
}
- (NSString *)downloadAction {
    return @"ReadMeetFlowFile";
}
- (NSString *)serviceURL {
    return MeetingsServiceURL;
}


@end
