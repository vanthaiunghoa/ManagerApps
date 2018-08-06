//
//  ListPicker.h
//  OA_IPAD
//
//  Created by cello on 2018/4/11.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListPicker;
@protocol ListPickerDelegate<NSObject>
- (void)listPicker:(ListPicker *)picker didSelectItemAtIndex:(NSInteger)index title:(NSString *)title;
- (void)listPicker:(ListPicker *)picker didSelectHeader:(id)sender;
- (void)listPicker:(ListPicker *)picker didSelectFooter:(id)sender;

@end

@interface ListPicker : UIView

@property (copy, nonatomic) NSString *identifier; //用来区分某个picker选择的标识
/**
 默认是：请选择
 */
@property (copy, nonatomic) NSString *headerTitle;
/**
 默认： 关闭
 */
@property (copy, nonatomic) NSString *footerTitle;
@property (weak, nonatomic) id<ListPickerDelegate> delegate;
@property (strong, nonatomic) NSArray *titles;
/**
 默认最大高度：700;
 */
@property (nonatomic) CGFloat maxListHeight;

+ (instancetype)listPickerWithTitles:(NSArray<NSString *> *)titles
                            delegate:(id<ListPickerDelegate>)delegate;

/**
 从window上面消失。带有动画；不至于那么突兀
 */
- (void)dismissAnimated;

@end
