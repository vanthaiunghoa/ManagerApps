//
//  AddressModel.h
//  WanveTest
//
//  Created by wanve on 2018/1/23.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserListModel : NSObject

@property (nonatomic, strong) NSString *MobileNumber2;  // 用户手机号2
@property (nonatomic, strong) NSString *Address;        // 通讯地址
@property (nonatomic, strong) NSString *OfficeNumber;   // 办公电话
@property (nonatomic, strong) NSString *MobileNumber;   // 用户手机号
@property (nonatomic, strong) NSString *UserName;       // 用户名
@property (nonatomic, strong) NSString *ShortNumber;    // 短号
@property (nonatomic, strong) NSString *HomeNumber;     // 家庭电话
@property (nonatomic, strong) NSString *Email;          // 电子邮件
@property (nonatomic, strong) NSString *kSName;         // 所属科室

@end


@interface AddressModel : NSObject

@property (nonatomic, strong) NSString *KSName;         // 科室名称
@property (nonatomic, strong) NSArray  *UserList;      

@end

@interface AddressDetailModel : NSObject

@property (nonatomic, strong) NSString *number;         
@property (nonatomic, strong) NSString *type;

@end

