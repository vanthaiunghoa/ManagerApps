//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#define T10   [UIColor colorWithHex:0x000000]

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    if (@available(iOS 11.0, *)) {
        
        
        view=[MBProgressHUD getView];
        
       
        
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
//    hud.margin=30.f;
    
    
    
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = hud.label.textColor;
    hud.detailsLabel.font = hud.label.font;
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 自定义分享成功弹框
+(MBProgressHUD*)showAddexp:(NSString*)exep andMoney:(NSString*)money  andCoin:(NSString*)coin andType:(NSInteger)type icon:(NSString *)icon view:(UIView *)view{
//加号都在外面  做的.

    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    
    if (@available(iOS 11.0, *)) {
        
        
        view=[MBProgressHUD getView];
        
    }

    MBProgressHUD*hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    
    //
    UIView*bigView=[UIView new];
    
    
    UIImageView*iconImg=[UIImageView new];
    
    icon=@"success.png";
    
    iconImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
    
    UILabel*label1=[UILabel new];
    
    label1.textColor=T10;
    label1.font=[UIFont systemFontOfSize:kfont(30/2.f)];
    
    label1.numberOfLines=0;
    
    label1.textAlignment=NSTextAlignmentCenter;
    
//    眼金金币领取+ 60
//    现金红包领取 +0.05元
    
    CGFloat height=200;
    
    if (type==1) {
        
        label1.text=[NSString stringWithFormat:@"眼金金币领取%@",exep];
        
        NSMutableAttributedString*string1=[[NSMutableAttributedString alloc]initWithString:label1.text];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:T10 range:NSMakeRange(0, 6)];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffcc00] range:NSMakeRange(6, label1.text.length-6)];
        
        label1.attributedText=string1;
        
        
        
      
        CGSize labelSize = [label1 sizeThatFits:CGSizeMake(kpt(150/2.f), MAXFLOAT)];
        
        height = ceil(labelSize.height) + kph(30);
      
        //金币 经验  金钱
        
        
    }else if(type==2){
        
        ReleseLog(@"%@",exep);
    
//        if (exep.length>1) {
//            exep=[exep substringWithRange:NSMakeRange(1, exep.length-1)];
//        }
//    
//        
//        exep=[NSString stringWithFormat:@"+%@",[NSString pennyToYuan:exep]];
        
        label1.text=[NSString stringWithFormat:@"现金红包领取%@元",exep];
        
        NSMutableAttributedString*string1=[[NSMutableAttributedString alloc]initWithString:label1.text];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:T10 range:NSMakeRange(0, 6)];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffcc00] range:NSMakeRange(6, label1.text.length-6)];
        
        
        label1.attributedText=string1;
        
        CGSize labelSize = [label1 sizeThatFits:CGSizeMake(kpt(150/2.f), MAXFLOAT)];
        
        height = ceil(labelSize.height) + kph(15);
        
    
    }if(type==3){
        
//        if (exep.length>1) {
//            
//            exep=[exep substringWithRange:NSMakeRange(1, money.length-1)];
//        }
//        
//        exep=[NSString stringWithFormat:@"+%@",exep];
        
        label1.text=[NSString stringWithFormat:@"眼金金币领取%@\n经验获取%@",coin,exep];
        
        NSMutableAttributedString*string1=[[NSMutableAttributedString alloc]initWithString:label1.text];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:T10 range:NSMakeRange(0, 6)];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffcc00] range:NSMakeRange(6,coin.length)];
        
        
        [string1 addAttribute:NSForegroundColorAttributeName value:T10 range:NSMakeRange(6+coin.length+1, 4)];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffcc00] range:NSMakeRange(11+coin.length,money.length)];
        
        
        NSMutableParagraphStyle*style=[[NSMutableParagraphStyle alloc]init];
        
        style.lineSpacing=kph(10/2.f);
        
        style.alignment=NSTextAlignmentCenter;
        
        
        [string1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, label1.text.length)];
        
        
        label1.attributedText=string1;
        
        
        CGSize labelSize = [label1 sizeThatFits:CGSizeMake(kpt(150/2.f), MAXFLOAT)];
        
        height = ceil(labelSize.height) + 1;
        
        
    }if(type==4){//单独经验
        
    
    
    
    
        label1.text=[NSString stringWithFormat:@"经验获取%@",exep];
        
        NSMutableAttributedString*string1=[[NSMutableAttributedString alloc]initWithString:label1.text];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:T10 range:NSMakeRange(0, 4)];
        
        [string1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffcc00] range:NSMakeRange(4, label1.text.length-4)];
        
        label1.attributedText=string1;
        
        
        
        
        CGSize labelSize = [label1 sizeThatFits:CGSizeMake(kpt(150/2.f), MAXFLOAT)];
        
        height = ceil(labelSize.height) + kph(15);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    }
    
    
  

    
    
    UILabel*label2=[UILabel new];
    
    label2.text=[NSString stringWithFormat:@"经验%@",exep];
    label2.textColor=T10;
    label2.font=[UIFont systemFontOfSize:kfont(30/2.f)];
    
    
    NSMutableAttributedString*string2=[[NSMutableAttributedString alloc]initWithString:label2.text];
    [string2 addAttribute:NSForegroundColorAttributeName value:T10 range:NSMakeRange(0, 2)];
    [string2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xffcc00] range:NSMakeRange(2, label2.text.length-2)];
    
    label2.attributedText=string2;
    
    


    UILabel*label3=[UILabel new];
    label3.text=[NSString stringWithFormat:@"分享成功"];
    label3.textColor=T10;
    label3.font=[UIFont systemFontOfSize:kfont(24/2.f)];


    [bigView addSubview:iconImg];
    [bigView addSubview:label1];
    [bigView addSubview:label2];
    [bigView addSubview:label3];

    label2.hidden=YES;
    label3.hidden=YES;
    
    
    
    bigView.frame=CGRectMake(0, 0, kpt(190/1.f), (kph(20/1.f)+height));
    
    
    
    
    
    
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(bigView.mas_centerX);
        
        make.top.equalTo(@(kph(11/1.f)));
        
        
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.right.equalTo(iconImg.mas_centerX).with.offset(kpt(-4.5/1.f));
        
        make.top.equalTo(iconImg.mas_bottom).with.offset(kph(9/1.f));
        
//         make.centerX.equalTo(bigView.mas_centerX);
        
        
        make.left.equalTo(@(kpt(10)));
        
        
        make.right.equalTo(@(kpt(-10)));
        
        
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconImg.mas_centerX).with.offset(kpt(4.5/1.f));
        
        make.top.equalTo(iconImg.mas_bottom).with.offset(kph(9/1.f));
        
        
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.centerX.equalTo(bigView.mas_centerX);
        
        make.top.equalTo(label2.mas_bottom).with.offset(kph(9/1.f));
        
        
    }];
    
     hud.color=[UIColor clearColor];
    
    bigView.backgroundColor=[UIColor colorWithHex:0x000000 alpha:0.8];
    
    bigView.layer.cornerRadius=kfont(10/2.f);
    
    bigView.clipsToBounds=YES;
    

    
    hud.customView=bigView;
    
    
    

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hide:YES afterDelay:2];
    
    [bigView.superview layoutIfNeeded];
    
     bigView.transform=CGAffineTransformMakeScale(0.3, 0.3);
    
 [UIView animateWithDuration:0.2 animations:^{
    
     bigView.transform=CGAffineTransformScale(bigView.transform, 3, 3);
     
//     CGAffineTransformMakeScale(3,3);
     
 }];
    
    
    return hud;
    
    
    
    

}


#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    if (@available(iOS 11.0, *)) {
        
        
        view=[MBProgressHUD getView];
        
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
    
//    return [self  showSomeThingAniType:AniTypeFive];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
//+(instancetype)showSomeThing{
//    
//    
//    
////    UIView*view = [[[UIApplication sharedApplication] delegate]window ];
////     NSLog(@"begin");
//    
//    UIView*view=[[UIApplication sharedApplication].windows lastObject];
//   
//    for (UIView*tmpView in[view subviews]) {
//        
////        NSLog(@"%@",tmpView);
//        if ([tmpView isKindOfClass:[MBProgressHUD class]]) {
//            return nil;
//        }
//        
//    }
////    NSLog(@"end");
//
//    
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
//    
//    CABasicAnimation *ban = [CABasicAnimation animation];
//    
//    ban.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
//    
//    ban.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3.5, 3.5, 1)];
//    
//    ban.duration = 1;
//    
//    //  self.layer.transform =
//    //  transform.scale表示等比例拉伸
//    //  transform按照参数比例拉伸
//    ban.keyPath = @"transform";
//    //执行完动画不删除动画
//    ban.removedOnCompletion = YES;
//    //保持最新状态
//    ban.fillMode = kCAFillModeForwards;
//    
//    // Set the custom view mode to show any view.
//    hud.mode = MBProgressHUDModeCustomView;
//    // Set an image view with a checkmark.
//    
//    UIImage *image = [[UIImage imageNamed:@"xiao_tu"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
//    
//    UIImageView*imgView=[[UIImageView alloc] initWithImage:image];
//
//    imgView.frame=CGRectMake(kpt(50), 0, imgView.frame.size.width, imgView.frame.size.height);
//    
//    ban.repeatCount=5;
//    
//    //如果通过keyPath设置了属性，后面的参数可以传nil
////    [imgView.layer addAnimation:ban forKey:nil];
////     [imgView2.layer addAnimation:ban forKey:nil];
//    
//    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kpt(233), kph(199))];
//    
//    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+kph(44), kpt(233), kpt(25))];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.text=@"开启餐饮 \"E\" 时代";
//    label.font=[UIFont systemFontOfSize:kpt(24)];
//    label.textColor=kRGBColorFromHex(0xff1bac31);
//    [view1 addSubview:label];
//    [view1 addSubview:imgView];
////    view1.backgroundColor=[UIColor clearColor];
//
//    [view1.layer addAnimation:ban forKey:nil];
//    
//    hud.customView =view1;
//    [hud setYOffset:-40];
//    [hud setXOffset:-kpt(30)];
//    // Looks a bit nicer if we make it square.
//    hud.square = YES;
//   
//    
//    hud.color=[UIColor whiteColor];
//    
////    hud.backgroundColor=kRGBColorFromHexBackground(0xff555555);
//    hud.backgroundColor=[UIColor whiteColor];
//
//    [hud hide:YES afterDelay:5];
////    UIView*view=[[UIApplication sharedApplication].windows lastObject];
//    
//    for (UIView*tmpView in[view subviews]) {
//        
//        //                            NSLog(@"%@",tmpView);
//        if ([tmpView isKindOfClass:[MBProgressHUD class]]) {
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [tmpView removeFromSuperview];
//            });
//            
//        }
//    }
//
//    
//    return hud;
//
//
//}

+(MBProgressHUD*)showSomeThingAniType:(AniType)AniType{

    NSLog(@"begin");
    
        UIView*view=[[UIApplication sharedApplication].windows lastObject];
//
//        for (UIView*tmpView in[view subviews]) {
//
//            NSLog(@"%@",tmpView);
//            if ([tmpView isKindOfClass:[MBProgressHUD class]]) {
//                return nil;
//            }
//
//        }
        NSLog(@"end");
    
    
    
//      MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view==nil?[[UIApplication sharedApplication].windows lastObject]:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    //    hud.minSize = CGSizeMake(165,90);//定义弹窗的大小
    
    
    hud.hidden=YES;

//    1，创建YYAnimatedImageView对象
    
//    YYAnimatedImageView *imageView=[YYAnimatedImageView new];
    
//    （1）直接通过url加载：
    
    NSString*a;
    
    switch (AniType) {
        case AniTypeDefault:
        {
            a=@"f";
            
//            return nil;
        
        }
//            break;
        case AniTypeOne:
        {
           a=@"f";
            
//              return nil;
        }
//            break;
        case AniTypeTwo:
        {
            a=@"f";
            
//              return nil;
        }
//            break;
        case AniTypeThree:
        {
            a=@"f";
            
//              return nil;
        }
//            break;
        case AniTypeFour:
        {
            a=@"f";
            
//              return nil;
        }
//            break;
        case AniTypeFive:
        {
            a=@"f";
            
            hud.hidden=NO;
        }
            break;

            
        default:
        
            break;
    }
    
//    NSURL *path = [[NSBundle mainBundle]URLForResource:a withExtension:@"gif"];
//
//    imageView.imageURL = path;
//
//  UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kpt(160/2.f), kph(180/2.f))];
////    UIView*view1=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [view1 setCenter:CGPointMake(kScreen_Width/2.f, kScreen_Height/2.f)];
//
//    [view1 addSubview:imageView];
//
//    imageView.frame=CGRectMake(0, 0, view1.frame.size.width, view1.frame.size.height);
    
//    imageView.backgroundColor=Kwhite;
//
//    hud.color=[UIColor clearColor];
//    //
////        hud.backgroundColor=kRGBColorFromHexBackground(0xff555555);
//    hud.backgroundColor=[UIColor colorWithHex:0xffffff alpha:1];
//        hud.backgroundColor=[UIColor whiteColor];
    
//     hud.customView =view1;
    
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(@(kScreen_Width/2.f));
//        make.centerY.equalTo(@(kScreen_Height/2.f));
//        make.width.height.equalTo(@(100));
//    }];
//    
//    
//    [imageView.superview layoutIfNeeded];
    
    
//    [hud hide:YES afterDelay:5];
    
    return hud;
}


+(MBProgressHUD *)showTextView:(NSString *)message{


    UIView*view=[[UIApplication sharedApplication].windows lastObject];
    
    for (UIView*tmpView in[view subviews]) {
        
        
        if ([tmpView isKindOfClass:[MBProgressHUD class]]) {
            return nil;
        }
        
    }
    
    
    //      MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view==nil?[[UIApplication sharedApplication].windows lastObject]:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    
    //    hud.minSize = CGSizeMake(165,90);//定义弹窗的大小
    
    
    
    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(kScreen_Width-kpt(300), 0, kpt(300), kph(300))];
    
    
    //    UIView*view1=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [view1 setCenter:CGPointMake(kScreen_Width/2.f, kScreen_Height/2.f)];
    
    
    hud.color=[UIColor clearColor];
    //
    hud.backgroundColor=kRGBColorFromHexBackground(0xff555555);
    
    
    hud.customView =view1;
    
 
    return hud;








}

+(MBProgressHUD*)showDetail:(NSString *)title Detail:(NSString *)detalText{

    UIView*view=[[UIApplication sharedApplication].windows lastObject];
    
    if (@available(iOS 11.0, *)) {
        
        
        view=[MBProgressHUD getView];
        
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
            hud.labelText =title;
    
    hud.detailsLabelText = detalText;
    
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    
    // 设置图片

    // 再设置模式
    
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];

    return hud;


}


+(UIView*)getView{
    
    
    
    UIWindow*window=[[[UIApplication sharedApplication]delegate]window];
    
    UIViewController*vc;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController*nav=(UINavigationController*)window.rootViewController;
        
        
        vc=nav.visibleViewController;
        
    }else{
        
        
        
        vc=window.rootViewController;
        
    }
    
    
    
    return vc.view;
}


@end
