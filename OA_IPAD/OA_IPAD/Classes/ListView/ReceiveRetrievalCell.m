#import "ReceiveRetrievalCell.h"
#import "UIColor+color.h"
#import "UIImage+image.h"

@implementation ReceiveRetrievalCell
{
    UILabel *_title;
    UILabel *_num;
    UILabel *_time;
    UILabel *_unit;
    UILabel *_type;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    _title = [UILabel new];
    [self.contentView addSubview:_title];
    _title.textColor = [UIColor colorWithRGB:62 green:62 blue:82];
    _title.font = [UIFont systemFontOfSize:22];
    _title.numberOfLines = 0;
    
    _num = [UILabel new];
    [self.contentView addSubview:_num];
    _num.font = [UIFont systemFontOfSize:18];
    _num.numberOfLines = 0;
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.font = [UIFont systemFontOfSize:18];
    _type.numberOfLines = 0;
    
    _time = [UILabel new];
    [self.contentView addSubview:_time];
    _time.font = [UIFont systemFontOfSize:18];
    _time.numberOfLines = 0;
    
    _unit = [UILabel new];
    [self.contentView addSubview:_unit];
    _unit.font = [UIFont systemFontOfSize:18];
    _unit.numberOfLines = 0;
    
    CGFloat margin = 20;
    CGFloat top_margin = 15;
    UIView *contentView = self.contentView;
    
    _title.sd_layout
    .leftSpaceToView(contentView, 20)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _num.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_title, top_margin)
    .widthIs(350.0)
    .autoHeightRatio(0);
    
    _type.sd_layout
    .leftSpaceToView(_num, margin)
    .topSpaceToView(_title, top_margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _time.sd_layout
    .topSpaceToView(_num, top_margin)
    .leftSpaceToView(contentView, margin)
    .widthIs(350.0)
    .autoHeightRatio(0);
    
    _unit.sd_layout
    .leftSpaceToView(_time, margin)
    .topEqualToView(_time)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_unit bottomMargin:margin];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.origin.x += 20;
    frame.size.width -= 40;
    frame.size.height -= 20;

    [super setFrame:frame];
}

- (void)setModel:(id<ListCellDataSource>)model
{
    _title.text = model.title;
    _num.attributedText = model.secondLabelContent;
    _type.attributedText = model.fifthLabelContent;
    _time.attributedText = model.thirdLabelContent;
    _unit.attributedText = model.fourthLabelContent;
}

@end

