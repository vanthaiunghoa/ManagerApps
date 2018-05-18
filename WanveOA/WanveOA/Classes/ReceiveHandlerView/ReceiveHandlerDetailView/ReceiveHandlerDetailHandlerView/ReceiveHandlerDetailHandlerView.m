//
//  ReceiveHandlerDetailHandlerView.m
//  WanveOA
//
//  Created by wanve on 2018/3/2.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "ReceiveHandlerDetailHandlerView.h"
#import "UIColor+color.h"
#import "NSString+extend.h"
#import "ReceiveCommonModel.h"
#import "UserManager.h"

#define MARGIN 10


@interface ReceiveHandlerDetailHandlerView ()

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIView *verticalContainerView;
@property (strong, nonatomic) UILabel *fileDistribute;
@property (strong, nonatomic) UIView *fileDistributeView;
@property (strong, nonatomic) NSMutableArray<UILabel *> *rights;
@property (strong, nonatomic) NSMutableArray<UIView *> *lines;

@end

@implementation ReceiveHandlerDetailHandlerView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIScrollView *scrollView = UIScrollView.new;
    self.scrollView = scrollView;
    self.scrollView.backgroundColor = [UIColor colorWithRGB:245.0 green:245.0 blue:245.0];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    UIView *verticalContainerView = [[UIView alloc] init];
    self.verticalContainerView = verticalContainerView;
    [scrollView addSubview:verticalContainerView];
    [verticalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    CGFloat margin = 10;
    CGFloat tag_width = 100;
    ReceiveCommonModel *model = [[UserManager sharedUserManager] getReceiveCommonModel];
    CGFloat content_width = SCREEN_WIDTH - 4*margin - tag_width;
    CGFloat unit_height = [NSString calculateRowHeight:content_width string:model.LWDW fontSize:NORMAL_SIZE];
    if(unit_height < 44)
    {
        unit_height = 44;
    }
    CGFloat title_height = [NSString calculateRowHeight:content_width string:model.Title fontSize:NORMAL_SIZE];
    if(title_height < 44)
    {
        title_height = 44;
    }
    CGFloat bkg_height = unit_height + title_height + 5*44;
    
    UIView *bkg = [UIView new];
    [verticalContainerView addSubview:bkg];
    bkg.backgroundColor = [UIColor whiteColor];
    bkg.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    bkg.layer.borderWidth = 1;
    bkg.layer.cornerRadius = 5;
    [bkg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verticalContainerView.mas_top).offset(margin);
        make.left.equalTo(verticalContainerView.mas_left).offset(margin);
        make.right.equalTo(verticalContainerView.mas_right).offset(-margin);
        make.width.equalTo(@(SCREEN_WIDTH - 2*margin));
        make.height.equalTo(@(bkg_height));
    }];
    
    UILabel *last = nil;
    for(int i = 0; i < 7; ++i)
    {
        UILabel *tag = [UILabel new];
        [bkg addSubview:tag];
        tag.textColor = [UIColor darkGrayColor];
        tag.textAlignment = NSTextAlignmentLeft;
        tag.font = [UIFont systemFontOfSize:NORMAL_SIZE];
        
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
//            if(0 == i)
//            {
//                make.top.equalTo(bkg.mas_top);
//            }
//            else
//            {
//                make.top.equalTo(last.mas_bottom);
//            }
            make.top.equalTo(last ? last.mas_bottom : bkg.mas_top);
            make.left.equalTo(bkg.mas_left).offset(margin);
            make.width.equalTo(@(tag_width));
            if(1 == i)
            {
                make.height.equalTo(@(unit_height));
            }
            else if(2 == i)
            {
                make.height.equalTo(@(title_height));
            }
            else
            {
                make.height.equalTo(@(44));
            }
        }];
        
        last = tag;
        
        UILabel *content = [UILabel new];
        [bkg addSubview:content];
        content.textAlignment = NSTextAlignmentRight;
        content.font = [UIFont systemFontOfSize:NORMAL_SIZE];
        content.numberOfLines = 0;
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(last.mas_top);
            make.right.equalTo(bkg.mas_right).offset(-margin);
            make.width.equalTo(@(content_width));
            make.height.equalTo(last.mas_height);
        }];
        
        if(i < 6)
        {
            UIView *line = [UIView new];
            [bkg addSubview:line];
            line.backgroundColor = [UIColor darkGrayColor];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(last.mas_bottom);
                make.left.equalTo(bkg.mas_left).offset(margin);
                make.right.equalTo(bkg.mas_right).offset(-margin);
                make.height.equalTo(@1);
            }];
        }
        
        if(0 == i)
        {
            tag.text = @"收文编号";
            content.text = model.SWBH;
        }
        else if(1 == i)
        {
            tag.text = @"来文单位";
            content.text = model.LWDW;
        }
        else if(2 == i)
        {
            tag.text = @"标题";
            content.text = model.Title;
        }
        else if(3 == i)
        {
            tag.text = @"文号";
            content.text = model.WH;
        }
        else if(4 == i)
        {
            tag.text = @"缓急";
            content.text = model.HJ;
        }
        else if(5 == i)
        {
            tag.text = @"交办时间";
            content.text = model.SendDate;
        }
        else
        {
            tag.text = @"要求办完日期";
            content.text = model.LastDate;
        }
    }
    
    UILabel *fileHandler = [UILabel new];
    [verticalContainerView addSubview:fileHandler];
    fileHandler.textAlignment = NSTextAlignmentCenter;
    fileHandler.text = @"文件办理";
    fileHandler.font = [UIFont systemFontOfSize:NORMAL_SIZE];
    [fileHandler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bkg.mas_bottom).offset(10);
        make.centerX.equalTo(verticalContainerView.mas_centerX);
        make.width.equalTo(@75);
        make.height.equalTo(@44);
    }];

    UIView *leftLine = [UIView new];
    [verticalContainerView addSubview:leftLine];
    leftLine.backgroundColor = [UIColor blackColor];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bkg.mas_bottom).offset(32);
        make.left.equalTo(verticalContainerView.mas_left).offset(margin);
        make.right.equalTo(fileHandler.mas_left);
        make.height.equalTo(@1);
    }];

    UIView *rightLine = [UIView new];
    [verticalContainerView addSubview:rightLine];
    rightLine.backgroundColor = [UIColor blackColor];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bkg.mas_bottom).offset(32);
        make.left.equalTo(fileHandler.mas_right);
        make.right.equalTo(verticalContainerView.mas_right).offset(-margin);
        make.height.equalTo(@1);
    }];

    _fileDistribute = [UILabel new];
    [verticalContainerView addSubview:_fileDistribute];
    _fileDistribute.textAlignment = NSTextAlignmentLeft;
    _fileDistribute.text = @"文件转派";
    _fileDistribute.font = [UIFont boldSystemFontOfSize:BIG_SIZE];
    [_fileDistribute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fileHandler.mas_bottom);
        make.left.equalTo(verticalContainerView.mas_left).offset(margin);
        make.width.equalTo(@200);
        make.height.equalTo(@44);
    }];
    
    _fileDistributeView = [UIView new];
    [verticalContainerView addSubview:_fileDistributeView];
    _fileDistributeView.backgroundColor = [UIColor whiteColor];
    _fileDistributeView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _fileDistributeView.layer.borderWidth = 1;
    _fileDistributeView.layer.cornerRadius = 5;
    [_fileDistributeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fileDistribute.mas_bottom).offset(margin);
        make.left.equalTo(verticalContainerView.mas_left).offset(margin);
        make.right.equalTo(verticalContainerView.mas_right).offset(-margin);
        make.width.equalTo(@(SCREEN_WIDTH - 2*margin));
        make.height.equalTo(@44);
    }];

    UIButton *selectPerson = [UIButton new];
    [_fileDistributeView addSubview:selectPerson];
    [selectPerson mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.with.equalTo(_fileDistributeView);
        make.height.equalTo(@44);
    }];
    
    [selectPerson addTarget:self action:@selector(selectPersonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    tag_width = 50;
    content_width = SCREEN_WIDTH - 4*margin - tag_width;
    
    _rights = [[NSMutableArray alloc] init];
    _lines = [[NSMutableArray alloc] init];
    last = nil;
    for(int i = 0; i < 4; ++i)
    {
        UILabel *content = [UILabel new];
        [_fileDistributeView addSubview:content];
        content.textAlignment = NSTextAlignmentRight;
        content.text = @"test";
        content.font = [UIFont systemFontOfSize:NORMAL_SIZE];
        content.numberOfLines = 0;
        [_rights addObject:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
//            if(0 == i)
//            {
//                make.top.equalTo(selectPerson.mas_bottom);
//            }
//            else
//            {
//                make.top.equalTo(last.mas_bottom);
//            }
            make.top.equalTo(last ? last.mas_bottom : selectPerson.mas_bottom);
            make.right.equalTo(_fileDistributeView.mas_right).offset(-margin);
            make.width.equalTo(@(content_width));
            make.height.equalTo(@0);
        }];
        
        last = content;
        
//        if(i < 3)
//        {
//            UIView *line = [UIView new];
//            [_fileDistributeView addSubview:line];
//            line.backgroundColor = [UIColor darkGrayColor];
//            [_lines addObject:line];
//            [line mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(last.mas_top);
//                make.left.equalTo(_fileDistributeView.mas_left).offset(margin);
//                make.right.equalTo(_fileDistributeView.mas_right).offset(-margin);
//                make.height.equalTo(@0);
//            }];
//        }
        
//        UILabel *tag = [UILabel new];
//        [bkg addSubview:tag];
//        tag.textColor = [UIColor darkGrayColor];
//        tag.textAlignment = NSTextAlignmentLeft;
//        tag.font = [UIFont systemFontOfSize:NORMAL_SIZE];
//        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(last.mas_top);
//            make.left.equalTo(_fileDistributeView.mas_left).offset(margin);
//            make.width.equalTo(@(tag_width));
//            make.height.equalTo(last.mas_height);
//        }];
//
//
//        if(0 == i)
//        {
//            tag.text = @"批示";
//        }
//        else if(1 == i)
//        {
//            tag.text = @"主办";
//        }
//        else if(2 == i)
//        {
//            tag.text = @"协办";
//        }
//        else
//        {
//            tag.text = @"传阅";
//        }
    }
    
    // 设置过渡视图的底边距（此设置将影响到scrollView的contentSize）
    [verticalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(last.mas_bottom).offset(margin);
    }];

    
    return self;
}

#pragma mark - clicked

- (void)selectPersonClicked:(UIButton *)sender
{
    NSString *comment = @"批示1、批示2、批示3";
    NSString *host = @"主办1、主办2、主办3、主办4、主办5、主办6";
    NSString *coCoper = @"协办1、协办2、协办3、主办1、主办2、主办3、主办4、主办5、主办6、主办1、主办2、主办3、主办4、主办5、主办6";
    NSString *read = @"批示1、批示2、批示3";
    
    CGFloat tag_width = 50;
    CGFloat content_width = SCREEN_WIDTH - 4*10 - tag_width;
    
    CGFloat comment_height = [NSString calculateRowHeight:content_width string:comment fontSize:NORMAL_SIZE];
    if(comment_height < 44)
    {
        comment_height = 44;
    }
    CGFloat host_height = [NSString calculateRowHeight:content_width string:host fontSize:NORMAL_SIZE];
    if(host_height < 44)
    {
        host_height = 44;
    }
    CGFloat coCoper_height = [NSString calculateRowHeight:content_width string:coCoper fontSize:NORMAL_SIZE];
    if(coCoper_height < 44)
    {
        coCoper_height = 44;
    }
    CGFloat read_height = [NSString calculateRowHeight:content_width string:read fontSize:NORMAL_SIZE];
    if(read_height < 44)
    {
        read_height = 44;
    }
    
    CGFloat totalHeight = comment_height + host_height + coCoper_height + read_height + 44;
    
    [_fileDistributeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fileDistribute.mas_bottom).offset(MARGIN);
        make.left.equalTo(self.verticalContainerView.mas_left).offset(MARGIN);
        make.right.equalTo(self.verticalContainerView.mas_right).offset(-MARGIN);
        make.width.equalTo(@(SCREEN_WIDTH - 2*MARGIN));
        make.height.equalTo(@(totalHeight));
    }];

    CGFloat __block padding;
    
    [_rights enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger i, BOOL *stop) {
        if(0 == i)
        {
            padding = 44;
        }
        else if(1 == i)
        {
            padding += comment_height;
        }
        else if(2 == i)
        {
            padding += host_height;
        }
        else
        {
            padding += coCoper_height;
        }
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fileDistributeView.mas_top).offset(padding);
            make.right.equalTo(_fileDistributeView.mas_right).offset(-MARGIN);
            make.width.equalTo(@(content_width));
            if(0 == i)
            {
                _rights[i].text = comment;
                make.height.equalTo(@(comment_height));
            }
            else if(1 == i)
            {
                _rights[i].text = host;
                make.height.equalTo(@(host_height));
            }
            else if(2 == i)
            {
                _rights[i].text = coCoper;
                make.height.equalTo(@(coCoper_height));
            }
            else
            {
                _rights[i].text = read;
                make.height.equalTo(@(read_height));
            }
        }];
        
//        [_lines[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_fileDistributeView.mas_top).offset(padding);
//            make.left.equalTo(_fileDistributeView.mas_left).offset(MARGIN);
//            make.right.equalTo(_fileDistributeView.mas_right).offset(-MARGIN);
//            if(0 == i)
//            {
//                if(0 == comment_height)
//                {
//                    make.height.equalTo(@0);
//                }
//                else
//                {
//                    make.height.equalTo(@1);
//                }
//            }
//            else if(1 == i)
//            {
//                if(0 == host_height)
//                {
//                    make.height.equalTo(@0);
//                }
//                else
//                {
//                    make.height.equalTo(@1);
//                }
//            }
//            else if(2 == i)
//            {
//                if(0 == coCoper_height)
//                {
//                    make.height.equalTo(@0);
//                }
//                else
//                {
//                    make.height.equalTo(@1);
//                }
//            }
//            else
//            {
//                if(0 == read_height)
//                {
//                    make.height.equalTo(@0);
//                }
//                else
//                {
//                    make.height.equalTo(@1);
//                }
//            }
//        }];
    }];
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    //according to apple super should be called at end of method
    [super updateConstraints];
}


@end
