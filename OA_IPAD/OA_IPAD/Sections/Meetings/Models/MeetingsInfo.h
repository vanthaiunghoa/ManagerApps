//
//  MeetingsInfo.h
//  Auto Created by CreateModel on 2018-04-26 03:13:48 +0000.
//

#import <Foundation/Foundation.h>

@interface MeetingsInfo : NSObject

/**
 @description: 会议地址
 @note: etc:局会议室
*/
@property (nonatomic, copy) NSString *MeetAddress;

/**
 @description: 请假人员名单
 @note: etc:无
*/
@property (nonatomic, copy) NSString *MeetPersonQJ;

/**
 @description: 第二个会议
 @note: etc:(
        {
        FlowName = "\U5173\U4e8e\U5ba1\U5b9a\U4e1c\U839e\U5e02\U4e09\U9632\U6307\U6325\U90e8\U684c\U9762\U5e94\U6025\U6f14\U7ec3\U65b9\U6848\U7684\U95ee\U9898"; //会议题名
        MFType = ""; //议题类型
        "MF_SNID" = "MF_20180223170436609"; //议题唯一号
        "MM_SNID" = 20180223170415625; //会议唯一号
        QWList =         ( //议题附件（该方法不读取）
        );
        XH = "1.00";
        ZBKS = "\U4e09\U9632\U529e";
        isHasFlowRight = 1; //议题查看权限
    },
        {
        FlowName = "\U5173\U4e8e\U5ba1\U5b9a\U52a0\U5f3a\U6267\U6cd5\U8bc1\U7ba1\U7406\U548c\U6267\U6cd5\U57f9\U8bad\U7684\U5de5\U4f5c\U65b9\U6848\U7684\U95ee\U9898";
        MFType = "";
        "MF_SNID" = "MF_20180223170558828";
        "MM_SNID" = 20180223170415625;
        QWList =         (
        );
        XH = "2.00";
        ZBKS = "\U653f\U7b56\U6cd5\U89c4\U79d1";
        isHasFlowRight = 1;
    },
        {
        FlowName = "\U5173\U4e8e\U5ba1\U5b9a2018\U5e74\U5168\U9762\U63a8\U884c\U6cb3\U957f\U5236\U5ba3\U4f20\U5de5\U4f5c\U65b9\U6848\U7684\U95ee\U9898";
        MFType = "";
        "MF_SNID" = "MF_20180223170628687";
        "MM_SNID" = 20180223170415625;
        QWList =         (
        );
        XH = "3.00";
        ZBKS = "\U529e\U516c\U5ba4";
        isHasFlowRight = 1;
    },
        {
        FlowName = "\U5173\U4e8e\U5f00\U5c55\U5c81\U672b\U5e74\U521d\U5b89\U5168\U751f\U4ea7\U7763\U5bfc\U68c0\U67e5\U5de5\U4f5c\U7684\U95ee\U9898";
        MFType = "";
        "MF_SNID" = "MF_20180223170654250";
        "MM_SNID" = 20180223170415625;
        QWList =         (
        );
        XH = "4.00";
        ZBKS = "\U529e\U516c\U5ba4";
        isHasFlowRight = 1;
    },
        {
        FlowName = "\U9886\U5bfc\U5206\U7ba1\U91cd\U70b9\U5de5\U4f5c\U8fdb\U5c55\U60c5\U51b5\U8868\U6c47\U603b";
        MFType = "";
        "MF_SNID" = "MF_20180223170826171";
        "MM_SNID" = 20180223170415625;
        QWList =         (
        );
        XH = "6.00";
        ZBKS = "\U5c40\U9886\U5bfc";
        isHasFlowRight = 1;
    },
        {
        FlowName = "\U6d4b\U8bd5docx\U6587\U4ef6IPAD\U4e0b\U8f7d";
        MFType = "\U884c\U653f\U7c7b\U8bae\U9898";
        "MF_SNID" = "MF_20180305161348500";
        "MM_SNID" = 20180223170415625;
        QWList =         (
        );
        XH = "7.00";
        ZBKS = "\U529e\U516c\U5ba4";
        isHasFlowRight = 1;
    }
)
*/
@property (nonatomic, strong) NSArray *MeetFlows;

/**
 @description: 会议名称
 @note: etc:市水务局2018年第一次局务会议
*/
@property (nonatomic, copy) NSString *MeetName;

/**
 @description: 会议时间
 @note: etc:下午4:30
*/
@property (nonatomic, copy) NSString *MeetTime;

/**
 @description: 列席人员名单
 @note: etc:陈伟强
*/
@property (nonatomic, copy) NSString *MeetPersonLX;

/**
 @description: 会议单位全宗代码
 @note: etc:999
*/
@property (nonatomic, copy) NSString *MM_QZH;

/**
 @description: 会议登记人
 @note: etc:胡红林
*/
@property (nonatomic, copy) NSString *RegUserName;

/**
 @description: 会议唯一号
 @note: etc:20180223170415625
*/
@property (nonatomic, copy) NSString *MM_SNID;

/**
 @description: 参会领导名单
 @note: etc:江善东、依林、孔方彬、梁富民、王莉莉、领导、聂江尧、钟志豪、彭浩峻、郭嘉欣、胡红林
*/
@property (nonatomic, copy) NSString *MeetPersonLD;

/**
 @description: 会议记录人员名单
 @note: etc:无
*/
@property (nonatomic, copy) NSString *MeetPersonJL;

/**
 @description: 会议时间
 @note: etc:2月26日
*/
@property (nonatomic, copy) NSString *MeetDate;

/**
 @description: 完整会议时间
 @note: etc:2月26日下午4:30
*/
@property (nonatomic, copy) NSString *MeetDateTime;

@end
