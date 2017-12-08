#import "AddressCell.h"

//#import "UIView+Frame.h"

@interface AddressCell ()
@property (nonatomic, weak) UIButton *startButton;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation AddressCell

//- (UIButton *)startButton
//{
//    if (_startButton == nil) {
//        // 添加立即体验
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
//        [btn sizeToFit];
//        btn.center = CGPointMake(self.width * 0.5, self.height * 0.95);
//        [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:btn];
//        _startButton = btn;
//    }
//    return _startButton;
//}

// 点击立即体验按钮调用
//- (void)start
//{
    // 跳转到主框架界面
    // 切换界面:push,modal,tarBarVC
    // 修改窗口的根控制器
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[XMGTabBarController alloc] init];
//}

//- (UIImageView *)imageView
//{
//    if (_imageView == nil) {
//        UIImageView *imageView = [[UIImageView alloc] init];
//        _imageView = imageView;
//        
//        [self.contentView addSubview:imageView];
//    }
//    
//    return _imageView;
//}

//- (void)setImage:(UIImage *)image
//{
//    _image = image;
//    
//    self.imageView.image = image;
//    self.imageView.frame = self.bounds;
//}
    
//- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
//{
//    if (indexPath.item == count - 1) { // 当前cell是最后一个cell
//        self.startButton.hidden = NO;
//    }else{ // 如果不是最后一个cell,
//        self.startButton.hidden = YES;
//    }
//    
//}

@end
