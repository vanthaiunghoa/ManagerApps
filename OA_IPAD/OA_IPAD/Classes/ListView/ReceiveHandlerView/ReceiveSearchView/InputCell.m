//
//  InputCell.m
//  OA_IPAD
//
//  Created by wanve on 2018/7/30.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "InputCell.h"
#import "UIImage+image.h"
#import "UIColor+color.h"

@interface InputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation InputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat labW = 150;
    CGFloat x = 20;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, labW, 60)];
    [self.contentView addSubview:lab];
    [lab setFont:[UIFont systemFontOfSize:18]];
    [lab setTextColor:GrayColor];
    self.lab = lab;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x + labW, 0, SCREEN_WIDTH - 2.0*x - labW, 60)];
    [self.contentView addSubview:textField];
    textField.placeholder = @"未填写";
    [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = [UIFont systemFontOfSize:18];
    textField.textAlignment = NSTextAlignmentRight;
    self.textField = textField;
    
    [textField addTarget:self action:@selector(textFieldidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(x, 59, SCREEN_WIDTH - 2.0*x, 1)];
    [self.contentView addSubview:_line];
    [_line setBackgroundColor:LineColor];
}

-(void)textFieldidChange:(UITextField *)textField
{
    [_delegate textFieldDidChange:_key value:textField.text];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.textField.text = value;
}

- (void)setKey:(NSString *)key
{
    _key = key;
    [self.lab setText:key];
}

- (void)setIsHiddenLine:(BOOL )isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}


@end
