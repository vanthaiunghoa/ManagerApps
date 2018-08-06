#import "DistributeOperatorCell.h"
#import "UIColor+color.h"
#import "ReceiveFileHandleRecord.h"

@implementation DistributeOperatorCell
{
    UILabel *_name;
    UIButton *_btnDelete;
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
    _btnDelete = [UIButton new];
    [self.contentView addSubview:_btnDelete];
    [_btnDelete setImage:[UIImage imageNamed:@"handler-unselected"] forState:UIControlStateNormal];
    [_btnDelete setImage:[UIImage imageNamed:@"handler-selected"] forState:UIControlStateSelected];
    
    [_btnDelete addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.textColor = NormalColor;
    _name.font = [UIFont systemFontOfSize:18];
    _name.numberOfLines = 0;
    
    _line = [UIView new];
    _line.backgroundColor = LineColor;
    [self.contentView addSubview:_line];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    _btnDelete.sd_layout
    .topSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .widthIs(60)
    .heightIs(60);
    
    _name.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(_btnDelete, 0)
    .heightIs(60);
    
    _line.sd_layout
    .bottomSpaceToView(contentView, 1)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:_line bottomMargin:0];
}

- (void)setModel:(ReceiveFileHandleRecord *)model
{
    _model = model;
    NSString *format = [NSString stringWithFormat:@"%@（%@，%@）", model.UserName, model.BLType, model.BLSort];
    _name.text = format;
    _btnDelete.selected = model.isSelect;
}

- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    _isHiddenLine = isHiddenLine;
    _line.hidden = isHiddenLine;
}

- (void)deleteClicked:(UIButton *)sender
{
    _btnDelete.selected = !_btnDelete.selected;
    _model.isSelect = !_model.isSelect;
    
    [_delegate selectedModel:_model];
}

@end

