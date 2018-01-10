//
//  PrintModel.h
//  ATake
//
//  Created by wanve on 2018/1/8.
//  Copyright © 2018年 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeesModel : NSObject

@property (nonatomic, strong) NSString *clothesName; // 衣物名称
@property (nonatomic, strong) NSNumber *quantity;    // 数量
@property (nonatomic, strong) NSNumber *amount;      // 总价

@end

@interface OrderClothessModel : NSObject

@property (nonatomic, strong) NSString *recvName;    // 联系人
@property (nonatomic, strong) NSString *recvCity;    // 取件城市
@property (nonatomic, strong) NSString *recvArea;    // 区域1
@property (nonatomic, strong) NSString *recvSecArea; // 区域2
@property (nonatomic, strong) NSString *recvAddress; // 详细地址
@property (nonatomic, assign) BOOL isUrgent;         // 是否加急

@end

@interface PrintModel : NSObject

@property (nonatomic, strong) NSString *orderNo;         // 支付订单号
@property (nonatomic, strong) NSNumber *offsetAmount;    // 优惠券抵扣金额
@property (nonatomic, strong) NSNumber *totalAmount;     // 总价
@property (nonatomic, strong) NSNumber *payAmount;       // 支付金额
@property (nonatomic, strong) NSArray *fees;
@property (nonatomic, strong) NSArray *orderClothess;

@end
