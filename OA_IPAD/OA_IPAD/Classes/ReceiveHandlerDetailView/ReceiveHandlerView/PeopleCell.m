#import "PeopleCell.h"
#import "UIColor+color.h"
#import "DetailModel.h"

@implementation PeopleCell
{
    UILabel *_left;
    UILabel *_right;
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
    _left = [UILabel new];
    [self.contentView addSubview:_left];
    _left.textColor = GrayColor;
    _left.textAlignment = NSTextAlignmentLeft;
    _left.font = [UIFont systemFontOfSize:18];
    _left.numberOfLines = 0;
    
    _right = [UILabel new];
    [self.contentView addSubview:_right];
    _right.font = [UIFont systemFontOfSize:18];
    _right.textAlignment = NSTextAlignmentLeft;
    _right.textColor = NormalColor;
    _right.numberOfLines = 0;
    
    _line = [UIView new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat margin = 20;
    CGFloat top_margin = 15;
    UIView *contentView = self.contentView;
    
    _left.sd_layout
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(contentView, top_margin)
    .autoHeightRatio(0);
    
    _right.sd_layout
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .topSpaceToView(_left, top_margin)
    .autoHeightRatio(0);
    
    _line.sd_layout
    .topSpaceToView(_right, top_margin)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:0];
}

- (void)setModel:(DetailModel *)model
{
    _model = model;
    _left.text = model.left;
    _right.text = model.right;
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

@end

