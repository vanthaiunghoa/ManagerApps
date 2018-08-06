//
//  ListCellProtocol.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/19.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#ifndef ListCellProtocol_h
#define ListCellProtocol_h

@protocol ListCellDataSource<NSObject>

- (NSString *)title;
- (NSString *)code;
- (NSAttributedString *)secondLabelContent;
- (NSAttributedString *)thirdLabelContent;
- (NSAttributedString *)fourthLabelContent;
- (NSAttributedString *)fifthLabelContent;
- (NSString *)status;
- (BOOL)shouldShowHandleButton;

@end

#endif /* ListCellProtocol_h */
