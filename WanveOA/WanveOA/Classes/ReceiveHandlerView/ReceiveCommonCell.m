#import "ReceiveCommonCell.h"
#import "ReceiveCommonModel.h"

@implementation ReceiveCommonCell
{
    UILabel *_titleLabel;
    UILabel *_content;
    UILabel *_time;
    UILabel *_name;
    UILabel *_right;
    UILabel *_status;
    UILabel *_type;
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
//    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 0;
    
    _content = [UILabel new];
    [self.contentView addSubview:_content];
//    _content.textColor = [UIColor darkGrayColor];
    _content.font = [UIFont systemFontOfSize:16];
    _content.numberOfLines = 0;
    
    _time = [UILabel new];
    [self.contentView addSubview:_time];
    _time.textColor = [UIColor darkGrayColor];
    _time.font = [UIFont systemFontOfSize:14];
    _time.numberOfLines = 0;
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.textColor = [UIColor darkGrayColor];
    _name.font = [UIFont systemFontOfSize:14];
    _name.numberOfLines = 0;
    
    _right = [UILabel new];
    [self.contentView addSubview:_right];
    _right.textColor = [UIColor darkGrayColor];
    _right.textAlignment = NSTextAlignmentRight;
    _right.font = [UIFont systemFontOfSize:14];
    _right.numberOfLines = 0;
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.textColor = [UIColor darkGrayColor];
    _type.font = [UIFont systemFontOfSize:14];
    _type.numberOfLines = 0;
    
    _status = [UILabel new];
    [self.contentView addSubview:_status];
    _status.textColor = [UIColor greenColor];
    _status.font = [UIFont systemFontOfSize:14];
    _status.numberOfLines = 0;
    
//    _imageView = [UIImageView new];
//    [self.contentView addSubview:_imageView];
//    _imageView.layer.borderColor = [UIColor grayColor].CGColor;
//    _imageView.layer.borderWidth = 1;

    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    CGFloat margin = 15;
    CGFloat top_margin = 5;
    CGFloat right_margin = 30;
    UIView *contentView = self.contentView;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _content.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_titleLabel, top_margin)
    .rightSpaceToView(contentView, right_margin)
    .autoHeightRatio(0);
    
    _time.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_content, top_margin)
    .widthIs(160.0)
    .autoHeightRatio(0);
    
    _name.sd_layout
    .leftSpaceToView(_time, 10)
    .topSpaceToView(_content, top_margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _type.sd_layout
    .topSpaceToView(_time, top_margin)
    .rightSpaceToView(contentView, right_margin)
    .widthIs(40.0)
    .autoHeightRatio(0);
    
    _right.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_time, top_margin)
    .rightSpaceToView(_type, margin)
    .autoHeightRatio(0);
    
    _status.sd_layout
    .topSpaceToView(contentView, 25)
    .rightSpaceToView(contentView, margin)
    .widthIs(15)
    .autoHeightRatio(0);
    
//    _imageView.sd_layout
//    .topEqualToView(_titleLabel)
//    .leftSpaceToView(_titleLabel, margin)
//    .rightSpaceToView(contentView, margin)
//    .heightIs(60);
    
    lineView.sd_layout
    .topSpaceToView(_type, margin)
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,0)
    .heightIs(0.5f);
    
    [self setupAutoHeightWithBottomView:lineView bottomMargin:0];
    
    self.rightUtilityButtons = [self rightButtons];

    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
//    [self setupAutoHeightWithBottomViewsArray:@[_titleLabel, _imageView] bottomMargin:margin];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)setModel:(ReceiveCommonModel *)model
{
    _model = model;

    _titleLabel.text = model.LWDW;
    _content.text = model.Title;
    _time.text = model.SendDate;
    _name.text = model.WhoGiveName;
    _right.text = model.BLSort;
    _type.text = model.HJ;
    _status.text = model.BLStatus;
    
//    _imageView.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}

@end

