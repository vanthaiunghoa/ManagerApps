//
//  ListPicker.m
//  OA_IPAD
//
//  Created by cello on 2018/4/11.
//  Copyright © 2018年 icebartech. All rights reserved.
//

#import "ListPicker.h"
#import "ListPickerCell.h"
#import "ListPickerHeaderFooter.h"

@interface ListPicker() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation ListPicker

+ (instancetype)listPickerWithTitles:(NSArray<NSString *> *)titles delegate:(id<ListPickerDelegate>)delegate {
    ListPicker *instance = [[NSBundle mainBundle] loadNibNamed:@"ListPicker" owner:nil options:nil].firstObject;
    instance.maxListHeight = 700;
    instance.titles = titles;
    instance.delegate = delegate;
    instance.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:instance];
    return instance;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"ListPickerCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ListPickerHeaderFooter" bundle:nil] forHeaderFooterViewReuseIdentifier:@"headerfooter"];
    self.tableView.rowHeight = 70;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.sectionHeaderHeight = 80;
    self.tableView.sectionFooterHeight = 70;
    [self calculateHeight];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self.tableView reloadData];
    [self calculateHeight];
}

- (void)calculateHeight {
    CGFloat estimatedListHeight = 80+70*self.titles.count+70;
    if (estimatedListHeight > self.maxListHeight) {
        estimatedListHeight = self.maxListHeight;
    }
    self.tableViewHeight.constant = estimatedListHeight;
    [self layoutIfNeeded];
}

/**
 从window上面消失。带有动画；不至于那么突兀
 */
- (void)dismissAnimated {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ListPickerHeaderFooter *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerfooter"];
    [header.titleButton setTitle:self.headerTitle forState:0];
    [header.titleButton addTarget:self action:@selector(headerSelect:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ListPickerHeaderFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerfooter"];
    [footer.titleButton setTitle:self.footerTitle forState:0];
    [footer.titleButton addTarget:self action:@selector(selectFooter:) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark - actions

- (void)headerSelect:(id)sender {
    if (self.delegate) {
        [self.delegate listPicker:self didSelectHeader:sender];
    }
}

- (void)selectFooter:(id)sender {
    if (self.delegate) {
        [self.delegate listPicker:self didSelectFooter:sender];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate listPicker:self didSelectItemAtIndex:indexPath.row title:self.titles[indexPath.row]];
    }
}

#pragma mark - getters and setters

- (NSString *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = @"请选择";
    }
    return _headerTitle;
}

- (NSString *)footerTitle {
    if (!_footerTitle) {
        _footerTitle = @"关闭";
    }
    return _footerTitle;
}
@end
