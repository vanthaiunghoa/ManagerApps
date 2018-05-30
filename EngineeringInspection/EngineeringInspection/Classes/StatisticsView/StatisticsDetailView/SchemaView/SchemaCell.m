#import "SchemaCell.h"
#import "SchemaModel.h"
#import "UIColor+color.h"

@implementation SchemaCell
{
    UILabel *_name;
    NSMutableArray *_numArray;
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
    CGFloat y = 10;
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - 2.0*x, 44)];
//    [_name setFont:[UIFont systemFontOfSize:14]];
    [_name setTextAlignment:NSTextAlignmentLeft];
    [_name setTextColor:[UIColor colorWithRGB:28 green:120 blue:255]];
    [self.contentView addSubview:_name];
    
    y += 44;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH - 2.0*x, 1)];
    line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:line];
    
    y += 5;
    NSArray *descriptionArray = @[@"待指派", @"待修复", @"待销项", @"已销项", @"记录"];
    CGFloat labW = SCREEN_WIDTH/5.0;
    _numArray = [NSMutableArray array];
    for(int i = 0; i < descriptionArray.count; ++i)
    {
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(x, y, labW, 30)];
        [num setFont:[UIFont systemFontOfSize:16]];
        [num setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:num];
        [_numArray addObject:num];
        
        UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(x, y + 30, labW, 30)];
        [description setFont:[UIFont systemFontOfSize:16]];
        [description setTextAlignment:NSTextAlignmentCenter];
        [description setText:descriptionArray[i]];
        [self.contentView addSubview:description];
        
        x += labW;
    }
}

- (void)setModel:(SchemaModel *)model
{
    _model = model;
    [_name setText:_model.name];

    [_numArray enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0:
                [lab setText:_model.distribute];
                break;
            case 1:
                [lab setText:_model.unrepair];
                break;
            case 2:
                [lab setText:_model.undestroy];
                break;
            case 3:
                [lab setText:_model.destroy];
                break;
            case 4:
                [lab setText:_model.record];
                break;
            default:
                break;
        }
    }];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

@end

