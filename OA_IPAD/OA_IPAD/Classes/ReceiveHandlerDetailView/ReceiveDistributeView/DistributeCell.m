#import "DistributeCell.h"
#import "UIColor+color.h"
#import "ReceiveFileHandleRecord.h"

@implementation DistributeCell
{
    UILabel *_name;
    UILabel *_type;
    UIView *_line;
}

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
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.textColor = NormalColor;
    _name.font = [UIFont systemFontOfSize:18];
    _name.numberOfLines = 0;
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.font = [UIFont systemFontOfSize:18];
    _type.textAlignment = NSTextAlignmentRight;
    
    _line = [UIView new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    _type.sd_layout
    .topSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, margin)
    .widthIs(100)
    .heightIs(60);

    _name.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(_type, 0)
    .heightIs(60);
    
    _line.sd_layout
    .bottomSpaceToView(contentView, 1)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:0];
}

- (void)setModel:(ReceiveFileHandleRecord *)model
{
    _model = model;
    NSString *format = [NSString stringWithFormat:@"%@（%@，%@）", model.UserName, model.BLType, model.BLSort];
    _name.text = format;
    _type.text = model.BLStatus;
    
    if([model.BLStatus isEqualToString:@"办理中"])
    {
        [_type setTextColor:[UIColor colorWithRGB:255 green:102 blue:0]];
    }
    else
    {
        [_type setTextColor:[UIColor colorWithHex:0x3D98FF]];
    }
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

@end

