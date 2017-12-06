//
//  AddressBookDetailVC.m
//  Template
//
//  Created by Apple on 2017/10/21.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "AddressDetailVC.h"
#import "AddressBookDetailVC.h"

#import <MessageUI/MFMessageComposeViewController.h>

#import "AddressBookDetailCell.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "NSString+MakeCall.h"



static NSString *const  addressBookDetailCell = @"addressBookDetailCell";

@interface AddressDetailVC ()<MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,AddressBookDetailCellDelegate>

@property (nonatomic , strong ) AddressBookModel * model ;

@property (nonatomic , strong ) NSIndexPath * indexPath ;

@property (nonatomic , strong ) UITableView * tableView ;


//@property (nonatomic , strong ) AddressBookUserList * list ;


@property (nonatomic , strong ) NSMutableArray * phoneArray ;

@property (nonatomic , strong ) UIView * topView ;



@end

@implementation AddressDetailVC{
    
    
    
    UIView*_bigView;
    UIView*_detailView;
    UILabel*_nameLabel;
    UIButton*_rightBtn;
    UIImageView*_rightImg;
    UIView*_line1;
    UIImageView*_icon;
    
    UILabel*_phoneNum1;
    UILabel*_detailLabel1;
    UIImageView*_rightImg1;
    UIView*_line2;
    
    UILabel*_phoneNum2;
    UILabel*_detailLabel2;
    UIImageView*_rightImg2;
    UIView*_line3;
    
    
    UILabel*_phoneNum3;
    UILabel*_detailLabel3;
    
    
    BOOL _isOne;
    
    
    UIView*_tapView;
    
    //add
    UIButton*_homeBtn;
    UILabel*_titleLabel;
    UIButton*_rightBtn2;
    UILabel*_nameLabel2;
    UILabel*_groupLabel;
    
}

- (void)setName:(NSString *)name{
    
    _name = name;
    
    if (name != nil) {
        
        _groupLabel.text = name;
        
    }
    
    
    
    
}

- (void)setList:(AddressBookUserList *)list{
    
    _list = list;

    
    _phoneArray = [NSMutableArray array];
    
        @weakify(self);
        [_list.mj_keyValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            @strongify(self);
            
            NSLog(@"key == %@, obj == %@",key,obj);
            
            
            if ([obj isKindOfClass:[NSString class]]) {
                
                
                
                if (((NSString*)obj).length>0) {
                    
                    
                    
                    NSMutableDictionary*dict = [NSMutableDictionary dictionary];
                    
                    
                    
                    if ([key isEqualToString: @"MobileNumber"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeUserOne);
                        
                        dict[@"phone"] = obj;
                        
                        
                        [self.phoneArray addObject:dict];
                        
                    }
                    
                    if ([key isEqualToString: @"MobileNumber2"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeUserTwo);
                        
                        dict[@"phone"] = obj;
                        
                        [self.phoneArray addObject:dict];
                    }
                    
                    
                    if ([key isEqualToString: @"HomeNumber"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeHome);
                        dict[@"phone"] = obj;
                        
                        [self.phoneArray addObject:dict];
                        
                    }
                    
                    
                    if ([key isEqualToString: @"OfficeNumber"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeOffice);
                        
                        dict[@"phone"] = obj;
                        
                        [self.phoneArray addObject:dict];
                    }
                    
                    if ([key isEqualToString: @"ShortNumber"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeShort);
                        dict[@"phone"] = obj;
                        
                        [self.phoneArray addObject:dict];
                        
                    }
                    
                    if ([key isEqualToString: @"Email"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeMessage);
                        
                        dict[@"phone"] = obj;
                        
                        [self.phoneArray addObject:dict];
                    }
                    
                    if ([key isEqualToString: @"Address"]) {
                        
                        
                        dict[@"type"]=@(PhoneTypeAddress);
                        
                        dict[@"phone"] = obj;
                        
                        [self.phoneArray addObject:dict];
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            
        }];
    
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
    
    [self.phoneArray sortUsingDescriptors:sortDescriptors];
    
    NSLog(@"排序后的数组%@",self.phoneArray);
    
    
    [_tableView reloadData];
    

    
            
    
}


- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
    
    if(_model.data.count>indexPath.section&&_model.data[indexPath.section].UserList.count>indexPath.row) {
        
        AddressBookUserList*list = _model.data[indexPath.section].UserList[indexPath.row];
        
        _list = list;
        
        
        _phoneArray = [NSMutableArray array];
        
        if (_model !=nil) {
            @weakify(self);
            [_list.mj_keyValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                @strongify(self);
                
                NSLog(@"key == %@, obj == %@",key,obj);
                
                
                if ([obj isKindOfClass:[NSString class]]) {
                    
                    
                    
                    if (((NSString*)obj).length>0) {
                        
                        
                        
                        NSMutableDictionary*dict = [NSMutableDictionary dictionary];
                        
                        
                        
                        if ([key isEqualToString: @"MobileNumber"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeUserOne);
                            
                            dict[@"phone"] = obj;
                            
                            
                            [self.phoneArray addObject:dict];
                            
                        }
                        
                        if ([key isEqualToString: @"MobileNumber2"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeUserTwo);
                            
                            dict[@"phone"] = obj;
                            [self.phoneArray addObject:dict];
                        }
                        
                        
                        if ([key isEqualToString: @"HomeNumber"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeHome);
                            dict[@"phone"] = obj;
                            
                            [self.phoneArray addObject:dict];
                            
                        }
                        
                        
                        if ([key isEqualToString: @"OfficeNumber"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeOffice);
                            
                            dict[@"phone"] = obj;
                            
                            [self.phoneArray addObject:dict];
                        }
                        
                        if ([key isEqualToString: @"ShortNumber"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeShort);
                            dict[@"phone"] = obj;
                            
                            [self.phoneArray addObject:dict];
                            
                        }
                        
                        if ([key isEqualToString: @"Email"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeMessage);
                            
                            dict[@"phone"] = obj;
                            
                            [self.phoneArray addObject:dict];
                        }
                        
                        if ([key isEqualToString: @"Address"]) {
                            
                            
                            dict[@"type"]=@(PhoneTypeAddress);
                            
                            dict[@"phone"] = obj;
                            
                            [self.phoneArray addObject:dict];
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }];
            
            
            
            
        }
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES]];
        [self.phoneArray sortUsingDescriptors:sortDescriptors];
        NSLog(@"排序后的数组%@",self.phoneArray);
        
        
        [_tableView reloadData];
        
        if (list.UserName!=nil) {
            
            
            _nameLabel.text = list.UserName;
            
        }
        
        if (list.MobileNumber!=nil) {
            
            _phoneNum1.text = list.MobileNumber;
            
        }
        
        if (list.ShortNumber != nil) {
            
            _phoneNum2.text = list.ShortNumber;
            
        }
        
        
        if (list.HomeNumber != nil) {
            
            
            _phoneNum3.text = list.HomeNumber;
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // self.navigationController.navigationBar.hidden=NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationItem.title = @"详情";
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
    
    
    
    
    
    
}

- (void)configNav{}
- (void)creatUI{
    
    self.view.backgroundColor = [UIColor colorWithHex:0xdcdcdc alpha:0.8];
    
    
    
    
    
    _bigView = [UIView new];
//    _bigView.backgroundColor = [UIColor colorWithHex:0xdcdcdc alpha:0];
//    _bigView.backgroundColor = [UIColor redColor];
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor colorWithHex:0x2badda ];
    
    [_bigView addSubview:_topView];
    
 
    
    _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homeBtn setBackgroundImage:[UIImage imageWithFileName:@"返回"] forState:UIControlStateNormal];
    
    @weakify(self);
    [[_homeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    _rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn2 setBackgroundImage:[UIImage imageWithFileName:@""] forState:UIControlStateNormal];
    
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"通讯录";
    _titleLabel.textColor = [UIColor colorWithHex:0xffffff];
    _titleLabel.font = [UIFont systemFontOfSize:kfont(20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _nameLabel2 = [UILabel new];
    if (_list.UserName != nil) {
        
        _nameLabel2.text = _list.UserName;
    }
    
    _nameLabel2.textColor = [UIColor colorWithHex:0xffffff];
    _nameLabel2.font = [UIFont systemFontOfSize:kfont(18)];
    
    
    _groupLabel = [UILabel new];
    
    if (_name != nil) {
        _groupLabel.text = _name;
    }
    
    _groupLabel.textColor = [UIColor colorWithHex:0xffffff];
    _groupLabel.font = [UIFont systemFontOfSize:kfont(16)];
    
    
    [_topView addSubview:_homeBtn];
    [_topView addSubview:_titleLabel];
    [_topView addSubview:_nameLabel2];
    [_topView addSubview:_rightBtn2];
    [_topView addSubview:_groupLabel];
    
    
    
    UITapGestureRecognizer*tap100 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSomething:)];
    _bigView.userInteractionEnabled = YES;
    [_bigView addGestureRecognizer:tap100];
    
    
    
    _detailView = [UIView new];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer*tap102 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doNothing:)];
    _detailView.userInteractionEnabled = YES;
    [_detailView addGestureRecognizer:tap102];
    
    
    
    _nameLabel=[UILabel new];
    _nameLabel.text=@"";
    _nameLabel.textColor=[UIColor colorWithHex:0xff8c00];
    _nameLabel.font=[UIFont systemFontOfSize:kfont(18)];
    
    _rightImg = [UIImageView new];
    _rightImg.image = [UIImage imageWithFileName:@"down"];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn addTarget:self action:@selector(hideSomething:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSomething:)];
    //    _rightImg.userInteractionEnabled=YES;
    //    [_rightImg addGestureRecognizer:tap];
    
    _line1 = [UIView new];
    _line1.backgroundColor = [UIColor colorWithHex:0xbbbbbb];
    
    _icon = [UIImageView new];
    _icon.image = [UIImage imageWithFileName:@"手机"];
    
    
    _phoneNum1=[UILabel new];
    _phoneNum1.text=@"";
    _phoneNum1.textColor=[UIColor colorWithHex:0x000000];
    _phoneNum1.font=[UIFont systemFontOfSize:kfont(16)];
    
    
    _detailLabel1=[UILabel new];
    _detailLabel1.text=@"手机";
    _detailLabel1.textColor=[UIColor colorWithHex:0x888888];
    _detailLabel1.font=[UIFont systemFontOfSize:kfont(15)];
    
    
    _rightImg1 = [UIImageView new];
    _rightImg1.image = [UIImage imageWithFileName:@"短信"];
    
    
    _line2 = [UIView new];
    _line2.backgroundColor = [UIColor colorWithHex:0xcccccc];
    
    
    _phoneNum2=[UILabel new];
    _phoneNum2.text=@"";
    _phoneNum2.textColor=[UIColor colorWithHex:0x000000];
    _phoneNum2.font=[UIFont systemFontOfSize:kfont(16)];
    
    
    _detailLabel2=[UILabel new];
    _detailLabel2.text=@"短号";
    _detailLabel2.textColor=[UIColor colorWithHex:0x888888];
    _detailLabel2.font=[UIFont systemFontOfSize:kfont(15)];
    
    
    _rightImg2 = [UIImageView new];
    _rightImg2.image = [UIImage imageWithFileName:@"短信"];
    
    
    _line3 = [UIView new];
    _line3.backgroundColor = [UIColor colorWithHex:0xcccccc];
    
    
    
    _phoneNum3 = [UILabel new];
    _phoneNum3.text=@"";
    _phoneNum3.textColor=[UIColor colorWithHex:0x000000];
    _phoneNum3.font=[UIFont systemFontOfSize:kfont(16)];
    
    
    _detailLabel3=[UILabel new];
    _detailLabel3.text=@"座机";
    _detailLabel3.textColor=[UIColor colorWithHex:0x888888];
    _detailLabel3.font=[UIFont systemFontOfSize:kfont(15)];
    
    _tapView = [UIView new];
    
    UITapGestureRecognizer*tap12 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSomething:)];
    _tapView.userInteractionEnabled=YES;
    [_tapView addGestureRecognizer:tap12];
    
    
    
    [self.view addSubview:_bigView];
    
    [_bigView addSubview:_detailView];
    
    [_detailView addSubview:_nameLabel];
    [_detailView addSubview:_rightImg];
    [_detailView addSubview:_rightBtn];
    [_detailView addSubview:_line1];
    [_detailView addSubview:_icon];
    [_detailView addSubview:_phoneNum1];
    [_detailView addSubview:_detailLabel1];
    [_detailView addSubview:_rightImg1];
    [_detailView addSubview:_line2];
    
    [_detailView addSubview:_phoneNum2];
    [_detailView addSubview:_detailLabel2];
    [_detailView addSubview:_rightImg2];
    [_detailView addSubview:_line3];
    
    [_detailView addSubview:_phoneNum3];
    [_detailView addSubview:_detailLabel3];
    
    [_detailView addSubview:_tapView];
    
    //
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhone:)];
    _phoneNum1.userInteractionEnabled=YES;
    [_phoneNum1 addGestureRecognizer:tap1];
    _phoneNum1.tag = 1;
    
    
    UITapGestureRecognizer*tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhone:)];
    _phoneNum2.userInteractionEnabled=YES;
    [_phoneNum2 addGestureRecognizer:tap2];
    _phoneNum2.tag = 2;
    
    UITapGestureRecognizer*tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhone:)];
    _phoneNum3.userInteractionEnabled=YES;
    [_phoneNum3 addGestureRecognizer:tap3];
    _phoneNum3.tag = 3;
    
    UITapGestureRecognizer*tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMessage:)];
    _rightImg1.userInteractionEnabled=YES;
    [_rightImg1 addGestureRecognizer:tap4];
    _rightImg1.tag = 4;
    
    
    UITapGestureRecognizer*tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMessage:)];
    _rightImg2.userInteractionEnabled=YES;
    [_rightImg2 addGestureRecognizer:tap5];
    _rightImg2.tag = 5;
    
    
    
    
    
    
    //tableView
    // Do any additional setup after loading the view.
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width,kph(1080/3.f)-kph(44/3.f)-kph(40/3.f)-kph(20)) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    
    _tableView.estimatedRowHeight=aph(40);
    _tableView.rowHeight=UITableViewAutomaticDimension;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _tableView.emptyDataSetDelegate=self;
    _tableView.emptyDataSetSource=self;
    
    
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerClass:[AddressBookDetailCell class] forCellReuseIdentifier:addressBookDetailCell];
    
    
    [_detailView addSubview:_tableView];
    
    
}
- (void)layout{
    
    
    
    
    [_bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(@0);
        
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.equalTo(@0);
        
        make.height.equalTo(@(kph(200)));
        
        
    }];
    
    [_homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(40/3.f)));
        
        make.top.equalTo(@((kStatusHeight+5)));
        
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_bigView.mas_centerX);
        
        //        make.top.equalTo(@(kStatusHeight));
        
        make.centerY.equalTo(_homeBtn.mas_centerY);
        
    }];
    
    [_rightBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_homeBtn.mas_centerY);
        
        make.right.equalTo(@(kpt(-15)));
        
        
    }];
    
    
    [_nameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(kpt(45)));
        
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(kph(60));
        
        
    }];
    
    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nameLabel2.mas_left);
        
        make.top.equalTo(_nameLabel2.mas_bottom).with.offset(kph(8));
        
       
        
    }];
    
    
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.right.bottom.equalTo(@0);
        
//        make.height.equalTo(@(kph(1080/3.f)));
        make.top.equalTo(_topView.mas_bottom).with.offset(kph(0));
        
        
        
    }];
    
    
//
//
//
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@(kpt(50/3.f)));
//        make.top.equalTo(@(kph(40/3.f)));
//        make.height.equalTo(@(kph(20)));
//
//    }];
//
//    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(_nameLabel.mas_centerY);
//        make.right.equalTo(@(kpt(-40/3.f)));
//
//
//
//
//    }];
//
//    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(@0);
//        make.centerY.equalTo(_nameLabel.mas_centerY);
//        make.width.equalTo(@(kpt(50)));
//        make.height.equalTo(@(kph(148/3.f)));
//
//
//    }];
//
//    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.right.equalTo(@0);
//        make.top.equalTo(_nameLabel.mas_bottom).with.offset(kph(44/3.f));
//        make.height.equalTo(@(kph(1)));
//
//    }];
//
//
//    [_tapView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@0);
//        make.top.equalTo(@0);
//        make.right.equalTo(@0);
//        make.bottom.equalTo(_line1.mas_bottom);
//
//
//    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        
        make.top.equalTo(@0);
        
//        make.height.equalTo(@(kph(1080/3.f)-kph(44/3.f)-kph(40/3.f)-kph(20)));
        make.bottom.equalTo(@0);
        
        
    }];
    
    
//    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_nameLabel.mas_left);
//        //        make.top.equalTo(_line1.mas_bottom).with.offset(kph(30/3.f));
//        make.centerY.equalTo(_rightImg1.mas_centerY);
//
//        make.width.height.equalTo(@(kfont(75/3.f)));
//
//
//    }];
//
//
//    [_phoneNum1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_icon.mas_right).with.offset(kpt(43/3.f));
//        //        make.centerY.equalTo(_icon.mas_centerY);
//        make.top.equalTo(_line1.mas_bottom).with.offset(kph(32/3.f));
//
//
//
//    }];
//
//    [_detailLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_phoneNum1.mas_left);
//        make.top.equalTo(_phoneNum1.mas_bottom).with.offset(kph(18/3.f));
//
//        make.height.equalTo(@(kph(20)));
//
//
//    }];
//
//    [_rightImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(_line1.mas_bottom).with.offset(kph(58/3.f));
//        make.right.equalTo(@(kpt(-40/3.f)));
//
//
//    }];
//
//    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_phoneNum1.mas_left);
//        make.right.equalTo(@0);
//        make.top.equalTo(_detailLabel1.mas_bottom).with.offset(kph(37/3.f));
//        make.height.equalTo(@(kph(1)));
//
//
//    }];
//
//    [_phoneNum2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_phoneNum1.mas_left);
//
//        make.top.equalTo(_line2.mas_bottom).with.offset(kph(32/3.f));
//
//        make.height.equalTo(@(kph(20)));
//
//    }];
//
//    [_detailLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_phoneNum1.mas_left);
//        make.top.equalTo(_phoneNum2.mas_bottom).with.offset(kph(18/3.f));
//
//        make.height.equalTo(@(kph(20)));
//
//    }];
//
//
//    [_rightImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(_line2.mas_bottom).with.offset(kph(58/3.f));
//        make.right.equalTo(@(kpt(-40/3.f)));
//
//    }];
//
//
//    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_phoneNum1.mas_left);
//        make.right.equalTo(@0);
//        make.top.equalTo(_detailLabel2.mas_bottom).with.offset(kph(37/3.f));
//        make.height.equalTo(@(kph(1)));
//
//    }];
//
//
//    [_phoneNum3 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(_phoneNum1.mas_left);
//
//        make.top.equalTo(_line3.mas_bottom).with.offset(kph(32/3.f));
//
//        make.height.equalTo(@(kph(20)));
//
//
//    }];
//
//
//    [_detailLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
//
//
//        make.left.equalTo(_phoneNum1.mas_left);
//        make.top.equalTo(_phoneNum3.mas_bottom).with.offset(kph(18/3.f));
//
//        make.height.equalTo(@(kph(20)));
//
//    }];
//
//
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
- (void)getData{}





+ (AddressBookDetailVC*)shareInstance{
    
    static AddressBookDetailVC*addressBookDetailVC = nil;
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addressBookDetailVC = [AddressBookDetailVC new];
        
    });
    
    
    return addressBookDetailVC;
    
    
}


+ (void)showDetailViewWith:(AddressBookModel*)model indexPath:(NSIndexPath*)indexPath{
    
    AddressBookDetailVC*addressBookDetailVC = [AddressBookDetailVC shareInstance];
    
    
    addressBookDetailVC.view.tag=1000;
    
    
//    addressBookDetailVC.model = model;
//
//    addressBookDetailVC.indexPath = indexPath;
    
    
    
    
    
    
    
    
    
    
    
    [[[[UIApplication sharedApplication]delegate]window] addSubview:addressBookDetailVC.view];
    
    //[AddressBookDetailVC shareInstance].view.hidden = NO;
    
}




+ (void)hide{
    
    
    
    [[[[[UIApplication sharedApplication]delegate]window] viewWithTag:1000] removeFromSuperview];
    //    [AddressBookDetailVC shareInstance].view.hidden = YES;
    
    
    
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //    [AddressBookDetailVC hide];
    
    
    
}


- (void)hideSomething:(UITapGestureRecognizer*)tap{
    
    [AddressBookDetailVC hide];
    
    
}

- (void)sendMessage:(UITapGestureRecognizer*)tap{
    
    NSLog(@"发送短信");
    
    if (tap.view.tag  == 4) {
        
        
        [self sendSMS:@"" recipientList:@[_phoneNum1.text]];
        
    }else{
        
        
        [self sendSMS:@"" recipientList:@[_phoneNum2.text]];
        
    }
    
    
    
    
}

- (void)sendMessage:(NSString*)message phoneNum:(NSString*)phoneNum{
    
    
    
    
    
}


- (void)openPhone:(UITapGestureRecognizer*)tap{
    
    
    
    UIWebView*   phoneCallWebView = [UIWebView new];
    
    NSString*phoneNum = _phoneNum1.text;
    
    NSURL *phoneURL;
    
    switch (tap.view.tag) {
        case 1:
        {
            
            phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum1.text]];
        }
            break;
            
        case 2:
        {
            phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum2.text]];
            
        }
            break;
            
        case 3:
        {
            
            phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_phoneNum3.text]];
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    if ( !phoneCallWebView && ![phoneNum isEqualToString:@""]) {
        
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    
    //记得添加到view上
    [self.view addSubview:phoneCallWebView];
    
}

//调用sendSMS函数
//内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentModalViewController:controller animated:YES];
        
    }
    
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled){
        NSLog(@"Message cancelled")
    }else if (result == MessageComposeResultSent){
        NSLog(@"Message sent")
        
    }
    else{
        NSLog(@"Message failed")
        
    }
    
}





#define mark  tableView datasource and delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return kph(55);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_phoneArray.count!=0) {
        
        
        
        return _phoneArray.count;
    }
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressBookDetailCell*cell = [tableView dequeueReusableCellWithIdentifier:addressBookDetailCell];
    
    if (_phoneArray.count!=0) {
        
        if (indexPath.row == 0) {
            
            cell.isOne = YES;
            
        }else{
            
            
            cell.isOne = NO;
            
        }
        
        
        cell.dict = _phoneArray[indexPath.row];
        
        
    }
    
    
    cell.delegate=self;
    
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    
    
    
    
    
}

- (void)changeThing:(AddressBookDetailCell*)cell{
    
    if (_list.Address != nil) {
        
        cell.type = PhoneTypeAddress;
    }
    
    if (_list.Email!=nil) {
        
        cell.type = PhoneTypeMessage;
    }
    
    if (_list.OfficeNumber!=nil) {
        
        cell.type = PhoneTypeOffice;
    }
    
    if (_list.HomeNumber!=nil) {
        
        cell.type = PhoneTypeHome;
        
    }
    
    if (_list.ShortNumber!=nil) {
        
        cell.type = PhoneTypeShort;
    }
    
    if (_list.MobileNumber2!=nil) {
        
        cell.type = PhoneTypeUserTwo;
        
    }
    
    if (_list.MobileNumber!=nil) {
        
        cell.type = PhoneTypeUserOne;
        
    }
    
    
    
}

- (void)doNothing:(UITapGestureRecognizer*)tap{
    
    
    NSLog(@"什么都不做");
    
    
}


#pragma mark - DZNEmptyDataSetSource
// 返回图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    
    
    
    
    return  nil;
    
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

// 返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    //    NSString *text = @"这是一张空白页";
    NSString*text=@"无记录";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

#pragma  mark AddressBookDetailCellDelegate

- (void)sendMessageToPhone:(NSString *)numStr{
    
    
    [self sendSMS:@"" recipientList:@[numStr]];
    
    
    
}

- (void)callPhone:(NSString *)numStr{
    
    [numStr WZ_makeCall:^(BOOL success) {
        //点击了呼叫按钮了，回调会返回成功标示
        
        
        NSLog(@"拨打电话成功");
        
        
    }];
    
    
    //    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",numStr];
    //
    //                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:numStr preferredStyle:UIAlertControllerStyleAlert];
    //
    //                          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //
    //    }];
    //
    //                          UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //
    //                              NSLog(@"呼叫");
    //    }];
    //
    //                          // Add the actions.
    //      [alertController addAction:cancelAction];
    //      [alertController addAction:otherAction];
    //
    //    [self presentViewController:alertController animated:YES completion:nil];
    //
    
    
    NSLog(@"调用打电话方法");
}


- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder* next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}




@end

