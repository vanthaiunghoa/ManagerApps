//
//  AddressBookVC.m
//  Template
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "AddressBookVC.h"
#import "AddressBookDetailVC.h"
#import "AddressBookModel.h"

@interface AddressBookVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic , strong ) UIView * topView;

@property (nonatomic , strong ) UITableView * tableView ;

//@property (nonatomic , strong ) UIView * headView;

@property (nonatomic , strong ) UIImageView* rightImg;

@property (nonatomic , strong ) AddressBookModel * addressBookModel ;

@property (nonatomic , strong ) AddressBookModel * addressSearchBookModel ;

@property (nonatomic , strong ) NSMutableArray * searchArray;

@property (nonatomic , assign ) BOOL   isSearch ;

@property (nonatomic , assign ) BOOL   isFirst ;

@end

@implementation AddressBookVC{
    
    BOOL _isOpen;
    
    UIImageView*_topImgView;
    UILabel*_nameLabel;
    UIButton*_backBtn;
    UITextField*_searchTextField;
    
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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    
    [self creatUI];
    
    [self layout];
    
    [self getData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEdit:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeTex:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndTex:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
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
    
    
    [_topView addSubview:_topImgView];
    [_topView addSubview:_nameLabel];
    [_topView addSubview:_backBtn];
    [_topView addSubview:_searchTextField];
    
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

    

}

- (void)pop:(UIButton*)button{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)layout{
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(kph(290/3.f)));
        
        
    }];
    
    
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(kph(151/3.f)));
        
        
        
    }];
    
 
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(kpt(40/3.f)));
        
        make.top.equalTo(@((kStatusHeight+10)));
        
                          
                          
        
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_topImgView.mas_centerX);
        
        //        make.top.equalTo(@(kStatusHeight));
        
        make.centerY.equalTo(_backBtn.mas_centerY);
        
        
        
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@(kpt(15/1.f)));
        make.right.equalTo(@0);
        make.height.equalTo(@(kph(134/3.f)));
        make.top.equalTo(_topImgView.mas_bottom).with.offset(0);
        
    }];
    
    
    
    
    
    
    
    
}
- (void)getData{
    
    
    
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
            
            [hud setHidden:YES];
       
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
    
    
    UIView*_headView = [UIView new];
    
    _headView.frame = CGRectMake(0, 0, kScreen_Width, kph(170/3.f));
    
    UILabel*label = [UILabel new];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.font = [UIFont boldSystemFontOfSize:kfont(16)];
    
//    label.text = @"总部";
    
    if (_addressBookModel.data.count>section) {
        
        
        if (_addressBookModel.data[section].KSName!=nil) {
            
            label.text = _addressBookModel.data[section].KSName;
            
        }
        
        
    }
    
    
    [_headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(50/3.f)));
        make.centerY.equalTo(_headView.mas_centerY);
        
        
        
    }];
    
    
    UIImageView* rightImg = [UIImageView new];
    
    if (_addressBookModel.data.count>section) {
        
        if (![_addressBookModel.data[section].isOpen isEqualToString:@"1"]) {
            
            rightImg.image = [UIImage imageWithFileName:@"向右边框三角-拷贝"];//down
            
        }else{
            
            rightImg.image = [UIImage imageWithFileName:@"down"];//down
            
        }
        
    }
    
   

    [_headView addSubview:rightImg];
    
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(kpt(-40/3.f)));
        
//        make.left.equalTo(@(kScreen_Width-40/3.f));
        
        make.centerY.equalTo(_headView.mas_centerY);
        
        
    }];
    
    
    UIView*bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    
    [_headView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        
        make.height.equalTo(@(kph(1)));
        
        
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
    
    if (_isSearch) {
        
        if (_addressSearchBookModel.data.count!=0) {
            
            
            return _addressSearchBookModel.data.count;
            
        }
        
        
    }else{
    
                if (_addressBookModel.data.count!=0) {
                    
                    
                    return _addressBookModel.data.count;
                    
                }
    
    }
    
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (_isSearch) {
        
        if (_addressSearchBookModel.data.count>0) {
            
            if ([_addressSearchBookModel.data[section].isOpen isEqualToString:@"1"]) {
                
                if (_addressSearchBookModel.data[section].UserList.count!=0) {
                    
                    return _addressSearchBookModel.data[section].UserList.count;
                    
                }
                
                
            }else{
                
                
                return 0;
                
                
            }
            
            
        }
        
        
        
    }else{
        
        if (_addressBookModel.data.count>0) {
            
            if ([_addressBookModel.data[section].isOpen isEqualToString:@"1"]) {
                
                if (_addressBookModel.data[section].UserList.count!=0) {
                    
                    return _addressBookModel.data[section].UserList.count;
                }
                
                
            }else{
                
                
                return 0;
                
                
            }
            
            
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
    
//    cell.textLabel.text=@"某某某";
    
    if (_isSearch) {
        
        if (_addressSearchBookModel.data.count!=0 && _addressSearchBookModel.data[indexPath.section].UserList.count!=0) {
            
            if (_addressSearchBookModel.data[indexPath.section].UserList[indexPath.row].UserName!=nil) {
                
                
                cell.textLabel.text = _addressSearchBookModel.data[indexPath.section].UserList[indexPath.row].UserName;
                
            }
            
            
            
            
        }
        
    }else{
    
    if (_addressBookModel.data.count!=0 && _addressBookModel.data[indexPath.section].UserList.count!=0) {
        
        if (_addressBookModel.data[indexPath.section].UserList[indexPath.row].UserName!=nil) {
            
            
            cell.textLabel.text = _addressBookModel.data[indexPath.section].UserList[indexPath.row].UserName;
            
        }
        
        
        
        
    }
    
    
    }
    
    return cell;
    
}

- (void)clickHeadView:(UITapGestureRecognizer*)tap{
    
    if (_isSearch) {
        
        if (_addressSearchBookModel.data.count>tap.view.tag) {
            
            if ([_addressSearchBookModel.data[tap.view.tag].isOpen isEqualToString:@"1"]) {
                
                _addressSearchBookModel.data[tap.view.tag].isOpen = @"0";
                
            }else{
                
                _addressSearchBookModel.data[tap.view.tag].isOpen = @"1";
                
            }
            
            
        }
        
    }else{
    
                if (_addressBookModel.data.count>tap.view.tag) {
                    
                    if ([_addressBookModel.data[tap.view.tag].isOpen isEqualToString:@"1"]) {
                        
                        _addressBookModel.data[tap.view.tag].isOpen = @"0";
                        
                    }else{
                        
                        _addressBookModel.data[tap.view.tag].isOpen = @"1";
                        
                    }
                    
                    
                }
        
    }

    
    [_tableView reloadData];
    

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //推出一个界面来
    
    if (_isSearch) {
        
         [AddressBookDetailVC showDetailViewWith:_addressSearchBookModel indexPath:indexPath];
        
    }else{
        
        
        [AddressBookDetailVC showDetailViewWith:_addressBookModel indexPath:indexPath];
        
    }
    
//    [AddressBookDetailVC shareInstance].fathViewController = self;
    
//    [self addChildViewController:[AddressBookDetailVC shareInstance]];
//
//    [self.view addSubview:[AddressBookDetailVC shareInstance].view];
    
    
    
}



- (void)didChangeTex:(NSNotification*)notice{
    
    _isSearch = YES;
    
    
    NSLog(@"我改变了");
//
//    if ([_searchArray.mj_JSONString containsString:_searchTextField.text]) {
//
//        NSLog(@"包含");
//
//        [_addressBookModel.data enumerateObjectsUsingBlock:^(AddressBookDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            [obj.UserList enumerateObjectsUsingBlock:^(AddressBookUserList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                if ([obj.UserName containsString:_searchTextField.text]) {
//
//
//                    obj.isSearch = YES;
//
//
//
//                }else{
//
//
//                    obj.isSearch = NO;
//
//
//                }
//
//
//
//
//            }];
//
//
//
//
//
//
//        }];
//
//
//
//
//    }
    
    
        _addressSearchBookModel = [AddressBookModel mj_objectWithKeyValues:_addressBookModel.mj_keyValues];
   
    
  NSIndexSet* set1 =  [_addressSearchBookModel.data indexesOfObjectsPassingTest:^BOOL(AddressBookDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSIndexSet*  set2 = [obj.UserList indexesOfObjectsPassingTest:^BOOL(AddressBookUserList * _Nonnull obj,
                                                                           NSUInteger idx, BOOL * _Nonnull stop) {

            if ([obj.UserName containsString:_searchTextField.text]) {


                return NO;



            }else{


                return YES;


            }



        }];
      
      
      
      NSMutableArray*array = [obj.UserList mutableCopy] ;
      
      [array removeObjectsAtIndexes:set2];//把没有的移除掉

      obj.UserList = [array mutableCopy];


        return NO;
    }];
        
    
        NSIndexSet* set3 = [_addressSearchBookModel.data indexesOfObjectsPassingTest:^BOOL(AddressBookDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            if (_isFirst) {
                
                obj.isOpen = @"1";
                
//                _isFirst = NO;
            }
            
            
           
            if (obj.UserList.count!=0) {
                
                
                return NO;
                
            }else{
                
                
                
                return YES;
                
            }
            
            
           
            
        }];
        
        
        NSMutableArray*array = [_addressSearchBookModel.data mutableCopy];
        
        [array removeObjectsAtIndexes:set3];

        _addressSearchBookModel.data = [array mutableCopy];
    
    
    
//     _addressSearchBookModel = [_addressBookModel mutableCopy];
//
//        AddressBookModel*searchBookModel = [AddressBookModel new];
//
//
//        NSMutableArray*array1 = [NSMutableArray array];
//
//        NSMutableArray*array2 = [NSMutableArray array];
//
//        if (_addressBookModel.data.count>0) {
//
//
//            for (int i =0; i<_addressBookModel.data.count; i++) {
//
//
//                if (_addressBookModel.data[i].UserList.count>0) {
//
//                    for (int j=0; j<_addressBookModel.data[i].UserList.count; j++) {
//
//                        AddressBookUserList*tmp = _addressBookModel.data[i].UserList[j];
//
//
//                        if ([tmp.UserName containsString:_searchTextField.text]) {
//
//                            [array1 addObject:_addressBookModel.data[i]];
//
//                            [array2 addObject:tmp];
//
//
//
//                        }
//
//
//
//                    }
//
//
//                }
//
//
//
//            }
//        }
        
    

        
    
    
    
    
    
    
    
    
    
    
    
        [_tableView reloadData];
    
    
    
//    }
    
    if (_searchTextField.text.length<=0) {
        
        
        _isSearch = NO;
        
        [_tableView reloadData];
    }
    
    
}


- (void)didEndTex:(NSNotification*)notice{
    
//    _isSearch = NO;
//
//
//
//
//
//    [_tableView reloadData];
    
    if (_searchTextField.text.length<=0) {
        
        
        _isSearch = NO;
        
        [_tableView reloadData];
    }
    
    
    

    
}


- (void)beginEdit:(NSNotification*)notice{
    
    _isFirst = YES;
    
}




@end
