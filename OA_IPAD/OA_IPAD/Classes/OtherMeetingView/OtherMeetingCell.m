#import "OtherMeetingCell.h"

@implementation OtherMeetingCell
{
    UILabel *_title;
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
    _title = [UILabel new];
    [self.contentView addSubview:_title];
    _title.font = [UIFont systemFontOfSize:18];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.textColor = NormalColor;
    _title.numberOfLines = 0;
    
    _line = [UIView new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    _title.sd_layout
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(contentView)
    .heightIs(60);
    
    _line.sd_layout
    .bottomSpaceToView(contentView, 1)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_title bottomMargin:0];
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

