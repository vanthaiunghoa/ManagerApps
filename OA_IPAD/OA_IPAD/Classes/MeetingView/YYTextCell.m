#import "YYTextCell.h"
#import "UIColor+color.h"

@implementation YYTextCell

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
    _labTitle = [UILabel new];
    [self.contentView addSubview:_labTitle];
    _labTitle.font = [UIFont systemFontOfSize:18];
    [_labTitle setTextColor:[UIColor colorWithRGB:153 green:153 blue:153]];

    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.equalTo(@20);
    }];
    
    _label = [[YYLabel alloc] init];
    [self.contentView addSubview:_label];
    _label.font = [UIFont systemFontOfSize:18];
    _label.numberOfLines = 0;
    _label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40;
    _label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _label.numberOfLines = 0;
    [_label sizeToFit];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.labTitle.mas_bottom).offset(10);
         make.left.equalTo(self.contentView.mas_left).offset(20);
         make.right.equalTo(self.contentView.mas_right).offset(-20);
         make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
     }];
}

@end

