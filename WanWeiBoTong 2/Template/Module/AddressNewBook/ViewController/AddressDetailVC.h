//
//  AddressDetailVC.h
//  Template
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "FatherViewController.h"
#import "AddressBookModel.h"

@interface AddressDetailVC : FatherViewController

@property (nonatomic , strong ) AddressBookUserList * list;

@property (nonatomic , copy ) NSString * name ;

@end
