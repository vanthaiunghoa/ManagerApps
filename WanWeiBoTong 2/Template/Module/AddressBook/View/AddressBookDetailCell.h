//
//  AddressBookDetailCell.h
//  Template
//
//  Created by Apple on 2017/10/28.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressBookModel.h"



//MobileNumber:用户手机号
//MobileNumber2:用户手机号2
//OfficeNumber:办公电话
//HomeNumber:家庭电话
//ShortNumber:短号
//Email:电子邮件
//Address:通讯地址

typedef NS_ENUM(NSUInteger, PhoneType) {
    
    PhoneTypeHome=5,
    PhoneTypeOffice=4,
    PhoneTypeShort=3,
    PhoneTypeMessage=6,
    PhoneTypeAddress=7,
    PhoneTypeUserOne=1,
    PhoneTypeUserTwo=2
    
    
    
};

@protocol AddressBookDetailCellDelegate  <NSObject>

@optional

- (void)callPhone:(NSString*)numStr;

- (void)sendMessageToPhone:(NSString*)numStr;





@end



@interface AddressBookDetailCell : UITableViewCell

@property (nonatomic , strong ) AddressBookUserList * model ;

@property (nonatomic , assign ) PhoneType   type ;

@property (nonatomic , strong ) NSDictionary * dict ;


@property (nonatomic , weak ) id<AddressBookDetailCellDelegate> delegate ;


@property (nonatomic , assign ) BOOL  isOne ;

@end
