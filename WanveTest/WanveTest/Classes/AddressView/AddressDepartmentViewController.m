//
//  AddressDepartmentViewController.m
//  WanveTest
//
//  Created by wanve on 2018/1/23.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "AddressDepartmentViewController.h"
#import "AddressModel.h"
#import "AddressDetailViewController.h"

@interface AddressDepartmentViewController ()

@end

@implementation AddressDepartmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _departmentModel.KSName;
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _departmentModel.UserList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"user-logo"];
    UserListModel *model = _departmentModel.UserList[indexPath.row];
    cell.textLabel.text = model.UserName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressDetailViewController *vc = [AddressDetailViewController new];
    UserListModel *model = _departmentModel.UserList[indexPath.row];
    model.kSName = _departmentModel.KSName;
    vc.userListModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
