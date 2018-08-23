#import <UIKit/UIKit.h>
#import "Toolbar.h"

NS_ASSUME_NONNULL_BEGIN

@class CommonPickerView;

@protocol  CommonPickerViewDelegate<NSObject>

- (void)pickerSingler:(CommonPickerView *)pickerSingler selectedTitle:(NSString *)selectedTitle selectedRow:(NSInteger)selectedRow;

@end

@interface CommonPickerView : UIButton

/** 2.工具器 */
@property (nonatomic, strong, nullable) Toolbar *toolbar;

/** 1.设置字符串数据数组 */
@property (nonatomic, strong)NSMutableArray<NSString *> *arrayData;
/** 2.设置单位标题 */
@property (nonatomic, strong)NSString *unitTitle;
/** 3.标题 */
@property (nonatomic, strong)NSString *title;

@property(nonatomic, weak) id<CommonPickerViewDelegate> xlsn0wDelegate;

- (instancetype)initWithArrayData:(NSArray<NSString *>*)arrayData
                        unitTitle:(NSString *)unitTitle
                   xlsn0wDelegate:(nullable id<CommonPickerViewDelegate>)xlsn0wDelegate;

- (instancetype)initWithArrayData:(NSArray<NSString *>*)arrayData
                   xlsn0wDelegate:(nullable id<CommonPickerViewDelegate>)xlsn0wDelegate;


- (void)show;
@end
NS_ASSUME_NONNULL_END
