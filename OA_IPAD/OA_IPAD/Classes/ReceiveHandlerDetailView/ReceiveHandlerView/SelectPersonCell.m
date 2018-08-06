#import "SelectPersonCell.h"
#import "UIColor+color.h"


@implementation SelectPersonCell
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
    UIView *bkg = [UIView new];
    [self.contentView addSubview:bkg];
    bkg.backgroundColor = [UIColor colorWithRGB:252 green:252 blue:252];
    
    _image = [UIImageView new];
    _image.image = [UIImage imageNamed:@"arrow-right"];
    [bkg addSubview:_image];
    
    _title = [UILabel new];
    [bkg addSubview:_title];
    _title.font = [UIFont systemFontOfSize:18];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.textColor = NormalColor;
    _title.text = @"选择人员";
    _title.numberOfLines = 0;
        
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    bkg.sd_layout
    .topEqualToView(contentView)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(50);
    
    _image.sd_layout
    .rightSpaceToView(bkg, 15)
    .centerYEqualToView(bkg)
    .widthIs(10.7)
    .heightIs(20);
    
    _title.sd_layout
    .leftSpaceToView(bkg, margin)
    .rightSpaceToView(_image, margin)
    .topEqualToView(bkg)
    .heightIs(50);
    
    [self setupAutoHeightWithBottomView:bkg bottomMargin:10];
}


@end

