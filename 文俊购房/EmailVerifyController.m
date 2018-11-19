//
//  EmailVerifyController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/5.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "EmailVerifyController.h"

@interface EmailVerifyController ()

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation EmailVerifyController{
    UITextField *codeField;
}

//点击空白地方时关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBarHidden = NO;
    
    //隐藏底部导航栏
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    
    [self setNavTitle:@"邮箱绑定" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    //点击登录按钮时，返回上一个界面
    
    __weak EmailVerifyController *obj = self;
    
    self.btnClick = ^(UIButton *sender){
        //点击返回按钮时
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
            obj.tabBarController.hidesBottomBarWhenPushed = NO;
        }
    };
    
    [self createView];
}

-(void)createView{
    
    //验证码标签
    UILabel *codeLabel = [UILabel new];
    [self.view addSubview:codeLabel];
    [codeLabel setBackgroundColor:[UIColor grayColor]];
    codeLabel.text = @"邮箱";
    codeLabel.textAlignment = NSTextAlignmentCenter;//居中
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(30);
        make.top.equalTo(self.view).with.offset(120);
        //设置大小
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    //验证码输入框
    codeField = [UITextField new];
    [self.view addSubview:codeField];
    codeField.borderStyle = UITextBorderStyleRoundedRect;
    codeField.keyboardType = UIKeyboardTypeDefault;//键盘格式为数字键盘
    codeField.placeholder = @"请输入邮箱";//背景提示文字
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(codeLabel.mas_right).offset(5);//设置左
        make.right.equalTo(self.view).with.offset(-30);//设置右
        make.height.mas_equalTo(codeLabel.mas_height);//设置高度
    }];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton new];
    [self.view addSubview:confirmBtn];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:38/255.0 green:190/255.0 blue:114/255.0 alpha:1]];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 10;
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeField.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.centerX.mas_equalTo(self.view.mas_centerX);//将其中心X设在屏幕中心X
    }];
    
    //添加确认事件
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchDown];
    
    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}

//点击确认按钮时
-(void)confirmBtnClick{
    
    if ([codeField.text isEqualToString:@""]) {
        [Tip myTip:@"请输入邮箱!"];
    }
    else{
        [self.activeView startAnimating];
        
        //发送邮箱进行密码修改
        [AVUser requestEmailVerify:codeField.text withBlock:^(BOOL succeeded, NSError * _Nullable error){
            if (succeeded) {
                [Tip myTip:@"发送邮件成功!"];
            }
            
            else if(error.code == 205){
                [Tip myTip:@"用户邮箱不存在!"];
            }
            else if(error.code == 1){
                [Tip myTip:@"请不要往同一个邮件地址发送太多邮件!"];
            }
            else{
                [Tip myTip:@"邮箱发送失败!"];
            }
            
            [self.activeView stopAnimating];
        }];
        
        
    }
}

@end
