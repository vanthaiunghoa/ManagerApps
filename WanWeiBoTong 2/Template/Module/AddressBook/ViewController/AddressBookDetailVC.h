//
//  AddressBookDetailVC.h
//  Template
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "FatherViewController.h"

#import "AddressBookModel.h"

@interface AddressBookDetailVC : FatherViewController

@property (nonatomic , strong ) UIViewController * fathViewController ;


+ (AddressBookDetailVC*)shareInstance;


+ (void)showDetailViewWith:(AddressBookModel*)model indexPath:(NSIndexPath*)indexPath;



+ (void)hide;


@end
