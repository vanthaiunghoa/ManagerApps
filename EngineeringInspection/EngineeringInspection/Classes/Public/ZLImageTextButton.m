//
//  ZLImageTextButton.m
//  ZLImageTextButton
//
//  Created by zhaoliang chen on 2017/11/3.
//  Copyright © 2017年 zhaoliang chen. All rights reserved.
//

#import "ZLImageTextButton.h"

@interface ZLImageTextButton()

@property(nonatomic,strong)UIImageView* zlImageView;
@property(nonatomic,strong)UILabel* zlTextLabel;        

@end

@implementation ZLImageTextButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.zlButtonType = ZLImageLeftTextRight;
        [self addSubview:self.zlImageView];
        [self addSubview:self.zlTextLabel];
        self.imageView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.zlImageSize = CGSizeZero;
    }
    return self;
}

- (void)setZlButtonType:(ZLButtonType)zlButtonType {
    _zlButtonType = zlButtonType;
    if (_zlButtonType == ZLImageTopTextBottom
        ||_zlButtonType == ZLImageBottomTextTop) {
        self.zlTextLabel.textAlignment = NSTextAlignmentCenter;
    } else if (_zlButtonType == ZLImageRightTextLeft) {
        self.zlTextLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        self.zlTextLabel.textAlignment = NSTextAlignmentRight;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnWidth = self.frame.size.width;
    CGFloat btnHeight = self.frame.size.height;
    CGFloat labelHeight = [self.zlTextLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.zlTextLabel.font, NSFontAttributeName,nil]].height;
    CGFloat labelWidth = [self.zlTextLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.zlTextLabel.font, NSFontAttributeName,nil]].width;
    if (self.zlButtonType == ZLImageTopTextBottom)
    {
        if (CGSizeEqualToSize(self.zlImageSize, CGSizeZero))
        {
            self.zlImageView.frame = CGRectMake((btnWidth-ImageWidth)/2, 0, ImageWidth, ImageWidth);
            self.zlTextLabel.frame = CGRectMake(0, ImageWidth+ImageTextDistance, btnWidth, (labelHeight+4));
        }
        else
        {
            self.zlImageView.frame = CGRectMake((btnWidth-ImageWidth)/2, 0, ImageWidth, ImageHeight);
            self.zlTextLabel.frame = CGRectMake(0, ImageWidth+ImageTextDistance, btnWidth, (labelHeight+4));
        }
    } else if (self.zlButtonType == ZLImageBottomTextTop)
    {
        self.zlTextLabel.textAlignment = NSTextAlignmentCenter;
        if (CGSizeEqualToSize(self.zlImageSize, CGSizeZero))
        {
            self.zlImageView.frame = CGRectMake((btnWidth-ImageWidth)/2, (labelHeight+4)+ImageTextDistance, ImageWidth, ImageWidth);
            self.zlTextLabel.frame = CGRectMake(0, 0, btnWidth, (labelHeight+4));
        }
        else
        {
            self.zlImageView.frame = CGRectMake((btnWidth-ImageWidth)/2, (labelHeight+4)+ImageTextDistance, ImageWidth, ImageHeight);
            self.zlTextLabel.frame = CGRectMake(0, 0, btnWidth, (labelHeight+4));
        }
    }
    else if (self.zlButtonType == ZLImageRightTextLeft)
    {
        self.zlTextLabel.frame = CGRectMake(0, 0, btnWidth - ImageWidth, btnHeight);
        self.zlImageView.frame = CGRectMake(btnWidth-ImageWidth, (btnHeight-ImageHeight)/2, ImageWidth, ImageHeight);
    } else
    {
        if (CGSizeEqualToSize(self.zlImageSize, CGSizeZero))
        {
            if (btnWidth-labelWidth-ImageTextDistance < 0)
            {
                labelWidth = btnWidth*2/3;
            }
            self.zlImageView.frame = CGRectMake(0, (btnHeight-ImageHeight)/2, ImageHeight, ImageHeight);
            self.zlTextLabel.frame = CGRectMake(btnWidth-labelWidth, (btnHeight-labelHeight)/2, labelWidth, labelHeight);
        } else
        {
            if (btnWidth-labelWidth-ImageTextDistance < 0)
            {
                labelWidth = btnWidth*2/3;
            }
            self.zlImageView.frame = CGRectMake(0, (btnHeight-ImageHeight)/2, ImageWidth, ImageHeight);
            self.zlTextLabel.frame = CGRectMake(ImageWidth+ImageTextDistance, (btnHeight-labelHeight)/2, (btnWidth-ImageWidth)>labelWidth?(btnWidth-ImageWidth):labelWidth, labelHeight);
        }
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    self.zlImageView.image = image;
    self.imageView.image = image;
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    self.zlTextLabel.text = title;
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.zlTextLabel.textColor = color;
    self.titleLabel.textColor = color;
    [self setNeedsLayout];
}

- (UIImageView*)zlImageView {
    if (!_zlImageView) {
        _zlImageView = [[UIImageView alloc]init];
        _zlImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zlImageView;
}

- (UILabel*)zlTextLabel {
    if (!_zlTextLabel) {
        _zlTextLabel = [[UILabel alloc]init];
        _zlTextLabel.font = [UIFont systemFontOfSize:ZLFontSize];
        _zlTextLabel.textColor = [UIColor blackColor];
        _zlTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _zlTextLabel;
}

@end
