//
//  MainView.h
//  OA_IPAD
//
//  Created by wanve on 2018/7/5.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewDelegate <NSObject>

@optional

- (void)didClickLogout;
- (void)didClickIndex:(int )index;

@end

@interface MainView : UIView

@property (nonatomic, weak) id<MainViewDelegate> delegate;

- (void)reloadData:(NSString *)name;
- (void)reloadHello;

@end
