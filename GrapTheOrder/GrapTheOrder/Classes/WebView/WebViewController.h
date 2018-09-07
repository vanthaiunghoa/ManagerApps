//
//  WebViewController.h
//  WanveTest
//
//  Created by wanve on 2017/11/27.
//  Copyright © 2017年 wanve. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Align_Left = 0X00,
    Align_Center,
    Align_Right,
}Align_Type_e;

typedef enum
{
    Char_Normal = 0X00,
    Char_Zoom_2,
    Char_Zoom_3,
    Char_Zoom_4
}Char_Zoom_Num_e;

typedef enum
{
    TICKET_SALE = 1,
    TICKET_CARD,
}TYPE_TICKET;

typedef enum
{
    FeeList = 0,
    QRCode
}PrintType;

#define MAX_CHARACTERISTIC_VALUE_SIZE 20

@interface WebViewController : UIViewController<UIWebViewDelegate>

@end
