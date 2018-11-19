//
//  PasswdPhoneFind.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/5.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "PasswdPhoneFind.h"

@interface PasswdPhoneFind ()

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation PasswdPhoneFind{
    UITextField *phoneField;//手机输入框
    UITextField *codeField;//验证码输入框
    UITextField *passwdField;//密码输入框
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
    
    [self setNavTitle:@"短信找回密码" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    //点击登录按钮时，返回上一个界面
    
    __weak PasswdPhoneFind *obj = self;
    
    self.btnClick = ^(UIButton *sender){
        //点击返回按钮时
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [self createView];
}

//构造控件
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
        make.width.mas_equalTo(140);//设置高度
    }];
    
    //发送按钮
    UIButton *sendBtn = [UIButton new];
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
        
        make.left.equalTo(phoneLabel.mas_left);
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(20);
       
        //尺寸相同
        make.size.mas_equalTo(phoneLabel);
    }];
    
//    验证码输入框
    codeField = [UITextField new];
    [self.view addSubview:codeField];
    codeField.borderStyle = UITextBorderStyleRoundedRect;
    codeField.keyboardType = UIKeyboardTypeNumberPad;//键盘格式为数字键盘
    codeField.placeholder = @"请输入验证码";//背景提示文字
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(codeLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(codeLabel.mas_right).offset(5);//设置左
        make.height.mas_equalTo(codeLabel.mas_height);//设置高度
        make.width.mas_equalTo(phoneField.mas_width);//设置高度
    }];
    
    //新密码标签
    UILabel *passwdLabel = [UILabel new];
    [self.view addSubview:passwdLabel];
    [passwdLabel setBackgroundColor:[UIColor grayColor]];
    passwdLabel.text = @"新密码";
    passwdLabel.textAlignment = NSTextAlignmentCenter;//居中
    
    [passwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(phoneLabel.mas_left);
        make.top.equalTo(codeLabel.mas_bottom).with.offset(20);
        
        //尺寸相同
        make.size.mas_equalTo(phoneLabel);
    }];
    
    //新密码输入框
    passwdField = [UITextField new];
    [self.view addSubview:passwdField];
    passwdField.borderStyle = UITextBorderStyleRoundedRect;
    passwdField.keyboardType = UIKeyboardTypeDefault;//键盘格式为数字键盘
    passwdField.placeholder = @"请输入新密码";//背景提示文字
    
    [passwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(passwdLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(passwdLabel.mas_right).offset(5);//设置左
        make.size.mas_equalTo(phoneField);
    }];
    
    
    //修改密码按钮
    UIButton *confirmBtn = [UIButton new];
    [self.view addSubview:confirmBtn];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:38/255.0 green:190/255.0 blue:114/255.0 alpha:1]];
    [confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = 10;
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwdLabel.mas_bottom).offset(30);
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

//点击确认修改
-(void)confirmBtnClick{
    
    if ([codeField.text isEqualToString:@""]) {
        [Tip myTip:@"请输入验证码!"];
    }
    else if ([passwdField.text isEqualToString:@""]){
        [Tip myTip:@"请输入密码!"];
    }
    else if ((passwdField.text.length < 6) || (passwdField.text.length > 11)){
        [Tip myTip:@"密码位数错误!"];
        passwdField.text = @"";
    }
    else{
        [self.activeView startAnimating];
        
        [AVUser resetPasswordWithSmsCode:codeField.text newPassword:passwdField.text block:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [Tip myTip:@"密码修改成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [Tip myTip:@"验证码错误!"];
            }
            
            [self.activeView stopAnimating];
        }];
    }
    
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
        //发送短信进行密码修改
        [self.activeView startAnimating];
        
        [AVUser requestPasswordResetWithPhoneNumber:phoneField.text block:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [Tip myTip:@"发送短信成功!"];
            }
            
            else if (error.code == 213) {//错误编码213，该手机号未注册
                [Tip myTip:@"该手机号未注册!"];
                phoneField.text = @"";
            }
            else if (error.code == 215) {//错误编码215，该手机号未验证
                [Tip myTip:@"该手机号未验证!"];
                phoneField.text = @"";
            }
            
            else {
                [Tip myTip:@"发送短信失败!"];
            }
            
            [self.activeView stopAnimating];
        }];
        
    }
}

@end
