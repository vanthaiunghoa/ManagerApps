//
//  NewIssueViewController.m
//  EngineeringInspection
//
//  Created by wanve on 2018/5/29.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "NewIssueViewController.h"
#import "UIColor+color.h"
#import "IssueCell.h"
#import "CLImageEditor.h"

#define ImageHeight 60
#define ImageMargin 10

@interface NewIssueViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CLImageEditorDelegate, CLImageEditorTransitionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) NSMutableArray *isExpandArray;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat imgX;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) UIImageView *editImage;

@end

@implementation NewIssueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self initTableView];
    [self initHeaderView];
    [self initBottomView];
}

#pragma mark - init

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_HEIGHT - 70) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionHeaderHeight = 44;
    
    [_tableView registerClass:[IssueCell class] forCellReuseIdentifier:NSStringFromClass([IssueCell class])];
}

- (void)initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 140)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat y = 0;
    CGFloat x = 15;
    CGFloat w = SCREEN_WIDTH - 2.0*x;
    UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 20)];
    marginView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [headerView addSubview:marginView];
    y += 20;

    UILabel *add = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 40)];
    [add setFont:[UIFont systemFontOfSize:14]];
    [add setTextAlignment:NSTextAlignmentLeft];
    [add setTextColor:[UIColor colorWithRGB:28 green:120 blue:255]];
    [add setText:@"添加图片"];
    [headerView addSubview:add];
    
    y += 40;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, ImageHeight)];
//    _scrollView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [_scrollView setContentSize:CGSizeMake(6.0*ImageHeight + 5*ImageMargin, ImageHeight)];
    [headerView addSubview:_scrollView];

    _imgX = 0;
    UIImageView *imgAdd = [[UIImageView alloc] initWithFrame:CGRectMake(_imgX, 0, ImageHeight, ImageHeight)];
    imgAdd.image = [UIImage imageNamed:@"take-photo"];
    [_scrollView addSubview:imgAdd];
    imgAdd.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapAdd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotoClicked:)];
    tapAdd.delegate = self;
    [imgAdd addGestureRecognizer:tapAdd];
    
    _imgX += ImageHeight + ImageMargin;
    
    _tableView.tableHeaderView = headerView;
}

- (void)initBottomView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认增加" forState:UIControlStateNormal];
//    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:10];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
//    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
}

#pragma mark - pravite

- (void)addPhoto:(UIImage *)image
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_imgX, 0, ImageHeight, ImageHeight)];
    img.image = image;
    img.userInteractionEnabled = YES;
    [_scrollView addSubview:img];
    [self.imgArray addObject:img];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlerPhoto:)];
    tap.delegate = self;
    [img addGestureRecognizer:tap];
    
    _imgX += ImageHeight + ImageMargin;
}

- (void)deletePhoto:(UIImageView *)imageView
{
    CGRect deletedFrame = imageView.frame;
    [imageView removeFromSuperview];
    [self.imgArray removeObject:imageView];
    
    for(int i = 0; i < self.imgArray.count; ++i)
    {
        UIImageView *img = self.imgArray[i];
        CGRect frame = img.frame;
        if(deletedFrame.origin.x < frame.origin.x)
        {
            frame.origin.x -= ImageMargin + ImageHeight;
            [self.imgArray[i] setFrame:frame];
        }
    }
    
    _imgX = (self.imgArray.count + 1)*(ImageHeight + ImageMargin);
}

#pragma mark - clicked

- (void)confirmClicked:(UIButton *)sender
{
    
}

- (void)addPhotoClicked:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)handlerPhoto:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择您的操作" preferredStyle:UIAlertControllerStyleActionSheet];    
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                           {
                               _isEdit = YES;
                               self.editImage = imageView;
                               CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:imageView.image delegate:self];
                               [self presentViewController:editor animated:YES completion:nil];
                           }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [self deletePhoto:imageView];
                             }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:edit];
    [alertController addAction:delete];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController isKindOfClass:[UIImagePickerController class]] && [viewController isKindOfClass:[CLImageEditor class]]){
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidPush:)];
    }
}

- (void)cancelButtonDidPush:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
}

#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEditingWithImage:(UIImage *)image
{
    if(_isEdit)
    {
        self.editImage.image = image;
    }
    else
    {
        [self addPhoto:image];
    }
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    _isEdit = NO;
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat arrowHeight = 18;
    CGFloat arrowWidth = 18;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *classify = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30 - arrowWidth, 44)];
    classify.textColor = [UIColor colorWithRGB:28 green:120 blue:255];
    classify.text = self.sectionArray[section];
    [headerView addSubview:classify];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - arrowWidth - 15, (44 - arrowHeight)/2.0, arrowWidth, arrowHeight)];
    arrow.userInteractionEnabled = NO;
    if([self.isExpandArray[section] isEqualToString:@"0"])
    {
        arrow.image = [UIImage imageNamed:@"statistics-arrow-down"];
    }
    else
    {
        arrow.image = [UIImage imageNamed:@"statistics-arrow-up"];
    }
    
    [headerView addSubview:arrow];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    tap.delegate = self;
    [headerView addGestureRecognizer:tap];
    headerView.tag = section;
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.isExpandArray[section]isEqualToString:@"1"])
    {
        return self.projectArray.count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IssueCell class])];
    cell.projectName = self.projectArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tapClicked:(UITapGestureRecognizer *)tap
{
    if ([self.isExpandArray[tap.view.tag] isEqualToString:@"0"])
    {
        //关闭 => 展开
        [self.isExpandArray replaceObjectAtIndex:tap.view.tag withObject:@"1"];
    }else
    {
        //展开 => 关闭
        [self.isExpandArray replaceObjectAtIndex:tap.view.tag withObject:@"0"];
    }
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tap.view.tag];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - lazy load

- (NSArray *)sectionArray
{
    if(_sectionArray == nil)
    {
        _sectionArray = [NSArray array];
        _sectionArray = @[@"万维博通大厦"];
        
        _isExpandArray = [NSMutableArray array];
        for(int i = 0; i < _sectionArray.count; ++i)
        {
            [_isExpandArray addObject:@"0"];
        }
    }
    
    return _sectionArray;
}

- (NSArray *)projectArray
{
    if(_projectArray == nil)
    {
        _projectArray = [NSArray array];
        _projectArray = @[@"项目一", @"项目二", @"项目三"];
    }
    
    return _projectArray;
}

- (NSMutableArray *)imgArray
{
    if(_imgArray == nil)
    {
        _imgArray = [NSMutableArray array];
    }
    
    return _imgArray;
}

@end
