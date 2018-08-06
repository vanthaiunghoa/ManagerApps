#import "MeetingCell.h"

@implementation MeetingCell
{
    UIImageView *_image;
    UILabel *_title;
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
    _image = [UIImageView new];
    _image.image = [UIImage imageNamed:@"meeting"];
    [self.contentView addSubview:_image];
    
    _title = [UILabel new];
    [self.contentView addSubview:_title];
    _title.font = [UIFont systemFontOfSize:18];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.textColor = NormalColor;
    _title.numberOfLines = 0;
    
    UIView *line = [UIView new];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    _image.sd_layout
    .leftSpaceToView(contentView, margin)
    .centerYEqualToView(contentView)
    .widthIs(22.4)
    .heightIs(25);
    
    _title.sd_layout
    .leftSpaceToView(_image, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(contentView)
    .heightIs(60);
    
    line.sd_layout
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

@end

