//
//  AddressBookDetailCell.m
//  Template
//
//  Created by Apple on 2017/10/28.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "AddressBookDetailCell.h"

@implementation AddressBookDetailCell{
    
    UIImageView*_icon;
    UILabel*_label1;
    UILabel*_label2;
    UIImageView*_rightImg;
    UIView*_bottomView;
    
}

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    

    
    if ([dict.allKeys containsObject:@"phone"]) {
        
        NSString *phoneStr =  dict[@"phone"] ;
        

        if ([dict.allKeys containsObject:@"type"]) {
            
            NSNumber *type =  dict[@"type"] ;
            
            _icon.image = nil;
            
            _rightImg.image =nil;
            
            _type = [type integerValue];
            
            switch ([type integerValue]) {
                case PhoneTypeHome:
                {
                    
                    
                    //                    _icon.image = [UIImage imageWithFileName:@"手机"];
                    
                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"家庭";
                    
                    
                    
                    
                }
                    break;
                case PhoneTypeShort:
                {
                    
//                    _icon.image = [UIImage imageWithFileName:@"手机"];
                    
                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"短号";
                    
                    
                }
                    break;
                case PhoneTypeOffice:
                {
                    //                    _icon.image = [UIImage imageWithFileName:@"手机"];
                    
                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"座机";
                    
                    
                }
                    break;
                case PhoneTypeMessage:
                {
                    
                     _icon.image = [UIImage imageWithFileName:@"邮箱-(2)"];
                    
//                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"邮件";
                    
                }
                    break;
                case PhoneTypeAddress:
                {
                    
                    _icon.image = [UIImage imageWithFileName:@"地址"];
                    
//                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"地址";
                    
                }
                    break;
                case PhoneTypeUserOne:
                {
                    
                    _icon.image = [UIImage imageWithFileName:@"电话"];
                    
                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"手机";
                    
                    
                    
                }
                    break;
                    
                case PhoneTypeUserTwo:
                {
//                    _icon.image = [UIImage imageWithFileName:@"手机"];
                    
                    _rightImg.image = [UIImage imageWithFileName:@"短信通道保护"];
                    
                    
                    _label2.text =@"手机";
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
            _label1.text = phoneStr;
            
            
            if (_isOne) {
             
                
                _icon.image = [UIImage imageWithFileName:@"电话"];
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
}

- (void)setIsOne:(BOOL)isOne{
    
    _isOne = isOne;
    

    
}


- (void)setModel:(AddressBookUserList *)model{
    
    _model = model;
    
//    _icon.image = [UIImage imageWithFileName:@""];
//    _rightImg.image = [UIImage imageWithFileName:@""];
    
    
    
    
    
    
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        [self layout];
    }
    
    return self;
    
}
- (void)creatUI{
    
    _icon = [UIImageView new];
    
    _label1=[UILabel new];
    _label1.text=@"";
    _label1.textColor=[UIColor colorWithHex:0x000000];
    _label1.font=[UIFont systemFontOfSize:kfont(16)];
    
    
    _label2=[UILabel new];
    _label2.text=@"";
    _label2.textColor=[UIColor colorWithHex:0x888888];
    _label2.font=[UIFont systemFontOfSize:kfont(12)];
    
    
    _rightImg = [UIImageView new];
    _rightImg.image = [UIImage imageWithFileName:@""];
    
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    
    
    [self.contentView addSubview:_icon];
    [self.contentView addSubview:_label1];
    [self.contentView addSubview:_label2];
    [self.contentView addSubview:_rightImg];
    [self.contentView addSubview:_bottomView];
    
    

    
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhone:)];
    _label1.userInteractionEnabled=YES;
    [_label1 addGestureRecognizer:tap1];
    _label1.tag = 1;
    
    
    UITapGestureRecognizer*tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMessage:)];
    _rightImg.userInteractionEnabled=YES;
    [_rightImg addGestureRecognizer:tap5];
    _rightImg.tag = 5;
    
    
    
    
    
    
    
    
    
}
- (void)layout{
    
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(kpt(50/3.f));
        //        make.top.equalTo(_line1.mas_bottom).with.offset(kph(30/3.f));
        make.centerY.equalTo(self.contentView.mas_centerY);
        
        make.width.equalTo(@(kfont(75/3.f)));
        
        
    }];
    
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_icon.mas_right).with.offset(kpt(43/3.f));
        //        make.centerY.equalTo(_icon.mas_centerY);
        make.top.equalTo(@(kph(32/3.f)));
        
        
        
    }];
    
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_label1.mas_left);
        make.top.equalTo(_label1.mas_bottom).with.offset(kph(10/3.f));
        
        make.height.equalTo(@(kph(20)));
        
        
    }];
    
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.top.equalTo(@(kph(58/3.f)));
        make.centerY.equalTo(_icon.mas_centerY);
        make.right.equalTo(@(kpt(-40/3.f)));
        
        
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_label1.mas_left);
        make.right.equalTo(@0);
//        make.top.equalTo(_label2.mas_bottom).with.offset(kph(37/3.f));
        make.bottom.equalTo(@0);
        make.height.equalTo(@(kph(1)));
        
        
    }];
    
    
    
}


- (void)openPhone:(UITapGestureRecognizer*)tap{
    
    if (_type == PhoneTypeMessage || _type == PhoneTypeAddress) {
        
        return;
    }
    
    
    
//    UIWebView*   phoneCallWebView = [UIWebView new];
    
    NSString*phoneNum = _label1.text;
    
    if ([_delegate respondsToSelector:@selector(callPhone:)]) {
        [_delegate callPhone:phoneNum];
    }
    
    
//    NSURL *phoneURL;
//
//    phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
//
//
//
//    if ( !phoneCallWebView && ![phoneNum isEqualToString:@""]) {
//
//        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
//
//    }
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//
//
//    //记得添加到view上
//    [self.contentView addSubview:phoneCallWebView];
    
    
//    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
//
//
//    NSComparisonResult compare = [[UIDevice currentDevice].systemVersion compare:@"10.0"];
//
//    if (compare == NSOrderedDescending || compare == NSOrderedSame) {
//        /// 大于等于10.0系统使用此openURL方法
//        if (@available(iOS 10.0, *)) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
//        } else {
//            // Fallback on earlier versions
//        }
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
//    }
    
//    NSMutableString  * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}



- (void)sendMessage:(UITapGestureRecognizer*)tap{
    
    NSLog(@"发送短信通道保护");
    
//   [self sendSMS:@"" recipientList:@[_label1.text]];
    
    if ([_delegate respondsToSelector:@selector(sendMessageToPhone:)]) {
        
        [_delegate sendMessageToPhone:_label1.text];
        
    }
    
    
    
    
}


- (void)setDelegate:(id<AddressBookDetailCellDelegate>)delegate{
    
    _delegate = delegate;
    
    
    
    
    
    
}















@end
