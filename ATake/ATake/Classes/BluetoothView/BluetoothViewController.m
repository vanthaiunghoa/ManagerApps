//
//  BluetoothViewController.m
//  ATake
//
//  Created by wanve on 2018/1/8.
//  Copyright © 2018年 self. All rights reserved.
//

#import "BluetoothViewController.h"
#import "HHBluetoothPrinterManager.h"

@interface BluetoothViewController ()<HHBluetoothPrinterManagerDelegate>
{
    HHBluetoothPrinterManager *manager;
    NSMutableArray *peripherals;
}
@end

@implementation BluetoothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"打印机";
    
    manager = [HHBluetoothPrinterManager sharedManager];
    manager.delegate = self;
    
    peripherals = [[NSMutableArray alloc]init];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [manager scanPeripherals];
//    });
    [self refresh];
}

#pragma mark UITableView + 下拉刷新 默认
- (void)refresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    [manager scanPeripherals];
}

#pragma mark - HHBluetoothPrinterManagerDelegate

- (void)openBluetooth
{
    [SVProgressHUD showInfoWithStatus:@"请打开蓝牙，下拉扫描设备"];
}

// 扫描到的设备
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
    self.tableView.mj_header.endRefreshing;
    PLog(@"scan peripheral == %@", peripheral.name);
    
    if (peripheral.name.length <= 0)
    {
        return ;
    }
    
    if (peripherals.count == 0)
    {
        NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
        [peripherals addObject:dict];
    }
    else
    {
        BOOL isExist = NO;
        for (int i = 0; i < peripherals.count; i++)
        {
            NSDictionary *dict = [peripherals objectAtIndex:i];
            CBPeripheral *per = dict[@"peripheral"];
            if ([per.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString])
            {
                isExist = YES;
                NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
                [peripherals replaceObjectAtIndex:i withObject:dict];
            }
        }
        
        if (!isExist)
        {
            NSDictionary *dict = @{@"peripheral":peripheral, @"RSSI":RSSI};
            [peripherals addObject:dict];
        }
    }
    
    [self.tableView reloadData];
}

- (void)didDisconnectPeripheral
{
    self.view.userInteractionEnabled = YES;
    [SVProgressHUD showInfoWithStatus:@"设备已经断开"];
}

- (void)didConnectPeripheral
{
    if(_printerBlock)
    {
        _printerBlock(self);
    }
}

- (void)didFailToConnectPeripheral
{
    self.view.userInteractionEnabled = YES;
    [SVProgressHUD showInfoWithStatus:@"连接设备失败"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = [peripherals objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = dict[@"peripheral"];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [peripherals objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = dict[@"peripheral"];
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"连接设备中..."];
    [manager connectPeripheral:peripheral];
}

@end
