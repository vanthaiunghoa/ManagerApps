//
//  TransactionListViewController.h
//  OA_IPAD
//
//  Created by cello on 2018/3/26.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionListViewModel.h"
#import "ListCell.h"

@interface TransactionListViewController : UIViewController <ListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *quickHandleButton;

@property (nonatomic, strong) TransactionListViewModel *viewModel;

@property (nonatomic, readonly) NSInteger currentPage;

@end
