#import "ListCell.h"
#import "ListModel.h"
#import "UIColor+color.h"

@implementation ListCell
{
    CellSelectedBlock cellSelectedBlock;
    
    UIButton *_select;
    UILabel *_position;
    UILabel *_content;
    UILabel *_type;
    UIImageView *_imageView;
    NSMutableArray *_imgs;
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
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"select"]];
    _imageView.layer.borderColor = [UIColor grayColor].CGColor;
    _imageView.layer.borderWidth = 1;
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
//    _type.textColor = [UIColor darkGrayColor];
    _type.font = [UIFont systemFontOfSize:16];
    _type.numberOfLines = 0;

    _select = [UIButton buttonWithType:UIButtonTypeCustom];
    [_select setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [_select setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_select setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.contentView addSubview:_select];
    _select.hidden = YES;

    [_select addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView = [UIView new];
//    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:lineView];

    _position = [UILabel new];
    [self.contentView addSubview:_position];
    //    _content.textColor = [UIColor darkGrayColor];
    _position.font = [UIFont systemFontOfSize:14];
    _position.numberOfLines = 0;

    _content = [UILabel new];
    [self.contentView addSubview:_content];
    _content.textColor = [UIColor darkGrayColor];
    _content.font = [UIFont systemFontOfSize:14];
    _content.numberOfLines = 0;

    _imgs = [[NSMutableArray alloc] init];
    for(int i = 0; i < 3; ++i)
    {
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"logo-company"];
        imageView.layer.borderColor = [UIColor grayColor].CGColor;
        imageView.layer.borderWidth = 1;
        [_imgs addObject:imageView];
    }

    UIView *marginLine = [UIView new];
    marginLine.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self.contentView addSubview:marginLine];

    CGFloat margin = 10;
    UIView *contentView = self.contentView;

    _imageView.sd_layout
    .topSpaceToView(contentView, 14)
    .leftSpaceToView(contentView, margin)
    .widthIs(16)
    .heightIs(16);

    _type.sd_layout
    .topEqualToView(contentView)
    .leftSpaceToView(_imageView, margin)
    .widthIs(200.0)
    .heightIs(44);

    _select.sd_layout
    .rightSpaceToView(contentView, margin)
    .topEqualToView(contentView)
    .widthIs(44)
    .heightIs(44);

    lineView.sd_layout
    .topSpaceToView(_select, 0)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);

    _position.sd_layout
    .topSpaceToView(lineView, 10)
    .leftSpaceToView(contentView, 30)
    .rightSpaceToView(contentView, 30)
    .autoHeightRatio(0);

    _content.sd_layout
    .topSpaceToView(_position, 10)
    .leftSpaceToView(contentView, 30)
    .rightSpaceToView(contentView, 30)
    .autoHeightRatio(0);

    CGFloat imgW = (SCREEN_WIDTH - 60 - 30)/3.0;
    CGFloat imgH = 60.0;
    
    __block UIImageView *tmp = nil;

    [_imgs enumerateObjectsUsingBlock:^(UIImageView *img, NSUInteger idx, BOOL * _Nonnull stop) {
        if(0 == idx)
        {
            img.sd_layout
            .topSpaceToView(_content, margin)
            .leftSpaceToView(contentView, 30)
            .widthIs(imgW)
            .heightIs(imgH);

            tmp = img;
        }
        else
        {
            img.sd_layout
            .topSpaceToView(_content, margin)
            .leftSpaceToView(tmp, 15)
            .widthIs(imgW)
            .heightIs(imgH);

            tmp = img;
        }
    }];
    
    marginLine.sd_layout
    .topSpaceToView(tmp, margin)
//    .topSpaceToView(_content, margin)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:marginLine bottomMargin:0];
    
    // 当你不确定哪个view在自动布局之后会排布在cell最下方的时候可以调用次方法将所有可能在最下方的view都传过去
//    [self setupAutoHeightWithBottomViewsArray:@[_titleLabel, _imageView] bottomMargin:margin];
}

- (void)setModel:(ListModel *)model
{
    _model = model;

    _content.text = model.Title;
    _type.text = model.SendDate;
    _position.text = model.WhoGiveName;
    _select.selected = model.isSelected;
    _select.hidden = model.isHidden;
    
//    _imageView.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}

- (void)setFrame:(CGRect)frame
{
    //    frame.origin.x += 10;
//    frame.origin.y += 20;
    frame.size.height -= 20;
    //    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)cellSelectedWithBlock:(CellSelectedBlock)block
{
    cellSelectedBlock = block;
}

#pragma mark - clicked

- (void)selectClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _model.isSelected = sender.selected;
//    [_delegate didSelectClicked:_model selected:sender.isSelected];
    if(cellSelectedBlock)
    {
        cellSelectedBlock(_model);
    }
}



@end

