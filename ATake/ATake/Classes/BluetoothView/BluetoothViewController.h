//
//  BluetoothViewController.h
//  ATake
//
//  Created by wanve on 2018/1/8.
//  Copyright © 2018年 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothViewController : UITableViewController

@property (copy, nonatomic) void(^printerBlock)(BluetoothViewController *vc);

@end
