//
//  Loginview.m
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "Loginview.h"

@implementation Loginview{
    UIButton *btn;
    UITextField *tellfield;
    UITextField *passfield;
    UIButton *loginbtn;
    UIButton *forgetbtn;
}

//画图一定要在UIVW类中画，才会有下面这个方法来画
-(void)drawRect:(CGRect)rect{
    [self drawLine];
}

//画线
-(void)drawLine{
    [[UIColor lightGrayColor]set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画线的起点
    CGContextMoveToPoint(context, 40, 90);
    //画线的顶点
    CGContextAddLineToPoint(context, k_w - 40, 90);
    
    CGContextMoveToPoint(context, 40, 140);
    CGContextAddLineToPoint(context, k_w - 40, 140);
    
    CGContextMoveToPoint(context, CGRectGetMinX(forgetbtn.frame),CGRectGetMaxY(forgetbtn.frame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(forgetbtn.frame),CGRectGetMaxY(forgetbtn.frame));
    
    CGContextStrokePath(context);
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat btnW = 30;
        CGFloat btnH = 30;
        CGFloat starX = 50;
        CGFloat starY = 50;
        CGFloat space = 20;
        
        NSArray *arr = @[@"手机号",@"密码"];
        NSArray *tips = @[@"请输入手机号码",@"请输入密码"];
        
        for (int i = 0; i < arr.count; i++) {
            CGFloat col = i % 2;
            CGFloat y = starY + (btnH + space) * col;
            btn = [[UIButton alloc]initWithFrame:(CGRect){starX,y,btnW,btnH}];
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            [self addSubview:btn];
            if (i == 0) {
                tellfield = [[UITextField alloc]initWithFrame:(CGRect){CGRectGetMaxX(btn.frame) + 10,y,250,btnH}];
                tellfield.keyboardType = UIKeyboardTypeNumberPad;
                tellfield.placeholder = tips[i];
                tellfield.delegate = self;
                [self addSubview:tellfield];

            }else if (i == 1){
                passfield = [[UITextField alloc]initWithFrame:(CGRect){CGRectGetMaxX(btn.frame) + 10,y,250,btnH}];
                passfield.placeholder = tips[i];
                passfield.delegate = self;
                //密码隐藏输入
                passfield.secureTextEntry = YES;
                [self addSubview:passfield];
            }
        }
        
        CGFloat loginbtnW = 250;
        loginbtn = [[UIButton alloc]initWithFrame:(CGRect){(self.frame.size.width - loginbtnW) / 2,CGRectGetMaxY(btn.frame) + 40,loginbtnW,40}];
        [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
        loginbtn.backgroundColor = [UIColor orangeColor];
        loginbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        loginbtn.layer.cornerRadius = 10;
        loginbtn.layer.masksToBounds = YES;
        
        //添加检查事件
        [loginbtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginbtn];
        
        
        //忘记密码铵钮
        CGFloat forgetbtnW = 70;
        CGFloat forgetbtnX = k_w - 100;
        CGFloat forgetbtnY = CGRectGetMaxY(loginbtn.frame) + 20;
        forgetbtn = [[UIButton alloc]initWithFrame:(CGRect){forgetbtnX,forgetbtnY,forgetbtnW,25}];
        [forgetbtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [forgetbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:forgetbtn];
        
        //添加事件，以调用代码块
        [forgetbtn addTarget:self action:@selector(forgetEvent) forControlEvents:UIControlEventTouchUpInside];
        
        
        //数据加载旋转图标
        self.activeView = [[UIActivityIndicatorView alloc]initWithFrame:(CGRect){(k_w - 50) / 2,(k_h - 50) / 2,50,50}];
        [self addSubview:self.activeView];
        self.activeView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)forgetEvent{//忘记密码代码块
    self.forgetblock();
}

//检测输入框的内容是否符合要求
-(void)check{
    //tellfield.text = @"15507835782";
    //passfield.text = @"hello7566";
    
    //检测手机号是否为空
    if ([tellfield.text isEqualToString:@""]) {
        [Tip myTip:@"手机号码不能为空!"];
    }
    
    //检测手机位数是否正确，要求11
    else if (tellfield.text.length != 11) {
        [Tip myTip:@"手机号码位数不对!"];
        tellfield.text = @"";
    }
    
    //检测密码是否为空
    else if ([passfield.text isEqualToString:@""]) {
        [Tip myTip:@"密码不能为空!"];
        passfield.text = @"";
    }
    
    //检测密码是否为空
    else if (passfield.text.length < 6) {
        [Tip myTip:@"密码位数不对!"];
        passfield.text = @"";
    }

    else
    {
        //建立err提示
        NSError *err = nil;
        
        [self.activeView startAnimating];
        //用手机号和密码登录
        [AVUser logInWithMobilePhoneNumber:tellfield.text password:passfield.text error:&err];
        
        if (err == nil) {
            
            AVUser *currentUser = [AVUser currentUser];
            
            [Sington sharSington].tell = currentUser.mobilePhoneNumber;//电话
            [Sington sharSington].name = [currentUser objectForKey:@"username"];
            [Sington sharSington].isLogin = YES;
            
            //获取图片url
            AVFile *file = [currentUser objectForKey:@"image"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [Sington sharSington].img = image;//头像
                
                [self.activeView stopAnimating];
                [Tip myTip:@"登录成功!"];
                self.loginblock();//利用代码块返回上一个界面
            }];
            
            tellfield.text = @"";
            passfield.text = @"";

        }
        else if (err.code == -1001){
            [self.activeView stopAnimating];
            [Tip myTip:@"请求超时！"];
        }
        
        else{
            //当输入账号和密码错误时
            [self.activeView stopAnimating];
            [Tip myTip:@"该用户不存在!"];
            tellfield.text = @"";
            passfield.text = @"";
        }
    }
}

//限制textField输入字符的个数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == tellfield) {
//        //输入11个后就不可继续，现在已为11个，大于10，变为NO
//        if (tellfield.text.length > 10) {
//            return NO;
//        }
//    }
    
    //输入密码位数不能超过16
    if (textField == passfield){
        if (passfield.text.length > 15) {
            return NO;
        }
    }
    return YES;
}

@end
