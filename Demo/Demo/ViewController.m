//
//  ViewController.m
//  Demo
//
//  Created by wanve on 2018/11/27.
//  Copyright © 2018年 wanve. All rights reserved.
//

#import "ViewController.h"
#import <TencentLBS/TencentLBS.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface ViewController ()<TencentLBSLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (readwrite, nonatomic, strong) TencentLBSLocationManager *locationManager;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *labLocate;
@property(nonatomic, strong) TencentLBSLocation *location;

@end

@implementation ViewController

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 160, 200, 200)];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *btnPhoto = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 80, 50)];
    [btnPhoto setTitle:@"拍照" forState:UIControlStateNormal];
    btnPhoto.backgroundColor = [UIColor brownColor];
    btnPhoto.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnPhoto];
    
    [btnPhoto addTarget:self action:@selector(photoCall:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnUpload = [[UIButton alloc]initWithFrame:CGRectMake(150, 50, 80, 50)];
    [btnUpload setTitle:@"上传" forState:UIControlStateNormal];
    btnUpload.backgroundColor = [UIColor redColor];
    btnUpload.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnUpload];
    
    [btnUpload addTarget:self action:@selector(uploadCall:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnVerify = [[UIButton alloc]initWithFrame:CGRectMake(250, 50, 80, 50)];
    [btnVerify setTitle:@"识别" forState:UIControlStateNormal];
    btnVerify.backgroundColor = [UIColor orangeColor];
    btnVerify.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnVerify];
    
    [btnVerify addTarget:self action:@selector(verifyCall:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 400, [UIScreen mainScreen].bounds.size.width - 20, 250)];
    [self.view addSubview:lab];
    lab.numberOfLines = 0;
    self.labLocate = lab;
    
    [self configLocationManager];
    [self startUpdatingLocation];
}

- (void)verifyCall:(UIButton *)sender
{
    [self presentViewController:[NSClassFromString(@"VerifyViewController") new] animated:YES completion:nil];
}

- (void)uploadCall:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"上传中，请稍等..."];
    
    //1.创建一个请求管理者
    //AFHTTPRequestOperationManager内部封装了URLSession
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送请求
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *dateString = [fmt stringFromDate:self.location.location.timestamp];
    
    param[@"UserID"] = @"1";
    param[@"UserName"] = @"1";
    param[@"UserAccount"] = @"1";
    param[@"DateTime"] = dateString;
    param[@"Address"] = self.location.address;
    param[@"Latitude"] = [NSString stringWithFormat:@"%f", self.location.location.coordinate.latitude];
    param[@"Longitude"] = [NSString stringWithFormat:@"%f", self.location.location.coordinate.longitude];
   
    NSString *url = @"https://www.zhihuigongwu.com/Jelly/PunchRecord/Add";
    
    [manager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        NSLog(@"请求成功--%@",responseObject);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功 dict--%@",dict);
        
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        self.view.userInteractionEnabled = YES;
        NSLog(@"请求失败--%@",error);
        [SVProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

- (void)photoCall:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera; // 设置控制器类型
    // UIImagePickerController继承UINavigationController实现UINavigationDelegate和UIImagePickerControllerDelegate
    picker.delegate = self; // 设置代理
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Action Handle

- (void)configLocationManager {
    
    self.locationManager = [[TencentLBSLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager setApiKey:@"DHDBZ-BUMLF-WLMJA-JSJTQ-R5MQQ-XVF2B"];
    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - TencentLBSLocationManagerDelegate

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                 didFailWithError:(NSError *)error {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位权限未开启，是否开启？" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL success) {
                }];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#endif
            }
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
        
    } else {
        [self.labLocate setText:[NSString stringWithFormat:@"%@", error]];
    }
}

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                didUpdateLocation:(TencentLBSLocation *)location {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *dateString = [fmt stringFromDate:location.location.timestamp];
    
    [self.labLocate setText:[NSString stringWithFormat:@"%@\n %@\n latitude:%f, longitude:%f\n horizontalAccuracy:%f \n verticalAccuracy:%f\n speed:%f\n course:%f\n altitude:%f\n timestamp:%@\n", location.name, location.address, location.location.coordinate.latitude, location.location.coordinate.longitude, location.location.horizontalAccuracy, location.location.verticalAccuracy, location.location.speed, location.location.course, location.location.altitude, dateString]];
    
    self.location = location;
}


@end
