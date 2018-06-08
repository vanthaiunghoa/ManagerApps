#import "IssueCell.h"

@implementation IssueCell
{
    UILabel *_name;
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

    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"statistics-arrow-right"];
    arrow.userInteractionEnabled = NO;
    [self.contentView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(13);
        make.right.equalTo(self.mas_right).offset(-padding);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.font = [UIFont systemFontOfSize:16];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_left).offset(2*padding);
        make.right.equalTo(arrow.mas_left);
    }];
    
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    line.backgroundColor = [UIColor darkGrayColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left).offset(2*padding);
        make.right.equalTo(self.mas_right).offset(-padding);
    }];
}

- (void)setProjectName:(NSString *)projectName
{
    _projectName = projectName;

    _name.text = _projectName;
}


@end

