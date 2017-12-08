//
//  TableController.h
//  WanveOA
//
//  Created by wanve on 17/11/8.
//  Copyright © 2017年 wanve. All rights reserved.
//

#define MJPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#import <UIKit/UIKit.h>

@interface TableController : UITableViewController

@end
