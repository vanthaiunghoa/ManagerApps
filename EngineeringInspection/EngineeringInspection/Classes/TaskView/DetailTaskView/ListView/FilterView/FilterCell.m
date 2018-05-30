#import "FilterCell.h"
#import "ListModel.h"
#import "UIColor+color.h"

@implementation FilterCell
{
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
    self.backgroundColor = [UIColor whiteColor];
    CGFloat margin = 15;
    CGFloat btnW = (FilterViewWidth - 2.0*margin - 20)/3.0;
    CGFloat btnH = 40;
    CGFloat x = 10;
//    NSArray *arr = [[NSArray alloc]initWithObjects:@"重置", @"确定", @"重置", nil];
    
    for(int i = 0; i < 3; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, 10, btnW, btnH)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
        [btn.layer setCornerRadius:25];
//        btn.tag = i;
        [self.contentView addSubview:btn];
        [self.btnArray addObject:btn];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        x += btnW + margin;
    }
}

- (void)setDetailArray:(NSArray *)detailArray
{
    _detailArray = detailArray;

    for(int i = 0; i < _detailArray.count; ++i)
    {
        [self.btnArray[i] setTitle:_detailArray[i] forState:UIControlStateNormal];
    }
}

#pragma mark - clicked

- (void)btnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.isSelected)
    {
        [sender setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
    }
    else
    {
        [sender setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
    }
}

#pragma mark - lazy load

- (NSMutableArray *)btnArray
{
    if(_btnArray == nil)
    {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSArray *)_detailArray
{
    if(_detailArray == nil)
    {
        _detailArray = [NSArray array];
    }
    return _detailArray;
}

@end

