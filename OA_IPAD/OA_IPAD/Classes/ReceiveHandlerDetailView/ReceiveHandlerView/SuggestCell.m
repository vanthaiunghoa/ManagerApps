#import "SuggestCell.h"
#import "UIColor+color.h"
#import "UIImage+image.h"

@implementation SuggestCell
{
    UITextView *_textView;
    UIButton *_btnWord;
    UIButton *_btnDoing;
    UIButton *_btnDone;
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
    _textView = [UITextView new];
    [self.contentView addSubview:_textView];
    _textView.backgroundColor = [UIColor colorWithRGB:252 green:252 blue:252];
    [_textView setFont:[UIFont systemFontOfSize:18]];
    
    _btnWord = [UIButton new];
    [self.contentView addSubview:_btnWord];
    [_btnWord setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:245 green:245 blue:245]] forState:UIControlStateNormal];
    //    [_btnWord setBackgroundColor:[UIColor colorWithRGB:241 green:85 blue:83]];
    [_btnWord setTitleColor:[UIColor colorWithRGB:51 green:51 blue:51] forState:UIControlStateNormal];
    [_btnWord setTitle:@"常用短语" forState:UIControlStateNormal];
    [_btnWord.layer setCornerRadius:10];
    [_btnWord.layer setMasksToBounds:YES];
    [_btnWord addTarget:self action:@selector(usualClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnDoing = [UIButton new];
    [self.contentView addSubview:_btnDoing];
    [_btnDoing setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnDoing setImage:[UIImage imageNamed:@"handler-unselected"] forState:UIControlStateNormal];
    [_btnDoing setImage:[UIImage imageNamed:@"handler-selected"] forState:UIControlStateSelected];
    [_btnDoing setTitle:@"办理中" forState:UIControlStateNormal];
    _btnDoing.tag = 0;
    _btnDoing.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    
    [_btnDoing addTarget:self action:@selector(handlerClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnDone = [UIButton new];
    [self.contentView addSubview:_btnDone];
    [_btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnDone setImage:[UIImage imageNamed:@"handler-unselected"] forState:UIControlStateNormal];
    [_btnDone setImage:[UIImage imageNamed:@"handler-selected"] forState:UIControlStateSelected];
    [_btnDone setTitle:@"办完" forState:UIControlStateNormal];
    _btnDone.tag = 1;
    _btnDone.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);

    [_btnDone addTarget:self action:@selector(handlerClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat margin = 20;
    UIView *contentView = self.contentView;
    
    _textView.sd_layout
    .topEqualToView(contentView)
    .leftSpaceToView(contentView, margin)
    .rightSpaceToView(contentView, margin)
    .heightIs(170);
    
    _btnWord.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(_textView, margin)
    .widthIs(80)
    .heightIs(40);
    
    _btnDone.sd_layout
    .rightSpaceToView(contentView, margin)
    .topEqualToView(_btnWord)
    .widthIs(80)
    .heightIs(40);
    
    _btnDoing.sd_layout
    .rightSpaceToView(_btnDone, margin)
    .topEqualToView(_btnWord)
    .widthIs(100)
    .heightIs(40);

    [self setupAutoHeightWithBottomView:_btnWord bottomMargin:margin];
}

- (void)setText:(NSString *)text
{
    _textView.text = text;
}

- (NSString *)getText
{
    return _textView.text;
}

- (void)setIsDone:(BOOL)isDone
{
    _btnDone.selected = isDone;
    _btnDoing.selected = !isDone;
}

#pragma mark - clicked

- (void)handlerClicked:(UIButton *)sender
{
    sender.selected = YES;
    if(sender.tag == 0)
    {
        _btnDone.selected = NO;
        [_delegate handlerStatus:NO];
    }
    else
    {
        _btnDoing.selected = NO;
        [_delegate handlerStatus:YES];
    }
}

- (void)usualClicked:(UIButton *)sender
{
    [_delegate didClickedUsual];
}

@end

