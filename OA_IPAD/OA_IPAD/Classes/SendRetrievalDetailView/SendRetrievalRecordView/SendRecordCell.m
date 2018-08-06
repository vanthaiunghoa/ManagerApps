#import "SendRecordCell.h"
#import "UIColor+color.h"
#import "SendFileRecord.h"

@implementation SendRecordCell
{
    UILabel *_name;
    UILabel *_advice;
    UILabel *_type;
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
    
    _advice = [UILabel new];
    [self.contentView addSubview:_advice];
    _advice.font = [UIFont systemFontOfSize:18];
    _advice.textColor = NormalColor;
    _advice.numberOfLines = 0;
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.font = [UIFont systemFontOfSize:18];
    _type.textAlignment = NSTextAlignmentRight;
    _type.textColor = GrayColor;
    
    UIView *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    
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
    .topSpaceToView(_type, textMargin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    line.sd_layout
    .topEqualToView(contentView)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_advice bottomMargin:textMargin];
}

- (void)setModel:(SendFileRecord *)model
{
    _model = model;
    _name.text = model.JBR;
    _advice.text = model.YiJian;
    _type.text = model.BLType;
}


@end

