#import "DetailCell.h"
#import "DetailModel.h"

@implementation DetailCell
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
    _right.textAlignment = NSTextAlignmentRight;
    _right.textColor = NormalColor;
    _right.numberOfLines = 0;
    
    _line = [UILabel new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    _left.sd_layout
    .leftSpaceToView(contentView, margin)
    .topEqualToView(contentView)
    .widthIs(130)
    .heightIs(60);
    
    _right.sd_layout
    .leftSpaceToView(_left, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(_left)
    .heightIs(60);
    
    _line.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_right bottomMargin:0];
}

- (void)setModel:(DetailModel *)model
{
    _model = model;
    _left.text = model.left;
    _right.text = model.right;
    _line.hidden = model.isHide;
}

@end

