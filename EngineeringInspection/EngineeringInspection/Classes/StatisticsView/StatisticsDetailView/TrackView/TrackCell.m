#import "TrackCell.h"
#import "TrackModel.h"
#import "UIColor+color.h"

@implementation TrackCell
{
    UILabel *_description;
    UILabel *_percent;
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
    CGFloat x = 10;
    CGFloat descriptionW = 100;
    CGFloat w = SCREEN_WIDTH - 2.0*x;
    
    _description = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, w, 44)];
//    [_name setFont:[UIFont systemFontOfSize:14]];
    [_description setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_description];
    
    _percent = [[UILabel alloc] initWithFrame:CGRectMake(x + descriptionW, 0, w - descriptionW, 44)];
    //    [_name setFont:[UIFont systemFontOfSize:14]];
    [_percent setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_percent];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 43, w, 1)];
    line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:line];
}

- (void)setModel:(TrackModel *)model
{
    _model = model;
    [_description setText:_model.des];
    [_percent setText:_model.percent];
}


@end

