#import "SendHandlerCell.h"
#import "UIColor+color.h"
#import "UIImage+image.h"

@implementation SendHandlerCell
{
    UILabel *_title;
    UILabel *_beginTime;
    UILabel *_endTime;
    UILabel *_name;
    UILabel *_status;
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
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.font = [UIFont systemFontOfSize:18];
    _name.numberOfLines = 0;
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.font = [UIFont systemFontOfSize:18];
    _type.numberOfLines = 0;

    _beginTime = [UILabel new];
    [self.contentView addSubview:_beginTime];
    _beginTime.font = [UIFont systemFontOfSize:18];
    _beginTime.numberOfLines = 0;
    
    _endTime = [UILabel new];
    [self.contentView addSubview:_endTime];
    _endTime.font = [UIFont systemFontOfSize:18];
    _endTime.numberOfLines = 0;

    _status = [UILabel new];
    [self.contentView addSubview:_status];
    [_status setTextAlignment:NSTextAlignmentCenter];
    _status.layer.cornerRadius = 10;
    _status.layer.backgroundColor = ViewColor.CGColor;
    _status.textColor = [UIColor colorWithRGB:85 green:85 blue:85];
    _status.font = [UIFont systemFontOfSize:18];
    _status.numberOfLines = 0;
    
    UIButton *btnHandler = [UIButton new];
    [self.contentView addSubview:btnHandler];
    [btnHandler setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:241 green:85 blue:83]] forState:UIControlStateNormal];
    [btnHandler setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHandler setTitle:@"呈批表" forState:UIControlStateNormal];
    [btnHandler.layer setCornerRadius:10];
    [btnHandler.layer setMasksToBounds:YES];
    [btnHandler addTarget:self action:@selector(approvalClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat margin = 20;
    CGFloat top_margin = 15;
    UIView *contentView = self.contentView;
    
    _title.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _name.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_title, top_margin)
    .widthIs(350.0)
    .autoHeightRatio(0);
    
    _type.sd_layout
    .leftSpaceToView(_name, margin)
    .topEqualToView(_name)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _beginTime.sd_layout
    .topSpaceToView(_name, top_margin)
    .leftSpaceToView(contentView, margin)
    .widthIs(350.0)
    .autoHeightRatio(0);
    
    _endTime.sd_layout
    .leftSpaceToView(_beginTime, margin)
    .topEqualToView(_beginTime)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _status.sd_layout
    .topSpaceToView(_beginTime, top_margin)
    .leftSpaceToView(contentView, margin)
    .widthIs(80)
    .heightIs(44);
    
    btnHandler.sd_layout
    .topEqualToView(_status)
    .rightSpaceToView(contentView, margin)
    .widthIs(80)
    .heightIs(44);
    
    [self setupAutoHeightWithBottomView:btnHandler bottomMargin:margin];
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
//    [self setupAutoHeightWithBottomViewsArray:@[_title, _imageView] bottomMargin:margin];
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
    _name.attributedText = model.secondLabelContent;
    _type.attributedText = model.fifthLabelContent;
    _beginTime.attributedText = model.thirdLabelContent;
    _endTime.attributedText = model.fourthLabelContent;
    _status.text = model.status;
}

#pragma mark - clicked

- (void)approvalClicked:(UIButton *)sender
{
    [_delegate approval:_indexPath];
    
    PLog(@"选中的行号indexPath == %ld", _indexPath.row);
}


@end

