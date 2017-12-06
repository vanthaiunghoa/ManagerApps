//
//  AddressBookVC.m
//  Template
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "AddressGroupVC.h"
#import "AddressBookDetailVC.h"
#import "AddressBookModel.h"
#import "AddressGroupVC.h"
#import "AddressDetailVC.h"

@interface AddressGroupVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>


@property (nonatomic , strong ) UIView * topView;

@property (nonatomic , strong ) UITableView * tableView ;

//@property (nonatomic , strong ) UIView * headView;

@property (nonatomic , strong ) UIImageView* rightImg;

@property (nonatomic , strong ) AddressBookModel * addressBookModel ;

@property (nonatomic , strong ) AddressBookModel * addressSearchBookModel ;

@property (nonatomic , strong ) NSMutableArray * searchArray;

@property (nonatomic , assign ) BOOL   isSearch ;

@property (nonatomic , assign ) BOOL   isFirst ;

@property (nonatomic , strong ) NSArray<AddressBookUserList*> * searchUserList ;

@end

@implementation AddressGroupVC{
    
    BOOL _isOpen;
    
    UIImageView*_topImgView;
    UILabel*_nameLabel;
    UIButton*_backBtn;
    UITextField*_searchTextField;
    
    UISearchBar*_searchBar;
    
    
    UIView*_headView;
    
    UILabel*_titleLabel;
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // self.navigationController.navigationBar.hidden=NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationItem.title = @"通讯录";
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //self.navigationController.navigationBar.hidden=YES;
}

- (void)setKSName:(NSString *)KSName{
    
    _KSName = KSName;
    
    
    if (KSName != nil) {
        
        _titleLabel.text = KSName;
    }
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    [self creatUI];
    
    [self layout];
    
    [self getData];
    
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeTex:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndTex:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    //
    
    
}

- (void)configNav{}
- (void)creatUI{
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    _topView = [UIView new];
    _topView.backgroundColor =[ UIColor colorWithHex:0x24A6CB];
    
    _topImgView = [UIImageView new];
    _topImgView.image = [UIImage imageWithFileName:@""];
    
    
    _nameLabel=[UILabel new];
    _nameLabel.text=@"通讯录";
    _nameLabel.textColor=[UIColor colorWithHex:0xffffff];
    _nameLabel.font=[UIFont systemFontOfSize:kfont(20)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageWithFileName:@"返回"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _searchTextField = [UITextField new];
    _searchTextField.placeholder = @"输入姓名进行筛选...";
    _searchTextField.delegate=self;
    _searchTextField.textColor = [UIColor colorWithHex:0xeeeeee];
    _searchTextField.font = [UIFont systemFontOfSize:kfont(15)];
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"输入姓名进行筛选...";
    _searchBar.delegate = self;
    _searchBar.translucent =NO;
    _searchBar.opaque = NO;
    
    
//    _searchBar.barTintColor = [UIColor whiteColor];
//    _searchBar.tintColor = [UIColor whiteColor];
    
    [_topView addSubview:_topImgView];
    [_topView addSubview:_nameLabel];
    [_topView addSubview:_backBtn];
    //    [_topView addSubview:_searchTextField];
    
    [_topView addSubview:_searchBar];
    
    [self.view addSubview:_topView];
    
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    
    _tableView.estimatedRowHeight=aph(40);
    _tableView.rowHeight=UITableViewAutomaticDimension;
    //    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    //    [_tableView registerClass:[AdviceCell class] forCellReuseIdentifier:adviceCell];
    
    _tableView.contentInset = UIEdgeInsetsMake(kph(290/3.f), 0, 0, 0);
    
    [self.view addSubview:_tableView];
    
    [self.view sendSubviewToBack:_tableView];
    
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)pop:(UIButton*)button{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)layout{
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        
        make.height.equalTo(@(kph(300/3.f)));
        
        
    }];
    
    
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        
        make.height.equalTo(@(kph(151/3.f)));
        
        
        
    }];
    
    
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(40/3.f)));
        
        make.top.equalTo(@((kStatusHeight+5)));
        
        
        
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_topImgView.mas_centerX);
        
        //        make.top.equalTo(@(kStatusHeight));
        
        make.centerY.equalTo(_backBtn.mas_centerY);
        
        
        
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(0/1.f)));
        make.right.equalTo(@0);
        make.height.equalTo(@(kph(130/3.f)));
        
        //        make.top.equalTo(_topImgView.mas_bottom).with.offset(0);
        make.bottom.equalTo(@0);
        
    }];
    
    
    
    
    
    
    
    
}
- (void)getData{
    
    return;
    
    NSMutableDictionary*param = [NSMutableDictionary dictionary];
    
    //    /Contact/ContactHandler.ashx?Action=GetContactByUserID&para={UserID:""}
    param[@"Action"]=@"GetContactByUserID";
    param[@"para"]=[NSString stringWithFormat:@"{UserID:\"%@\"}",[[NSUserDefaults standardUserDefaults]objectForKey:@"userNameStr"]];
    
    
    NSString*url = [NSString stringWithFormat:@"%@/Contact/ContactHandler.ashx",BaseUrl];
    
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"请稍候..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud setHidden:YES];
    });
    
    [DDNetworkTool GET:url parameters:param success:^(id responseObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [hud setHidden:YES];
        });
        
        
        NSError *error;
        
        NSArray*array=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@",array);
        
        NSMutableDictionary*dict = [NSMutableDictionary dictionary];
        
        dict[@"data"]=array;
        
        
        _addressBookModel = [AddressBookModel mj_objectWithKeyValues:dict];
        
        
        
        NSDictionary*tmp = _addressBookModel.mj_keyValues;
        
        NSLog(@"tmp == %@",tmp);
        
        
        [_tableView reloadData];
        
        //缓存下来
        
        NSString *cachePath = kUserPhonePath;
        
        [responseObject writeToFile:cachePath atomically:YES];
        
        
        _searchArray = [NSMutableArray array];
        
        
        
        if (_addressBookModel.data.count>0) {
            
            
            for (int i =0; i<_addressBookModel.data.count; i++) {
                
                
                if (_addressBookModel.data[i].UserList.count>0) {
                    
                    for (int j=0; j<_addressBookModel.data[i].UserList.count; j++) {
                        
                        AddressBookUserList*tmp = _addressBookModel.data[i].UserList[j];
                        
                        
                        if (tmp.UserName!=nil) {
                            
                            NSMutableDictionary*dict = [NSMutableDictionary dictionary];
                            
                            dict[@"UserName"]=tmp.UserName;
                            dict[@"section"]=@(i).stringValue;
                            dict[@"row"]=@(j).stringValue;
                            
                            [_searchArray addObject:dict];
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        
        [hud setHidden:YES];
        
        
    }];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //如果没有数据就加载本地数据
        if (_addressBookModel == nil) {
            
            [hud setHidden:YES];
            
            NSString * cachePath = kUserPhonePath;
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
                
                //从本地读缓存文件
                NSData *data = [NSData dataWithContentsOfFile:cachePath];
                
                NSArray*array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"本地数据%@",array);
                
                NSMutableDictionary*dict = [NSMutableDictionary dictionary];
                
                dict[@"data"]=array;
                
                
                _addressBookModel = [AddressBookModel mj_objectWithKeyValues:dict];
                
                //        NSDictionary*tmp = _addressBookModel.mj_keyValues;
                //
                //        NSLog(@"tmp == %@",tmp);
                
                
                [_tableView reloadData];
                
                
                
                
                
                
            }
            
            
        }
        
    });
    
    
    
    
    
    
    
    
    
}


#define mark  tableView datasource and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    
    return kph(170/3.f);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.0001;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    _headView = [UIView new];
    _headView.backgroundColor = [UIColor whiteColor];
    
    _headView.frame = CGRectMake(0, 0, kScreen_Width, kph(170/3.f));
    
    UILabel*label = [UILabel new];
    label.textColor = [UIColor colorWithHex:0x2badda];
    label.font = [UIFont boldSystemFontOfSize:kfont(16)];
    
    label.text = [NSString stringWithFormat:@"%@ >",_KSName];
    
    _titleLabel = label;
    
    
    [_headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(50/3.f)));
        make.centerY.equalTo(_headView.mas_centerY);
        
        
        
    }];
    
    
   
    //添加点击事件
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeadView:)];
    
    _headView.userInteractionEnabled = YES;
    
    _headView.tag = section;
    
    [_headView addGestureRecognizer:tap];
    
    
    return _headView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return kph(168/3.f);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_isSearch) {
        
        if (_searchUserList.count>0) {
            
            return _searchUserList.count;
        }
        
    }else{
    
    if (_userList.count>0) {
        
        return _userList.count;
    }
    
    }
    
    return 0;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString*const cellStr = @"cellStr";
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageWithFileName:@"头像-拷贝"];
    
    
    if (_isSearch) {
        
        if (_searchUserList.count > indexPath.row  && _searchUserList[indexPath.row].UserName!=nil  ) {
            
            cell.textLabel.text = _searchUserList[indexPath.row].UserName;
        }
        
    }else{
    
    if (_userList.count > indexPath.row  && _userList[indexPath.row].UserName!=nil  ) {
        
        cell.textLabel.text = _userList[indexPath.row].UserName;
    }
    
    }
    

    
    return cell;
    
}

- (void)clickHeadView:(UITapGestureRecognizer*)tap{
    
    [_searchBar resignFirstResponder];//注销第一响应者
    
    
    [self.navigationController popViewControllerAnimated:YES];
   
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    //推出一个界面来
    

    AddressDetailVC*vc = [AddressDetailVC new];
    
    if (_isSearch) {
        
        vc.list = _searchUserList[indexPath.row];
        
        vc.name = _KSName;
        
    }else{
        
        vc.list = _userList[indexPath.row];
        
        vc.name = _KSName;
        
        }
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}



- (void)didChangeTex:(NSNotification*)notice{
    
    _isSearch = YES;
    
    
    NSLog(@"我改变了");
    
    
    _addressSearchBookModel = [AddressBookModel mj_objectWithKeyValues:_addressBookModel.mj_keyValues];
    
    
    
    NSIndexSet*set4 = [_addressSearchBookModel.data  indexesOfObjectsPassingTest:^BOOL(AddressBookDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if ([obj.KSName containsString:_searchTextField.text]) {
            
            return NO;
            
        }else{
            
            return  YES;
            
        }
        
        
        
        return  YES;
    }];
    
    NSMutableArray*array2 = [_addressSearchBookModel.data mutableCopy];
    
    [array2 removeObjectsAtIndexes:set4];
    
    _addressSearchBookModel.data =[array2 mutableCopy];
    
    
    [_tableView reloadData];
    
    
    
    //    }
    
    if (_searchTextField.text.length<=0) {
        
        
        _isSearch = NO;
        
        [_tableView reloadData];
    }
    
    
}


- (void)didEndTex:(NSNotification*)notice{
    
    
    if (_searchTextField.text.length<=0) {
        
        
        _isSearch = NO;
        
        [_tableView reloadData];
    }
    
    
    
    
    
}


- (void)beginEdit:(NSNotification*)notice{
    
    _isFirst = YES;
    
}


#pragma mark SeaarchBar代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    _isSearch = YES;
    
    
    NSLog(@"我改变了");
    
    
    _searchUserList = [_userList mutableCopy];
    
    
    
    NSIndexSet*set4 = [_searchUserList indexesOfObjectsPassingTest:^BOOL(AddressBookUserList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj.UserName containsString:_searchBar.text]) {
            
            return NO;
            
        }else{
            
            
            return  YES;
        }
        
        
        
        
    }];
    
    NSMutableArray*array2 = [_searchUserList mutableCopy];
    
    [array2 removeObjectsAtIndexes:set4];
    
    _searchUserList =[array2 mutableCopy];
    
    
    [_tableView reloadData];
    
    
    
    //    }
    
    if (searchBar.text.length<=0) {
        
        
        _isSearch = NO;
        
        [_tableView reloadData];
        
    }
    
    
    
    
    
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    if (searchBar.text.length > 0) {
        
        _isSearch = YES;
        
        [_tableView reloadData];
    }
    
    
    
    
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
    _isFirst = YES;
    
}



@end


