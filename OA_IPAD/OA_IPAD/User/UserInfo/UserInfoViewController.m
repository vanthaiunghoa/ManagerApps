//
//  UserInfoViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/4/14.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell.h"
#import "UserService.h"
#import "MBProgressHUD+LCL.h"
#import "UIColor+Scheme.h"
@interface UserInfoViewController ()

@property (strong, nonatomic) UserInfo *user;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = 80;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.user = [UserService shared].currentUser;
    if (!self.user) {
        
        MBProgressHUD *hud = [MBProgressHUD makeActivityMessage:@"请稍后.." atView:self.tableView];
        @weakify(self);
        [[[UserService shared] fetchUserInfo] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.user = x;
            [self.tableView reloadData];
            [hud hideAnimated:YES];
        } error:^(NSError * _Nullable error) {
            [hud showMessage:error.localizedDescription];
        }];
    }
    
    self.tableView.tableFooterView = [UIView new];
    self.title = @"个人信息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self _configureNavigationBarWhenAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self _configureNavigationBarWhenAppear];
}

#pragma mark - views
- (void)_configureNavigationBarWhenAppear {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UINavigationBar *bar = self.navigationController.navigationBar;
    [bar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    bar.barTintColor = [UIColor schemeBlue];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.label1.text = @"中文名";
        cell.label2.text = self.user.UserName;
    }
    else if (indexPath.row == 1) {
        cell.label1.text = @"办公电话";
        cell.label2.text = self.user.FixPhone;
    }
    else if (indexPath.row == 2) {
        cell.label1.text = @"家庭电话";
        cell.label2.text = self.user.HomePhone;
    }
    else if (indexPath.row == 3) {
        cell.label1.text = @"手机号码";
        cell.label2.text = self.user.MobilePhone;
    }
    else if (indexPath.row == 4) {
        cell.label1.text = @"手机号码2";
        cell.label2.text = self.user.MobilePhone2;
    }
    else if (indexPath.row == 5) {
        cell.label1.text = @"手机短号";
        cell.label2.text = self.user.ShortMessagePhone;
    }
    else if (indexPath.row == 6) {
        cell.label1.text = @"电子邮件";
        cell.label2.text = self.user.Email;
    }
    else if (indexPath.row == 7) {
        cell.label1.text = @"通讯地址";
        cell.label2.text = self.user.Address;
    }
    else if (indexPath.row == 8) {
        cell.label1.text = @"备注";
        cell.label2.text = self.user.Memo;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
