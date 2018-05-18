//
//  API.h
//  Template
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#ifndef API_h
#define API_h
#import <Foundation/Foundation.h>

static  NSString*const hello_world  = @"hello_world";//你好,这个世界


#define domin @"http://l.agewnet.cc/Api"

#ifdef DEBUG
//#define BaseUrl @"http://121.15.203.82:9210/DMS_Phone"
#define BaseUrl @"http://sljoa.dg/DMS_Phone"

#else
#define BaseUrl @"http://121.15.203.82:9210/DMS_Phone"

#endif


























#endif /* API_h */
