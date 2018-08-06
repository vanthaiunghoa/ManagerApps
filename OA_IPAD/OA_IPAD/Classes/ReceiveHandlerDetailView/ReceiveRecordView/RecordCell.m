#import "RecordCell.h"
#import "UIColor+color.h"
#import "ReceiveFileHandleRecord.h"

@implementation RecordCell
{
    UILabel *_name;
    UILabel *_advice;
    UILabel *_time;
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
    _type.textColor = [UIColor colorWithRGB:241 green:86 blue:84];
    
    _advice = [UILabel new];
    [self.contentView addSubview:_advice];
    _advice.font = [UIFont systemFontOfSize:18];
    _advice.textColor = NormalColor;
    _advice.numberOfLines = 0;
    
    _time = [UILabel new];
    [self.contentView addSubview:_time];
    _time.font = [UIFont systemFontOfSize:18];
    _time.textAlignment = NSTextAlignmentRight;
    _time.textColor = GrayColor;
    _time.numberOfLines = 0;
    
    _line = [UIView new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat margin = 20;
    CGFloat textMargin = 15;
    UIView *contentView = self.contentView;
    
    _name.sd_layout
    .topSpaceToView(contentView, textMargin)
    .leftSpaceToView(contentView, margin)
    .widthIs(200)
    .autoHeightRatio(0);
    
    _type.sd_layout
    .topSpaceToView(contentView, textMargin)
    .leftSpaceToView(_name, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _advice.sd_layout
    .topSpaceToView(_name, textMargin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _time.sd_layout
    .topSpaceToView(_advice, textMargin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _line.sd_layout
    .topSpaceToView(_time, textMargin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:0];
}

- (void)setModel:(ReceiveFileHandleRecord *)model
{
    _model = model;
    _name.text = model.UserName;
    _type.text = model.BLStatus;
    _advice.text = model.Yijian;
    _time.text = model.BLDate;
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

@end

