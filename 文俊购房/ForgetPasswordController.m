//
//  ForgetPasswordController.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/7.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "ForgetView.h"



@interface ForgetPasswordController ()

@end

@implementation ForgetPasswordController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNavTitle:@"找回密码" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    __weak ForgetPasswordController *obj = self;
    self.btnClick = ^(UIButton *sender){
        if(sender.tag == 1){
            [obj.navigationController popViewControllerAnimated:YES];
        }

    };
    
    ForgetView *forgetView = [[ForgetView alloc]initWithFrame:(CGRect){0,44,self.view.frame.size.width,self.view.frame.size.height}];
    [self.view addSubview:forgetView];
    
}

@end
