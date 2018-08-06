//
//  URLConfiguration.h
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#ifndef URLConfiguration_h
#define URLConfiguration_h

//#define kServerURL @"http://202.104.110.143:8009/"
//#define kBaseURL [kServerURL stringByAppendingString:@"oasystem/"]

#define kServerURL @"http://121.15.203.82:9210/"
#define kBaseURL [kServerURL stringByAppendingString:@"oasystem2018/"]
#define kMeetingBaseURL [kServerURL stringByAppendingString:@"DMS_HWMS/"]
#define kCPBBaseURL [kBaseURL stringByAppendingString:@"RptFiles/APP/"]
#define ReceiveFileCPBURL(fileName, QZH, number, HandleID) [NSString stringWithFormat:@"%@SWMan/%@?QZH=%@&SNID=%@&HandleID=%@", kCPBBaseURL, fileName, QZH, number, HandleID]
#define SendFileCPBURL(fileName, QZH, number, HandleID) [NSString stringWithFormat:@"%@FWMan/%@?QZH=%@&SNID=%@&HandleID=%@", kCPBBaseURL, fileName, QZH, number, HandleID]

#endif /* URLConfiguration_h */
