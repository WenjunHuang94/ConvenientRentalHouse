//
//  ForgetView.m
//  文俊购房
//
//  Created by 俊帅 on 17/4/9.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ForgetView.h"

@implementation ForgetView{
    UILabel *la;//内容标签
    UIButton *confirmBtn;//确认按钮
    UILabel *successLa;//修改密码成功标签
}





//画图一定要在UIVW类中画，才会有下面这个方法来画
-(void)drawRect:(CGRect)rect{
    [self drawLine];
}

//画下画线
-(void)drawLine{
    
    [[UIColor lightGrayColor]set];
    
    CGContextRef context = UIGraphicsGetCurrentContext(); //内容面版
    
    CGContextMoveToPoint(context, 0, 70);//线的起点
    CGContextAddLineToPoint(context, self.frame.size.width, 70);//终点
    
    CGContextMoveToPoint(context, 0, 120);
    CGContextAddLineToPoint(context, self.frame.size.width, 120);
    
    CGContextMoveToPoint(context, 0, 170);
    CGContextAddLineToPoint(context, self.frame.size.width, 170);
    
    CGContextStrokePath(context); //渲染，才会出现
}


//视图构造初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //设置位置的参数
        CGFloat btnW = 100;
        CGFloat btnH = 30;
        CGFloat starX = 10;
        CGFloat starY = 30;
        CGFloat space = 20;
        
        //各栏的内容
        NSArray *arr = @[@"手机号码",@"安全码",@"新密码"];
        NSArray *tips = @[@"请填写正确的手机号码",@"输入6位数安全码",@"6-16个数字、字母或符号组成"];
        
        //添加各个控件
        for(int i = 0;i < arr.count;i++){
            CGFloat col = i;
            CGFloat y = starY + (btnH + space) * col;
            
            //设置内容标签
            la = [[UILabel alloc]initWithFrame:(CGRect){starX,y,btnW,btnH}];
            la.text = arr[i];
            la.font = [UIFont systemFontOfSize:20];//设置文字字体
            la.textAlignment = NSTextAlignmentCenter;//让文字居中
            la.textColor = [UIColor lightGrayColor];
            [self addSubview:la];
            
            //用于输入手机号
            if (i == 0) {
                CGFloat tellfieldX = CGRectGetMaxX(la.frame);//取起点
                CGFloat tellfieldW = self.frame.size.width - tellfieldX;
                _tellfield = [[UITextField alloc]initWithFrame:(CGRect){tellfieldX,y,tellfieldW,btnH}];
                
                _tellfield.keyboardType = UIKeyboardTypeNumberPad;//键盘格式为数字键盘
                _tellfield.placeholder = tips[i];//背景提示文字
                _tellfield.delegate = self;//设置代理，要求限制输入位数
                [self addSubview:_tellfield];
                
                //安全码，用于找回密码
            }else if (i == 1){
                CGFloat identifyingCodeFieldX = CGRectGetMaxX(la.frame);
                CGFloat identifyingCodeFieldW = self.frame.size.width - identifyingCodeFieldX;
                _identifyingCodeField = [[UITextField alloc]initWithFrame:(CGRect){identifyingCodeFieldX,y,identifyingCodeFieldW,btnH}];
                
                _identifyingCodeField.keyboardType = UIKeyboardTypeNamePhonePad;//键盘格式为数字键盘
                _identifyingCodeField.placeholder = tips[i];
                _identifyingCodeField.delegate = self;
                _identifyingCodeField.secureTextEntry = YES;
                [self addSubview:_identifyingCodeField];
                
                //用于设置用户密码
            }else if (i == 2){
                CGFloat passfieldX = CGRectGetMaxX(la.frame);
                CGFloat passfieldW = self.frame.size.width - passfieldX;
                _passfield = [[UITextField alloc]initWithFrame:(CGRect){passfieldX,y,passfieldW,btnH}];
                
                _passfield.placeholder = tips[i];
                _passfield.delegate = self;
                _passfield.secureTextEntry = YES;//密码进行隐藏
                [self addSubview:_passfield];
            }
        }
        
        //确认按钮
        CGFloat confirmBtnW = 250;
        confirmBtn = [[UIButton alloc]initWithFrame:(CGRect){(self.frame.size.width - confirmBtnW) / 2,CGRectGetMaxY(_passfield.frame) + 40,confirmBtnW,40}];
        [confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        
        confirmBtn.backgroundColor = [UIColor orangeColor];
        confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        confirmBtn.layer.cornerRadius = 10;
        confirmBtn.layer.masksToBounds = YES;
        [self addSubview:confirmBtn];
        
        //点击确认时，检查用户信息
        [confirmBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

//检测输入框的内容是否符合要求
-(void)check{
    
    //检测手机号是否为空
    if ([_tellfield.text isEqualToString:@""]) {
        [Tip myTip:@"手机号码不能为空!"];
    }
    
    //检测手机位数是否正确，要求11
    else if (_tellfield.text.length < 11) {
        [Tip myTip:@"手机号码位数不对!"];
        _tellfield.text = @"";
    }
    
    //检测安全码是否为空
    else if ([_identifyingCodeField.text isEqualToString:@""]) {
        [Tip myTip:@"安全码不能为空!"];
        _identifyingCodeField.text = @"";
    }
    
    //检测密码是否为空
    else if ([_passfield.text isEqualToString:@""]) {
        [Tip myTip:@"密码不能为空!"];
        _passfield.text = @"";
    }
    
    //检测密码位数是否正确，要求不少于6，6~16
    else if (_passfield.text.length < 6) {
        [Tip myTip:@"密码位数不对!"];
        _passfield.text = @"";
    }
    
    else
    {
        //加载用户数据
//        NSArray *data = [User loadUserData];
//        //找到对应用户并修改密码
//        for (User *user in data) {
//            
//            //当输入账号和安全码正确时，即可修改密码
//            if ([_tellfield.text isEqualToString:user.tell] && [_identifyingCodeField.text isEqualToString:user.identyfyNum]) {
//                
//                user.passwd = _passfield.text;//修改新密码
//                [User saveUserData:data];//保存新密码
//                //登录成功提示
//                [self successTip];
//            }
//        }
        
        
        //当输入账号和安全码错误时
        [Tip myTip:@"手机号和安全码错误!"];
        
        //清空输入栏所有数据
        _tellfield.text = @"";
        _identifyingCodeField.text = @"";
        _passfield.text = @"";
        
    }
}

//登录成功时进行标签提示
-(void)successTip{
    
    CGFloat laW = 250;
    CGFloat laH = 60;
    CGFloat laX = (self.superview.frame.size.width - laW) / 2;
    CGFloat laY = (self.superview.frame.size.height - laH) / 2;
    successLa =[[UILabel alloc]initWithFrame:(CGRect){laX,laY,laW,laH}];
    successLa.text = @"修改密码成功！";
    successLa.textAlignment = NSTextAlignmentCenter;
    successLa.font = [UIFont systemFontOfSize:15];
    successLa.backgroundColor = [UIColor lightGrayColor];
    successLa.textAlignment = NSTextAlignmentCenter;
    successLa.font = [UIFont systemFontOfSize:15];
    successLa.backgroundColor = [UIColor lightGrayColor];
    successLa.alpha = 0;
    successLa.layer.cornerRadius = 10;
    successLa.layer.masksToBounds = YES;
    [self.superview addSubview:successLa];
    [UIView animateWithDuration:1 animations:^{
        successLa.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            successLa.alpha = 0;
        } completion:^(BOOL finished) {
            [successLa removeFromSuperview];
        }];
    }];
}


//限制textField的输入字符个数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //电话号码输入11个后就不可继续，现在已为11个，大于10，变为NO
    if (textField == _tellfield) {
        if (_tellfield.text.length > 10)
            return NO;
        
    }
    
    //验证码输入6个后就不可继续，变为NO
    else if (textField == _identifyingCodeField){
        if (_identifyingCodeField.text.length > 5) {
            return NO;
        }
    }
    
    //密码输入16个后就不可继续，变为NO
    else if (textField == _passfield){
        if (_passfield.text.length > 15) {
            return NO;
        }
    }
    return YES;
}


@end
