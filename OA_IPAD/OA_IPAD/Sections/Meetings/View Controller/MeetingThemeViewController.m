//
//  MeetingThemeViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/7.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "MeetingThemeViewController.h"
#import "MeetingsService.h"
#import "MeetingAttatchFile.h"
#import "MeetingTheme.h"
#import "FilePreViewController.h"
#import "MeetingPreviewViewModel.h"

@interface MeetingThemeViewController ()

@property (nonatomic, strong) MeetingTheme *theme;
@property (nonatomic, strong) NSArray *attatchFiles;

@end

@implementation MeetingThemeViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ ♻️", NSStringFromClass(self.class));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    UIView *bg =  [UIView new];
    bg.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = bg;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.title = @"议题";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
    [self _loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data flow

- (void)_loadData {
    @weakify(self);
    [[[MeetingsService shared] meetingThemeInfosForMeetingID:self.meetingInfo[@"MM_SNID"] themeID:self.meetingInfo[@"MF_SNID"]] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.theme = x;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } error:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - table view\

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return TableViewHeaderHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
        header.backgroundColor = [UIColor whiteColor];
        return header;
    } else {
        UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
        UIView *bg = [UIView new];
        bg.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        header.backgroundView = bg;
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return false;
    } else {
        return true;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetingAttatchFile *file = self.attatchFiles[indexPath.row];
    FilePreViewController *pre = [[FilePreViewController alloc] init];
    
    pre.isMeeting = true;
    pre.themeID = self.theme.MF_SNID;
    pre.maxLength = [file.fileLength integerValue];
    pre.fileModel = file;
    
    MeetingPreviewViewModel *vm = [MeetingPreviewViewModel new];
    pre.viewModel = vm;
    vm.recordIdentifier =  self.theme.MF_SNID;
    
    [self.navigationController pushViewController:pre animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return self.attatchFiles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Normal" forIndexPath:indexPath];
        UILabel *label1 = [cell.contentView viewWithTag:1];
        UILabel *label2 = [cell.contentView viewWithTag:2];
        if (indexPath.row == 0) {
            label1.text = @"会议：";
            label2.text = self.meetingName;
        } else if (indexPath.row == 1) {
            label1.text = @"议题：";
            label2.text = self.meetingInfo[@"FlowName"];
        } else if (indexPath.row == 2) {
            label1.text = @"主办科室：";
            label2.text = self.meetingInfo[@"ZBKS"];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttatchFile" forIndexPath:indexPath];
        MeetingAttatchFile *file = self.attatchFiles[indexPath.row];
        UIImageView *imageView = [cell.contentView viewWithTag:1];
        UILabel  *label = [cell.contentView viewWithTag:2];
        NSString *fileType = [file.Name pathExtension];
        if ([fileType isEqualToString:@"pdf"]) {
            imageView.image = [UIImage imageNamed:@"pdf"];
        } else if ([fileType isEqualToString:@"doc"] || [fileType isEqualToString:@"docx"]) {
            imageView.image = [UIImage imageNamed:@"word"];
        } else {
            imageView.image = [UIImage imageNamed:@"search"];
        }
        label.text = file.Name;
        return cell;
    }
}

#pragma mark - getters and setters

- (NSArray *)attatchFiles {
    return self.theme.QWList;
}

@end
