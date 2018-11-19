//
//  FeedBackController.m
//  文俊购房
//
//  Created by 俊帅 on 17/5/6.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "FeedBackController.h"

@interface FeedBackController ()<UITextViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView *activeView;//数据加载动画

@end

@implementation FeedBackController{
    UITextView *inputView;//输入框
    UITextField *phoneField;//手机号输入框
    UILabel *tipLabel;//提示文字
}

//点击空白地方时关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:238/255.0 blue:244/255.0 alpha:1]];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavTitle:@"意见反馈" AndImg:nil];
    [self setNavLeftBtnWithTitle:nil OrImage:@[@"返回"]];
    
    
    //点击登录按钮时，返回上一个界面
    __weak FeedBackController *obj = self;
    
    self.btnClick = ^(UIButton *sender){
        //点击返回按钮时
        if (sender.tag == 1) {
            [obj.navigationController popViewControllerAnimated:YES];
        }
        
    };
    
    [self createView];
}

-(void)createView{
    
    //意见框多行输入，使用UITextView
    inputView = [UITextView new];
    [self.view addSubview:inputView];
    inputView.font = [UIFont systemFontOfSize:15];
    inputView.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//使文字在左上角显示
    
    [inputView setBackgroundColor:[UIColor whiteColor]];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
        make.height.mas_equalTo(150);
    }];
    
    //提示文字
    tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 67, 200, 20)];
    [self.view addSubview:tipLabel];
    
    tipLabel.enabled = NO;//设为不可编辑
    tipLabel.text = @"请输入您宝贵的意见!";
    tipLabel.font =  [UIFont systemFontOfSize:15];
    tipLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tipLabel];
   
    //手机号标签
    UILabel *phoneLabel = [UILabel new];
    [self.view addSubview:phoneLabel];
    [phoneLabel setBackgroundColor:[UIColor grayColor]];
    phoneLabel.text = @"手机号";
    phoneLabel.textAlignment = NSTextAlignmentCenter;//居中
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(inputView.mas_bottom).offset(20);
        //设置大小
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    //手机号输入框
    phoneField = [UITextField new];
    [self.view addSubview:phoneField];
    phoneField.borderStyle = UITextBorderStyleRoundedRect;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;//键盘格式为数字键盘
    phoneField.placeholder = @"请输入手机号码(选填)";//背景提示文字
    
    
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneLabel.mas_centerY);//设置中心Y值在屏幕中心
        make.left.equalTo(phoneLabel.mas_right).offset(5);//设置左
        make.height.mas_equalTo(phoneLabel.mas_height);//设置高度
        make.right.mas_equalTo(self.view).with.offset(-20);
    }];
    
    //确认按钮
    UIButton *sendBtn = [UIButton new];
    [self.view addSubview:sendBtn];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:38/255.0 green:190/255.0 blue:114/255.0 alpha:1]];
    
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(senBtnClick) forControlEvents:UIControlEventTouchDown];
    sendBtn.layer.cornerRadius = 10;
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);//设置中心Y值在屏幕中心
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(phoneLabel.mas_height);//设置高度
        make.width.mas_equalTo(100);
    }];

    //数据加载旋转图标
    self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
    [self.view addSubview:self.activeView];
    self.activeView.backgroundColor = [UIColor blackColor];
}

//编辑文字前后
-(void)textViewDidChange:(UITextView *)textView{
    if(inputView.text.length == 0){
        tipLabel.hidden = NO;
    }else
        tipLabel.hidden = YES;
}

//发送反馈信息
-(void)senBtnClick{
    if (inputView.text.length == 0) {
        [Tip myTip:@"请输入您的反馈意见！"];
        return;
    }
    
    AVObject *object = [AVObject objectWithClassName:@"FeedBack"];
    [object setObject:inputView.text forKey:@"content"];
    [object setObject:phoneField.text forKey:@"phoneNumber"];
    
    [self.activeView startAnimating];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [Tip myTip:@"评论成功!"];
            inputView.text = @"";
        }else{
            [Tip myTip:@"评论失败!"];
            phoneField.text = @"";
        }
        
        [self.activeView stopAnimating];
    }];
}


@end
