//
//  PhoneVerifyController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/4.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "PhoneVerifyController.h"

@interface PhoneVerifyController()

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation PhoneVerifyController{
    UITextField *phoneField;//手机输入框
    UITextField *codeField;
    UIButton *sendBtn;
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
    
    [self setNavTitle:@"手机绑定" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    //点击登录按钮时，返回上一个界面
    
    __weak PhoneVerifyController *obj = self;
    self.btnClick = ^(UIButton *sender){
        //点击返回按钮时
        if (sender.tag == 1) {
            [obj.tabBarController setHidesBottomBarWhenPushed:NO];
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
}

-(void)createView{
    
    //手机号标签
    UILabel *phoneLabel = [UILabel new];
    [self.view addSubview:phoneLabel];
    [phoneLabel setBackgroundColor:[UIColor grayColor]];
    phoneLabel.text = @"手机号";
    phoneLabel.textAlignment = NSTextAlignmentCenter;//居中
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(120);
        //设置大小
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    //手机号输入框
    phoneField = [UITextField new];
    [self.view addSubview:phoneField];
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;//键盘格式为数字键盘
    phoneField.placeholder = @"请输入手机号码";//背景提示文字
    
    
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(phoneLabel.mas_right).offset(5);//设置左
        make.height.mas_equalTo(phoneLabel.mas_height);//设置高度
        
    }];
    
    //发送按钮
    sendBtn = [UIButton new];
    [self.view addSubview:sendBtn];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:38/255.0 green:190/255.0 blue:114/255.0 alpha:1]];
    
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchDown];
    sendBtn.layer.cornerRadius = 10;
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(phoneField.mas_right).offset(5);//设置左
        make.right.equalTo(self.view).with.offset(-5);//设置右
        make.height.mas_equalTo(phoneLabel.mas_height);//设置高度
    }];
    
    //验证码标签
    UILabel *codeLabel = [UILabel new];
    [self.view addSubview:codeLabel];
    [codeLabel setBackgroundColor:[UIColor grayColor]];
    codeLabel.text = @"验证码";
    codeLabel.textAlignment = NSTextAlignmentCenter;//居中
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLabel.mas_left);
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(20);
        //设置大小
        make.size.mas_equalTo(phoneLabel);
    }];
    
    //验证码输入框
    codeField = [UITextField new];
    [self.view addSubview:codeField];
    codeField.borderStyle = UITextBorderStyleRoundedRect;
    codeField.keyboardType = UIKeyboardTypeNumberPad;//键盘格式为数字键盘
    codeField.placeholder = @"请输入验证码";//背景提示文字

    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(codeLabel.mas_right).offset(5);//设置左
        make.height.mas_equalTo(codeLabel.mas_height);//设置高度
        make.width.mas_equalTo(phoneField.mas_width);
    }];
    
    //确认按钮
    UIButton *confirmBtn = [UIButton new];
    [self.view addSubview:confirmBtn];
    [confirmBtn setBackgroundColor:[UIColor orangeColor]];
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

//点击发送按钮索要手机验证码时
-(void)sendBtnClick{
    
    if ([phoneField.text isEqualToString:@""]) {
        [Tip myTip:@"请输入手机号!"];
    }
    else if (phoneField.text.length != 11) {
        [Tip myTip:@"手机号位数错误!"];
        phoneField.text = @"";
    }
    
    else{
        
        [self.activeView startAnimating];
        //发送手机短信
        [AVUser requestMobilePhoneVerify:phoneField.text withBlock:^(BOOL succeeded, NSError * _Nullable error){
            if (succeeded) {
                [Tip myTip:@"发送短信成功!"];
            }
            
            else if (error.code == 213) {//错误编码213，该手机号未注册
                [Tip myTip:@"该手机号未注册!"];
                phoneField.text = @"";
            }
         
            else {
                [Tip myTip:@"发送短信失败!"];
            }
            
            [self.activeView stopAnimating];
        }];
        
    }
}


//点击确认按钮时
-(void)confirmBtnClick{
    
    if ([codeField.text isEqualToString:@""]) {
        [Tip myTip:@"验证码不能为空!"];
    }
    else{
        [self.activeView startAnimating];
        
        [AVUser verifyMobilePhone:codeField.text withBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [Tip myTip:@"验证成功!"];
                [self.tabBarController setHidesBottomBarWhenPushed:NO];
                [self.navigationController popToRootViewControllerAnimated:YES];
    
            }
            
            else if (error.code == 603) {//错误编码213，该手机号未注册
                [Tip myTip:@"无效的短信验证码!"];
                codeField.text = @"";
            }
            
            else{
                [Tip myTip:@"验证码错误!"];
            }
            
            [self.activeView stopAnimating];
        }];
    }
}

@end
