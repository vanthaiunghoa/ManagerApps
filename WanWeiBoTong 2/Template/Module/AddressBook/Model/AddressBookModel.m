//
//  AddressBookModel.m
//  Template
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "AddressBookModel.h"

@implementation AddressBookUserList





@end

@implementation AddressBookDataModel

+ (NSDictionary*)mj_objectClassInArray{
    
    
    
    return @{@"UserList":[AddressBookUserList className]};
}



@end

@implementation AddressBookModel

+ (NSDictionary*)mj_objectClassInArray{
    
    
    
    return @{@"data":[AddressBookDataModel className]};
}









    
    
    
    





@end
