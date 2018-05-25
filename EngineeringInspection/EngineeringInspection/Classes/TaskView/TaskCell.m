#import "TaskCell.h"
#import "TaskModel.h"

@implementation TaskCell
{
    UILabel *_time;
    UILabel *_name;
    UILabel *_type;
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"同步" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btn addTarget:self action:@selector(synchronizationClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btn.layer setMasksToBounds:YES];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-padding);
        make.width.equalTo(@50);
//        make.top.equalTo(self.autobtn.mas_bottom).with.offset(H(20));
    }];

    _name = [UILabel new];
    [self.contentView addSubview:_name];
    _name.font = [UIFont systemFontOfSize:16];
    [_name setText:@"万维博通大厦"];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(padding);
        make.left.equalTo(self.mas_left).offset(padding);
        make.right.equalTo(btn.mas_left);
        make.height.equalTo(@20);
    }];
    
    _type = [UILabel new];
    [self.contentView addSubview:_type];
    _type.textColor = [UIColor darkGrayColor];
    [_type setText:@"安全检查"];
    _type.font = [UIFont systemFontOfSize:14];
    [_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-padding);
        make.left.equalTo(self.mas_left).offset(padding);
        make.width.equalTo(@80);
        make.height.equalTo(@15);
    }];
    
    _time = [UILabel new];
    [self.contentView addSubview:_time];
    _time.textColor = [UIColor darkGrayColor];
    [_time setText:@"2018-05-05 11:11:11"];
    _time.font = [UIFont systemFontOfSize:14];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_type);
        make.left.equalTo(_type.mas_right);
        make.right.equalTo(btn.mas_left);
    }];
}

- (void)setModel:(TaskModel *)model
{
    _model = model;

    _time.text = model.time;
    _name.text = model.name;
//    _type.text = model.HJ;
    
//    _imageView.image = [UIImage imageNamed:model.imagePathsArray.firstObject];
}

- (void)setFrame:(CGRect)frame
{
//    frame.origin.x += 10;
    frame.origin.y += 20;
    frame.size.height -= 20;
//    frame.size.width -= 20;
    [super setFrame:frame];
}

#pragma mark - clicked

- (void)synchronizationClicked:(UIButton *)sender
{
    PLog(@"1111");
}

@end

