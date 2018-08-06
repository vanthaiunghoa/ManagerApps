//
//  ChooseNameViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/7.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ChooseNameViewController.h"
#import "RequestManager.h"
#import "UserService.h"
#import "NSDictionary+CreateModel.h"
#import "Organization.h"
#import "Personel.h"
#import <MJExtension/MJExtension.h>
#import "MBProgressHUD+LCL.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PersonelSet.h"

static NSString *const organizationCellIdentifier = @"OrganizationCell";
static NSString *const staffCellIdentifier = @"StaffCell";
static NSInteger const labelTag = 332;
static NSInteger const checkMarkTag = 3;

@interface ChooseNameViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL searching;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *organizations;
@property (strong, nonatomic) NSArray *staff;
@property (strong, nonatomic) NSArray *searchStaff;

@property (strong, nonatomic) NSArray *searchOrganizations;
@property (weak, nonatomic) NSURLSessionDataTask *searchTask;
@property (nonatomic) NSInteger selectOrganizationIndex;
@property (weak, nonatomic) IBOutlet UIView *searchBarContainer;

@property (nonatomic, strong) PersonelSet *selectedPersonelSet;

@end

@implementation ChooseNameViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.showsCancelButton = YES;
    self.tableView1.tableFooterView = [UIView new];
    self.tableView2.tableFooterView = [UIView new];
//    self.searchBar.translucent = NO;
//    self.searchBar.barTintColor = [UIColor clearColor];
    [self loadOrganizations];
    
    if (self.mode == ChooseNameModeMultiple)
    {
        UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnConfirm setTintColor:[UIColor whiteColor]];
        [btnConfirm setTitle:@"确定" forState:0];
        [btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:22]];
        [btnConfirm addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnConfirm];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - data flow

- (void)loadOrganizations {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[RequestManager shared] requestWithAction:UserServiceGetOrganizationListAction appendingURL:UserServiceURL parameters:@{} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        if (success) {
            [hud hideAnimated:YES];
            NSArray *responseData = data[@"Datas"];
            self.organizations = [Organization mj_objectArrayWithKeyValuesArray:responseData];
            [self.tableView1 reloadData];
            [self loadStaff];
        } else {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
            [hud hideAnimated:YES afterDelay:2.0];
        }
    }];
}

- (void)loadStaff {
    self.staff = nil;
    [self.tableView2 reloadData];
    Organization *org = self.organizations[_selectOrganizationIndex];
    @weakify(self);
    [[RequestManager shared] requestWithAction:UserServiceGetStaffListAction appendingURL:UserServiceURL parameters:@{@"KSCode": org.KSCode, @"UserRightType": @"", @"QZH": org.QZH} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        if (success) {
            NSArray *responseData = data;
            [responseData.firstObject createModelWithName:@"Personel"];
            self.staff = [Personel mj_objectArrayWithKeyValuesArray:responseData];
            [self.tableView2 reloadData];
            if (!self.tableView1.indexPathForSelectedRow) {
                [self.tableView1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectOrganizationIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedDescription;
            [hud hideAnimated:YES afterDelay:2.0];
        }
    }];
}

- (void)toSearchStaff {
    self.searchStaff = nil;
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
    [_searchTask cancel];
    MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"搜索中.." atView:self.tableView2];
    @weakify(self);
    _searchTask = [[RequestManager shared] requestWithAction:UserServiceSearchUser appendingURL:UserServiceURL parameters:@{@"FileType": @"SW", @"SearchContent": self.searchBar.text?:@"",@"pageSize":@200,@"searchRange":@"",@"isUseUserTitle":@0} callback:^(BOOL success, id data, NSError *error) {
        @strongify(self);
        if (success) {
            NSArray *responseData = data;
            [responseData.firstObject createModelWithName:@"Personel"];
            self.searchStaff = [Personel mj_objectArrayWithKeyValuesArray:responseData];
            [self.tableView2 reloadData];
            [hud hideAnimated:NO];
            
        } else {
            if (error.code != NSURLErrorCancelled) {
                hud.mode = MBProgressHUDModeText;
                hud.label.text = error.localizedDescription;
                [hud hideAnimated:YES afterDelay:2.0];
            } else {
                [hud hideAnimated:YES];
            }
        }
    }];
}


#pragma mark - view control

#pragma mark - actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView1) {
        self.selectOrganizationIndex = indexPath.row;
        [self loadStaff];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didChoosePersonel:)]) {
            Personel *p;
            if (searching) {
                p = self.searchStaff[indexPath.row];
            } else {
                p = self.staff[indexPath.row];
            }
            if (self.mode == ChooseNameModeSingle) {
                [self.delegate controller:self didChoosePersonel:p];
            } else {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImageView *checkMark = [cell.contentView viewWithTag:checkMarkTag];
                if ([self.selectedPersonelSet containsObject:p]) {
                    [self.selectedPersonelSet removeObject:p];
                    checkMark.hidden = YES;
                } else {
                    [self.selectedPersonelSet addObject:p];
                    checkMark.hidden = NO;
                }
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)confirm:(id)sender {
    [self.delegate controller:self didConfirmPensonel:self.selectedPersonelSet.orderSet.array];
}

#pragma mark - search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searching = YES;
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
   
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searching) {
        [self toSearchStaff];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    searching = NO;
    [_searchTask cancel];
    [self.tableView1 reloadData];
    [self.tableView2 reloadData];
    [self.tableView1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectOrganizationIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searching) {
        if (tableView == self.tableView1) {
            return 0;
        } else {
            return self.searchStaff.count;
        }
    } else {
        if (tableView == self.tableView1) {
            return self.organizations.count;
        } else {
            return self.staff.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (searching) {
        if (tableView == self.tableView1) {
            return nil;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:staffCellIdentifier forIndexPath:indexPath];
            UILabel *label = [cell.contentView viewWithTag:labelTag];
            Personel *p = self.searchStaff[indexPath.row];
            label.text = p.UserName;
            UIImageView *checkMark = [cell.contentView viewWithTag:checkMarkTag];
            checkMark.hidden = ![self.selectedPersonelSet containsObject:p];
        }
    } else {
        if (tableView == self.tableView1) {
            cell = [tableView dequeueReusableCellWithIdentifier:organizationCellIdentifier forIndexPath:indexPath];
            UILabel *label = [cell.contentView viewWithTag:labelTag];
            Organization *org = self.organizations[indexPath.row];
            label.text = org.KSName;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:staffCellIdentifier forIndexPath:indexPath];
            UILabel *label = [cell.contentView viewWithTag:labelTag];
            Personel *p = self.staff[indexPath.row];
            label.text = p.UserName;
            UIImageView *checkMark = [cell.contentView viewWithTag:checkMarkTag];
            checkMark.hidden = ![self.selectedPersonelSet containsObject:p];
        }
    }

    if (!cell.backgroundView) {
        UIView *selectionBackgroundView = [UIView new];
        selectionBackgroundView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
        cell.selectedBackgroundView = selectionBackgroundView;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - getter and setter

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        [_searchBarContainer addSubview:_searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.searchBarContainer);
        }];
        _searchBar.barTintColor = [UIColor colorWithWhite:0.976 alpha:1.0];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (void)setSelectedPersonel:(NSArray<Personel *> *)selectedPersonelList {
    if (selectedPersonelList) {
        _selectedPersonelSet = [PersonelSet setWithArray:selectedPersonelList];
    }
}

- (PersonelSet *)selectedPersonelSet {
    if (!_selectedPersonelSet) {
        _selectedPersonelSet = [[PersonelSet alloc] init];
    }
    return _selectedPersonelSet;
}
@end
