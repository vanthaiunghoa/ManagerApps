#import "SendCommonCell.h"
#import "SendCommonModel.h"

@implementation SendCommonCell
{
    UILabel *_titleLabel;
    UILabel *_name;
    UILabel *_status;
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
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 0;
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.textColor = [UIColor darkGrayColor];
    _name.font = [UIFont systemFontOfSize:14];
    _name.textAlignment = NSTextAlignmentRight;
    _name.numberOfLines = 0;
    
    _status = [UILabel new];
    [self.contentView addSubview:_status];
    _status.textColor = [UIColor redColor];
    _status.font = [UIFont systemFontOfSize:14];
    _status.numberOfLines = 0;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:lineView];
    
    CGFloat margin = 15;
    CGFloat top_margin = 5;
    CGFloat right_margin = 40;
    UIView *contentView = self.contentView;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, right_margin)
    .autoHeightRatio(0);
    
    _name.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_titleLabel, top_margin)
    .rightSpaceToView(contentView, right_margin)
    .autoHeightRatio(0);
    
    _status.sd_layout
    .topSpaceToView(contentView, 8)
    .rightSpaceToView(contentView, margin)
    .widthIs(15)
    .autoHeightRatio(0);
    
    lineView.sd_layout
    .topSpaceToView(_name, margin)
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
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor blueColor] title:@"收藏"];
    return rightUtilityButtons;
}

- (void)setModel:(SendCommonModel *)model
{
    _model = model;

    _titleLabel.text = model.BT;
    _name.text = model.WhoGiveName;
    NSString *iFok = [NSString stringWithFormat:@"%@", model.IFok];
    if([iFok isEqualToString:@"0"])
    {
        _status.text = @"待办";
    }
    else if([iFok isEqualToString:@"1"])
    {
        _status.text = @"办完";
    }
    else if([iFok isEqualToString:@"2"])
    {
        _status.text = @"办理中";
    }
    
//    _imageView.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}

@end

