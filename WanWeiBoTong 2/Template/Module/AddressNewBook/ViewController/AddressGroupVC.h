//
//  AddressGroupVC.h
//  Template
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "FatherViewController.h"

#import "AddressBookModel.h"

@interface AddressGroupVC : FatherViewController

@property (nonatomic , assign ) NSInteger  section ;

@property (nonatomic , strong ) NSArray<AddressBookUserList*> * userList ;


@property (nonatomic , copy ) NSString * KSName ;

@end
