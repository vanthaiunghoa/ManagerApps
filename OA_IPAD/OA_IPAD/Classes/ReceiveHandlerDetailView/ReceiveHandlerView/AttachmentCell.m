#import "AttachmentCell.h"
#import "UIColor+color.h"
#import "ReceiveFileAttatchFileInfo.h"

@implementation AttachmentCell
{
    UIImageView *_image;
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
    _image = [UIImageView new];
    _image.image = [UIImage imageNamed:@"attachment"];
    [self.contentView addSubview:_image];
    
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
    
    _image.sd_layout
    .leftSpaceToView(contentView, margin)
    .centerYEqualToView(contentView)
    .widthIs(21.6)
    .heightIs(25);
    
    _title.sd_layout
    .leftSpaceToView(_image, margin)
    .rightSpaceToView(contentView, margin)
    .topEqualToView(contentView)
    .heightIs(60);
    
    _line.sd_layout
    .bottomSpaceToView(contentView, 1)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:0];
}

- (void)setModel:(ReceiveFileAttatchFileInfo *)model
{
    _model = model;
    _title.text = model.Name;
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

@end

