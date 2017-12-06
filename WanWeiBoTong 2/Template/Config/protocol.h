//
//  protocol.h
//  ProtectEyesGreatMaster
//
//  Created by Apple on 17/5/19.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#ifndef protocol_h
#define protocol_h
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^changeColor)(id);

@protocol LZBJSExport <JSExport>

@optional

- (void)ClickiOS:(id)parma;


- (changeColor)login;

-(id)getUserInfo;

-(NSString*)getToken;

-(id)topic:(id)topicId Details:(id)type;



-(NSString*)encrypt:(NSString*)tmp;


-(NSString*)decrypt:(NSString*)tmp;


-(id)getPlatform:(id)tmp;

//@param comIndex 圈子ID
//* @param comIndexName  圈子名称
-(id)create:(id)tmp1  Topic :(id)tmp2;//发帖

//获取商品详情
-(void)goodsDetails:(id)goodsId;



@end




#endif
