#import "InspectionItemCell.h"
#import "InspectionItemModel.h"

@implementation InspectionItemCell
{
    UILabel *_type;
    UILabel *_num;
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
    int padding = 15;
    
    _num = [UILabel new];
    [_num setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_num];
    _num.font = [UIFont systemFontOfSize:16];
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(@40);
        make.right.equalTo(self.mas_right).offset(-padding);
    }];
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.font = [UIFont systemFontOfSize:16];
    [_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(padding);
        make.right.equalTo(_num.mas_left);
    }];
    
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    line.backgroundColor = [UIColor darkGrayColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(padding);
        make.right.equalTo(self.mas_right).offset(-padding);
        make.height.equalTo(@1);
    }];
}

- (void)setModel:(InspectionItemModel *)model
{
    _model = model;

    _type.text = _model.type;
    _num.text = _model.num;
}


@end

