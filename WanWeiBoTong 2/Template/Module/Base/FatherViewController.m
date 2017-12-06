//
//  FatherViewController.m
//  Template
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 李康滨,工作qq:1218773641. All rights reserved.
//

#import "FatherViewController.h"

@interface FatherViewController ()

@end

@implementation FatherViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    UIBarButtonItem*btn_back = [[UIBarButtonItem alloc]init];
    
    btn_back.title = @"";
    
    self.navigationItem.backBarButtonItem= btn_back;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
