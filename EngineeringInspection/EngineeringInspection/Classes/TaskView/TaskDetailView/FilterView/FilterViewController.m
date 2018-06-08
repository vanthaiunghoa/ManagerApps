#import "FilterViewController.h"
#import "FilterCell.h"
#import "ListModel.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UrlManager.h"
#import "UIColor+color.h"
#import "ClassifyView.h"

@interface FilterViewController()<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *filterTableView;
@property (nonatomic, strong) NSDictionary *classifyDict;
@property (nonatomic, strong) NSArray *classifyArray;
@property (nonatomic, strong) NSMutableArray *isExpandArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation FilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    
    [self initTopView];
    [self initBottomView];
//    [self initfilterTableView];
    [self initScrollView];
}

#pragma mark - init

- (void)initTopView
{
    CGFloat topHeight = 70;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, FilterViewWidth, topHeight)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
    CGFloat btnHeight = 40;
    UIButton *btnCreate = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCreate setFrame:CGRectMake(10, (topHeight - btnHeight)/2.0, (FilterViewWidth - 50)/3.0, btnHeight)];
    [btnCreate setTitle:@"我创建的" forState:UIControlStateNormal];
    [btnCreate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCreate.layer setCornerRadius:10];
    [btnCreate setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
    [topView addSubview:btnCreate];
    
    [btnCreate addTarget:self action:@selector(myCreateClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initBottomView
{
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, FilterViewWidth, 44)];
    [confirmView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:confirmView];
    
    CGFloat btnW = FilterViewWidth/2.0;
    CGFloat x = 0;
    NSArray *arr = [[NSArray alloc]initWithObjects:@"重置", @"确定", nil];
    
    for(int i = 0; i < arr.count; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, 0, btnW, 44)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        if(0 == i)
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithRGB:28 green:120 blue:255]];
        }
        btn.tag = i;
        [confirmView addSubview:btn];
        
        [btn addTarget:self action:@selector(confirmViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        x += btnW;
    }
}

- (void)initScrollView
{
    CGFloat y = 105;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, FilterViewWidth, SCREEN_HEIGHT - 105 - 44)];
    scrollView.backgroundColor = [UIColor colorWithRGB:239 green:246 blue:252];
    [self.view addSubview:scrollView];
    
    y = 0;
    for(int i = 0; i < self.classifyArray.count; ++i)
    {
        ClassifyView *classifyView = [[ClassifyView alloc] initWithFrame:CGRectMake(0, y, FilterViewWidth, 100)];
        classifyView.title = self.classifyArray[i];
        classifyView.detailArray = [self.classifyDict objectForKey:self.classifyArray[i]];
        [scrollView addSubview:classifyView];
        
        y += 100;
    }
    
    [scrollView setContentSize:CGSizeMake(FilterViewWidth, y)];
}

- (void)initfilterTableView
{
    _classifyArray = [NSArray array];
    _isExpandArray = [NSMutableArray array];
    
    NSString *dataList = [[NSBundle mainBundle]pathForResource:@"filter" ofType:@"plist"];
    _classifyDict = [[NSDictionary alloc]initWithContentsOfFile:dataList];
    _classifyArray = [_classifyDict allKeys];
    for (NSInteger i = 0; i < _classifyArray.count; i++)
    {
        //0:没展开 1:展开
        [_isExpandArray addObject:@"0"];
    }
    
    _filterTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, FilterViewWidth, SCREEN_HEIGHT - 105 - 44) style:UITableViewStyleGrouped];
    [_filterTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_filterTableView setBackgroundColor:[UIColor colorWithRGB:239 green:246 blue:252]];
    [_filterTableView registerClass:[FilterCell class] forCellReuseIdentifier:NSStringFromClass([FilterCell class])];
    [_filterTableView setDelegate:self];
    [_filterTableView setDataSource:self];
    _filterTableView.sectionHeaderHeight = 44;
    [self.view addSubview:_filterTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -clicked

-(void)myCreateClicked:(UIButton *)sender
{

}

- (void)confirmViewClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
            PLog(@"重置");
            break;
        case 1:
            PLog(@"确定");
            break;
        default:
            PLog(@"error");
            break;
    }
}

- (void)allClicked:(UIButton *)sender
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
    [_filterTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - tableView delegate

#pragma - mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.classifyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.isExpandArray[section]isEqualToString:@"1"]) {
        return 1;
    }
    else{
        return 0;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat btnWidth = 80;
    
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FilterViewWidth, 44)];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [headerView setBackgroundColor:[UIColor redColor]];
    UILabel *classify = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, FilterViewWidth - 20 - btnWidth, 44)];
    classify.textColor = [UIColor blackColor];
    classify.text = self.classifyArray[section];
    [headerView addSubview:classify];
    
    UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAll setFrame:CGRectMake(FilterViewWidth - 10 - btnWidth, 0, btnWidth, 44)];
    [btnAll setTitle:@"全部" forState:UIControlStateNormal];
    [btnAll.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnAll.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [btnAll setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [headerView addSubview:btnAll];
    
    [btnAll addTarget:self action:@selector(allClicked:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat arrowHeight = 8.4;
    CGFloat arrowWidth = 16;
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(btnWidth - arrowWidth, (44 - arrowHeight)/2.0, arrowWidth, arrowHeight)];
    arrow.userInteractionEnabled = NO;
    arrow.image = [UIImage imageNamed:@"gray-arrow-down"];
    [btnAll addSubview:arrow];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    tap.delegate = self;
    [headerView addGestureRecognizer:tap];
    headerView.tag = section;
   
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class currentClass = [FilterCell class];
    FilterCell *cell = nil;
//
//    ReceiveCommonModel *model = self.modelsArray[indexPath.row];
//    if (model.imagePathsArray.count > 1)
//    {
//        currentClass = [ReceiveCell2 class];
//    }

    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    NSString *keyOfClassify = self.classifyArray[indexPath.section];
    cell.detailArray = [self.classifyDict objectForKey:keyOfClassify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.delegate = self;

    return cell;
}

#pragma mark - lazy load

- (NSMutableArray *)cells
{
    if(_cells == nil)
    {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

- (NSArray *)classifyArray
{
    if(_classifyArray == nil)
    {
        _classifyArray = [NSArray array];
        _classifyArray = @[@"状态", @"任务", @"部位", @"检查项", @"检查组", @"整改日期"];
    }
    return _classifyArray;
}

- (NSDictionary *)classifyDict
{
    if(_classifyDict == nil)
    {
        NSString *dataList = [[NSBundle mainBundle]pathForResource:@"filter" ofType:@"plist"];
        _classifyDict = [[NSDictionary alloc]initWithContentsOfFile:dataList];
    }
    
    return _classifyDict;
}

//- (NSMutableArray *)isExpandArray
//{
//    if(_isExpandArray == nil && self.classifyArray)
//    {
//        _isExpandArray = [NSMutableArray array];
//        for(int i = 0; i < self.classifyArray.count; ++i)
//        {
//            [_isExpandArray addObject:@"0"];
//        }
//    }
//    return _isExpandArray;
//}

@end
