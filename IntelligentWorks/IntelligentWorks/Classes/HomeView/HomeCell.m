#import "HomeCell.h"

@implementation HomeCell
{
    UIImageView *_imageView;
    UILabel *_title;
    UIView *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = ViewColor;
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"map-off"];
    
    _title = [UILabel new];
    [self.contentView addSubview:_title];
    _title.font = [UIFont systemFontOfSize:18];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.textColor = NormalColor;
    _title.numberOfLines = 0;
    
    _line = [UIView new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat padding = 10;
    UIView *contentView = self.contentView;
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(padding);
        make.top.equalTo(contentView.mas_top).offset(padding);
        make.bottom.equalTo(contentView.mas_bottom).offset(-padding);
        make.width.equalTo(@60);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.mas_right).offset(padding);
        make.right.equalTo(contentView.mas_right).offset(-padding);
        make.top.equalTo(contentView.mas_top).offset(padding);
        make.bottom.equalTo(contentView.mas_bottom).offset(-padding);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_bottom).offset(-1);
        make.height.equalTo(@1);
    }];
}

- (void)setFlowName:(NSString *)flowName
{
    _flowName = flowName;
    _title.text = flowName;
}

- (void)setIsHiddenLine:(BOOL )isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

@end

