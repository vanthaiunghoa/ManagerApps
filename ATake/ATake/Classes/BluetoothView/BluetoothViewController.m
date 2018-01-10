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
    //选中的设备
//    CBPeripheral *selectedPeripheral;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager scanPeripherals];
    });
}

// 停止扫描
- (void)scanStop
{
    [manager cancelScan];
}

// 断开打印机
- (void)duankaiStart
{
    [manager cancelScan];
//    [manager duankai:selectedPeripheral];
}

#pragma mark - HHBluetoothPrinterManagerDelegate

// 扫描到的设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
{
    PLog(@"scan peripheral == %@", peripheral.name);
    if(peripheral.name)
    {
        [peripherals addObject:peripheral];
        [self.tableView reloadData];
    }
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
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    selectedPeripheral = [peripherals objectAtIndex:indexPath.row];
//    [manager connectPeripheral:[peripherals objectAtIndex:indexPath.row]];
    if(_printerBlock)
    {
        _printerBlock(self, [peripherals objectAtIndex:indexPath.row]);
    }
}

@end
