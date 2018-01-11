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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager scanPeripherals];
    });
}

#pragma mark - HHBluetoothPrinterManagerDelegate

// 扫描到的设备
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [peripherals objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = dict[@"peripheral"];
    if(_printerBlock)
    {
        _printerBlock(self, peripheral);
    }
}

@end
