//
//  ChooseNameView.h
//  OA_IPAD
//
//  Created by cello on 2018/4/2.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Excel.h"
#import "Personel.h"
#import <ReactiveObjC/ReactiveObjC.h>

typedef NS_ENUM(NSUInteger, ChooseNameState) {
    ChooseNameSateUnchosen, //未选择
    ChooseNameStateChosen,
};

@class ChooseNameView;

@protocol ChooseNameViewDelegate<NSObject>

@required
- (void)chooseNameFromView:(ChooseNameView *)view; //选择姓名
- (void)cancelNameFromView:(ChooseNameView *)view; //取消当前的选择

@end

@interface ChooseNameView : UIView

@property (nonatomic, copy) NSString *identifier; //标识
@property (weak, nonatomic) id<ChooseNameViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton *chooseNameButton;
@property (nonatomic, weak) IBOutlet Excel *chooseNameContainer;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic) ChooseNameState state;

@end

@interface RACSignal(StringMapToState)

/**
 将Personel信号转成ChooseNameState信号
 */
- (RACSignal *)mapToState;

/**
 将Personel信号转成String(name)信号
 */
- (RACSignal *)mapToName;

@end

@interface NSArray(StringMapToState)

/**
 将[Personel]转成String(
 */
- (NSString *)mapToNames;


@end
