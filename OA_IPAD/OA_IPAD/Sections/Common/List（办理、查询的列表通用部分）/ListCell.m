//
//  ListCell.m
//  OA_IPAD
//
//  Created by cello on 2018/3/25.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ListCell.h"
#import "UIColor+Scheme.h"
#import "UIImage+EasyExtend.h"

@interface ListCell()
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UILabel *titleLabel = self.titleButton.titleLabel;
    titleLabel.numberOfLines = 2;
//    titleLabel.adjustsFontSizeToFitWidth = YES;
//    titleLabel.minimumScaleFactor = 0.8;
    self.selectedBackgroundView = [UIView new]; //透明的选择效果
    
    [_container.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _container.bounds.size.width, _container.bounds.size.height) cornerRadius:10.0].CGPath];
    _container.layer.borderColor = [UIColor schemeBlue].CGColor;
    _container.layer.shadowColor = [UIColor colorWithWhite:0.86 alpha:1.0].CGColor;
    _container.layer.shadowOffset = CGSizeMake(3, 0);
    _container.layer.shadowRadius = 5;
    _container.layer.masksToBounds = NO;
    _container.clipsToBounds = NO;
    
    _container.layer.shadowOpacity = 0.8;
//    [self.handleButton setBackgroundImage:[UIImage imageWithColor:[UIColor redText]] forState:0];
//    [self.handleButton setBackgroundImage:[UIImage imageWithColor:[UIColor schemeBlue]] forState:UIControlStateHighlighted];
//    [self.handleButton setBackgroundImage:[UIImage imageWithColor:[UIColor schemeBlue]] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _container.layer.borderWidth = 1.0f;
        _container.layer.shadowOpacity = 0;
    } else {
        _container.layer.borderWidth = 0.0f;
        _container.layer.shadowOpacity = 0.8;
    }

    // Configure the view for the selected state
}
- (IBAction)_touchHandleButton:(id)sender {
    [self.delegate handleButton:sender touchedAtIndexPath:self.indexPath];
}
- (IBAction)_touchTitle:(id)sender {
    [self.delegate handleTitleButton:sender touchedAtIndexPath:self.indexPath];
}

- (void)setDataSource:(id<ListCellDataSource>)dataSource {
    [self.titleButton setTitle:dataSource.title forState:0];
    self.codeLabel.text = dataSource.code;
    self.secondLabel.attributedText = dataSource.secondLabelContent;
    self.thirdLabel.attributedText = dataSource.thirdLabelContent;
    self.fourthLabel.attributedText = dataSource.fourthLabelContent;
    self.fifithLabel.attributedText = dataSource.fifthLabelContent;
    self.handleButton.hidden = !dataSource.shouldShowHandleButton;
    self.statusLabel.text = dataSource.status;
}

@end
