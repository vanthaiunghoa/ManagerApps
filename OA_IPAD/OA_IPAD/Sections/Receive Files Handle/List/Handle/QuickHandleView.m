//
//  QuickHandleViewController.m
//  OA_IPAD
//
//  Created by cello on 2018/5/10.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "QuickHandleView.h"

@interface QuickHandleView ()

@property (strong, nonatomic) ConfirmBlock confirmBlock;
@property (strong, nonatomic) UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation QuickHandleView

+ (instancetype)showWithConfirmBlock:(ConfirmBlock)confirmBlock fromViewController:(UIViewController *)vc {
    QuickHandleView *instance = [[NSBundle mainBundle] loadNibNamed:@"QuickHandleView" owner:nil options:nil].firstObject;
    instance.confirmBlock = confirmBlock;
    instance.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:instance];
    return instance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.text = @"已阅";
    [self layoutIfNeeded];
}

- (IBAction)confirm:(id)sender {
    self.confirmBlock(self.textView.text);
    [self mcancel:nil];
}

- (IBAction)mcancel:(id)sender {
    self.confirmBlock = nil;
    [self removeFromSuperview];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [self.container addSubview:_textView];
        _textView.frame = CGRectMake(8, 68, 434, 373);
    }
    return _textView;
}


@end
