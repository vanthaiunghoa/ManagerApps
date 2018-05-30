#import "StatisticsViewController.h"
#import "UIColor+color.h"
#import "StatisticsCell.h"
#import "StatisticsDetailViewController.h"
#import "UIImage+image.h"

@interface StatisticsViewController ()<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) NSMutableArray *isExpandArray;

@end

@implementation StatisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self initTableView];
}

#pragma mark - init

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.sectionHeaderHeight = 44;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_tableView registerClass:[StatisticsCell class] forCellReuseIdentifier:NSStringFromClass([StatisticsCell class])];
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
    StatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StatisticsCell class])];
    cell.projectName = self.projectArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    StatisticsDetailViewController *vc = [[StatisticsDetailViewController alloc] init];
    vc.selectIndex = 0;
    //    vc.title = key;
    vc.menuViewStyle = WMMenuViewStyleLine;
    vc.automaticallyCalculatesItemWidths = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
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


@end
