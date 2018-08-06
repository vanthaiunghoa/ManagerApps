//
//  StartMeetingViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/7.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "StartMeetingViewController.h"
#import "MeetingTableViewCells.h"
#import "UIColor+color.h"
#import "MeetingsService.h"
#import "MeetingsInfo.h"
#import "MBProgressHUD+LCL.h"
#import "UIButton+AddIndexPath.h"
#import "MeetingThemeViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

static NSString *const reuseTitleCellIdentifier = @"TitleCell";
static NSString *const reusePlaceAndTimeCellIdentifier = @"PlaceAndTimeCell";
static NSString *const reuseInternalMeetingsCellIdentifier = @"InternalMeetingsCell";
static NSString *const reuseOtherMeetingsCellIdentifier = @"OtherMeetingsCell";
static NSString *const reuseOtherMeetingsHeaderCellIdentifier = @"OtherMeetingsHeaderCell";
static NSString *const reuseAttendenceCellIdentifier = @"AttendenceCell";

@interface StartMeetingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MeetingsInfo *dataSource;
@property (nonatomic, strong) NSArray *internalMeetings;
@property (nonatomic, strong) NSArray *otherMeetings;

@property (nonatomic, strong) NSMutableDictionary *attributedTextDict; //key: indexPath

@end

@implementation StartMeetingViewController

#pragma mark - view controller life cycle

- (void)dealloc {
    NSLog(@"%@ 销毁 ♻️", NSStringFromClass(self.class));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    [self.tableView registerClass:[AttendenceCell class] forCellReuseIdentifier:reuseAttendenceCellIdentifier];
    [self _loadData];
    self.title = @"开始会议";

    self.tableView.backgroundView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if ([UIDevice currentDevice].systemVersion.floatValue <= 11.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - data flows

- (void)_loadData {
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"请稍后.." atView:self.view];
    RACSignal *requestDetail = [[MeetingsService shared] meetingsInfoForIdentifier:self.identifier];
    @weakify(self);
    [requestDetail subscribeNext:^(MeetingsInfo *x) {
        @strongify(self);
        self.dataSource = x;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [hud hideAnimated:YES];
        [self _loadOthers];
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
        [hud showMessage:error.localizedDescription];
    }];

}

- (void)_loadOthers {
    @weakify(self);
    [[[MeetingsService shared] otherMeetingsForMeetingIdentifier:self.dataSource.MM_SNID] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.otherMeetings = x;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - view layout controller

- (NSMutableAttributedString *)strForIndexPath:(NSIndexPath *)indexPath {
    if (self.attributedTextDict[indexPath]) {
        return self.attributedTextDict[indexPath];
    }
    NSInteger count = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.row == count - 4) {
       return [self strWithType:@"参会领导名单：" personels:self.dataSource.MeetPersonLD index:indexPath];
    } else if (indexPath.row == count - 3) {
        return [self strWithType:@"列席人员名单：" personels:self.dataSource.MeetPersonLX index:indexPath];
    } else if (indexPath.row == count - 2) {
        return [self strWithType:@"请假人员名单：" personels:self.dataSource.MeetPersonQJ index:indexPath];
    }  else if (indexPath.row == count - 1) {
        return [self strWithType:@"会议记录名单：" personels:self.dataSource.MeetPersonJL index:indexPath];
    }
    return nil;
}

- (NSMutableAttributedString *)strWithType:(NSString *)type personels:(NSString *)personels index:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont systemFontOfSize:18];
    NSDictionary *typeAttr = @{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:[UIColor colorWithRGB:153 green:153 blue:153]};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:type attributes:typeAttr];
    if (personels.length == 0 || [personels isEqualToString:@"无"]) {
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"无" attributes:typeAttr]];
    } else {
        NSArray *componets = [personels componentsSeparatedByString:@"、"];
        NSAttributedString *empty = [[NSAttributedString alloc] initWithString:@"      " attributes:typeAttr];
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius = 5.0;
        border.insets = UIEdgeInsetsMake(-5, -6, -5, -6);
        border.strokeWidth = 1;
        border.strokeColor = [UIColor colorWithHex:0x3D98FF];
        border.lineStyle = YYTextLineStyleSingle;
        for (NSString *name in componets) {
            NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0x3D98FF]}];
            nameStr.yy_textBackgroundBorder = border;
            nameStr.yy_font = [UIFont systemFontOfSize:16];
            [str appendAttributedString:nameStr];
            [str appendAttributedString:empty];
        }
    }
    str.yy_lineSpacing = 20;
    str.yy_headIndent = 10;
    self.attributedTextDict[indexPath] = str;
    return str;
}

#pragma mark - actions

- (void)openInternalMeetings:(UIButton *)sender {
    NSInteger index = sender.cellIndexPath.row - 2;
    NSDictionary *internel = self.internalMeetings[index];
    MeetingThemeViewController *vc = [[UIStoryboard storyboardWithName:@"Meetings" bundle:nil] instantiateViewControllerWithIdentifier:@"MeetingThemeViewController"];
    vc.meetingInfo = internel;
    vc.meetingName = self.dataSource.MeetName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openOtherMeetings:(UIButton *)sender {
    NSInteger index = sender.cellIndexPath.row - 1;
    MeetingsInfo *other = self.otherMeetings[index];
    StartMeetingViewController *vc = [[UIStoryboard storyboardWithName:@"Meetings" bundle:nil] instantiateViewControllerWithIdentifier:@"StartMeetingViewController"];
    vc.identifier = other.MM_SNID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]-1) {
        return 0.1;
    } else {
        return 10.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UITableViewHeaderFooterView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [UITableViewHeaderFooterView new];
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    view.backgroundView = bgView;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6 + self.internalMeetings.count;
    } else {
        return 1 + self.otherMeetings.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    } else {
        return 52;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSInteger count = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == 0) {
            return 70;
        } else if (count - indexPath.row <= 4) {
             //后四行参与名单
            NSAttributedString *str = self.attributedTextDict[indexPath];
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 62, CGFLOAT_MAX) text:str];
            return layout.rowCount * 36 + 16;
        } else {
            return 50;
        }
    } else {
        if (indexPath.row == 0) {
            return 70;
        } else {
            return 50;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseTitleCellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = self.dataSource.MeetName;
            return cell;
        } else if (indexPath.row == 1) {
            PlaceAndTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reusePlaceAndTimeCellIdentifier forIndexPath:indexPath];
            cell.holdPlace.text = self.dataSource.MeetAddress;
            cell.holdDate.text = self.dataSource.MeetDateTime;
            return cell;
        } else if (indexPath.row >= count - 4) {
            AttendenceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseAttendenceCellIdentifier forIndexPath:indexPath];
            cell.label.attributedText = [self strForIndexPath:indexPath];
            return cell;
        } else {
            NSInteger index = indexPath.row-2;
            NSDictionary *meeting = self.internalMeetings[index];
            InternalMeetingsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseInternalMeetingsCellIdentifier forIndexPath:indexPath];
            [cell.titleButton setTitle:meeting[@"FlowName"] forState:0];
            cell.titleButton.cellIndexPath = indexPath;
            [cell.titleButton addTarget:self action:@selector(openInternalMeetings:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    
    } else {
        if (indexPath.row == 0) {
            return [tableView dequeueReusableCellWithIdentifier:reuseOtherMeetingsHeaderCellIdentifier forIndexPath:indexPath];
        } else {
            OtherMeetingsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseOtherMeetingsCellIdentifier forIndexPath:indexPath];
            NSInteger index = indexPath.row-1;
            MeetingsInfo *info = self.otherMeetings[index];
            [cell.titleButton setTitle:info.MeetName forState:0];
            cell.titleButton.cellIndexPath = [indexPath copy];
            [cell.titleButton addTarget:self action:@selector(openOtherMeetings:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}

#pragma mark - getters and setters

- (NSArray *)internalMeetings {
    return self.dataSource.MeetFlows;
}

- (NSMutableDictionary *)attributedTextDict {
    if (!_attributedTextDict) {
        _attributedTextDict = [NSMutableDictionary dictionary];
    }
    return _attributedTextDict;
}

@end
