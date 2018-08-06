//
//  ReceiveFileSearchItem.h
//  Auto Created by CreateModel on 2018-04-08 14:22:26 +0000.
//

#import <Foundation/Foundation.h>
#import "ListCellProtocol.h"

@interface ReceiveFileSearchItem : NSObject <ListCellDataSource>

/**
 @description: 收文办理类型
 @note: etc:阅件
*/
@property (nonatomic, copy) NSString *SWBL_Type;

/**
 @description: 收文编号
 @note: etc:SW201800054
*/
@property (nonatomic, copy) NSString *SWBH;

/**
 @description: 主表ID
 @note: etc:1b6b2ab2cd0545b48c4bc472229d1fbb
*/
@property (nonatomic, copy) NSString *MainGUID;

/**
 @description: 文号
 @note: etc:粤水建管〔2018〕10号
*/
@property (nonatomic, copy) NSString *WH;

/**
 @description: 文号序号
 @note: etc:2018
*/
@property (nonatomic, copy) NSString *WHN;

/**
 @description: 来文单位
 @note: etc:广东省水利厅
*/
@property (nonatomic, copy) NSString *LWDW;

/**
 @description: 文号头
 @note: etc:粤水建管
*/
@property (nonatomic, copy) NSString *WHT;

/**
 @description: 标题
 @note: etc:广东省水利厅关于公布广东省地方水利水电工程定额次要材料预算价格（2018年）的通知
*/
@property (nonatomic, copy) NSString *Title;

/**
 @description: 文号数
 @note: etc:10
*/
@property (nonatomic, copy) NSString *WHS;

/**
 @description: 收文登记日期
 @note: etc:2018-05-11
 */
@property (nonatomic, copy) NSString *RecDate;

/**
 @description: 文件全宗号
 @note: etc:
 */
@property (nonatomic, copy) NSString *FileQZH;

@end
