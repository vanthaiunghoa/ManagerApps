//
//  AddressBookModel.h
//  Template
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AddressBookUserList :NSObject

//DWName:单位名称
//KSName:科室名称
//UserName:用户名称
//MobileNumber:用户手机号
//MobileNumber2:用户手机号2
//OfficeNumber:办公电话
//HomeNumber:家庭电话
//ShortNumber:短号
//Email:电子邮件
//Address:通讯地址


@property (nonatomic , copy) NSString              * MobileNumber2;
@property (nonatomic , copy) NSString              * Address;
@property (nonatomic , copy) NSString              * OfficeNumber;
@property (nonatomic , copy) NSString              * MobileNumber;
@property (nonatomic , copy) NSString              * UserName;
@property (nonatomic , copy) NSString              * ShortNumber;
@property (nonatomic , copy) NSString              * HomeNumber;
@property (nonatomic , copy) NSString              * Email;

@property (nonatomic , assign ) BOOL               isSearch ;


@end



@interface AddressBookDataModel :NSObject

@property (nonatomic , strong) NSArray<AddressBookUserList *>              * UserList;

@property (nonatomic , copy) NSString              * KSName;

//标记是否展开
@property (nonatomic , copy ) NSString             *isOpen;


@end







@interface AddressBookModel :NSObject

@property (nonatomic , strong ) NSArray<AddressBookDataModel*> * data;


@end




