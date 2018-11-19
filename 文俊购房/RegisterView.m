//
//  RegisterView.m
//  文俊购房
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "RegisterView.h"

@implementation RegisterView{
    UILabel *la;
}

//画图一定要在UIVW类中画，才会有下面这个方法来画
-(void)drawRect:(CGRect)rect{
    [self drawLine];
}

-(void)drawLine{
    [[UIColor lightGrayColor]set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 70);
    CGContextAddLineToPoint(context, k_w, 70);
    
    CGContextMoveToPoint(context, 0, 120);
    CGContextAddLineToPoint(context, k_w, 120);
    
    CGContextMoveToPoint(context, 0, 170);
    CGContextAddLineToPoint(context, k_w, 170);
    
    CGContextMoveToPoint(context, 0, 220);
    CGContextAddLineToPoint(context, k_w, 220);
    
    CGContextMoveToPoint(context, 0, 270);
    CGContextAddLineToPoint(context, k_w, 270);
    
//    CGContextMoveToPoint(context, 0, 320);
//    CGContextAddLineToPoint(context, self.frame.size.width, 320);
    
    CGContextStrokePath(context);
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat btnW = 100;
        CGFloat btnH = 30;
        CGFloat starX = 10;
        CGFloat starY = 30;
        CGFloat space = 20;
        
        //NSArray *arr = @[@"手机号码",@"安全码",@"邮箱",@"登陆密码",@"用户名",@"所在城市"];
        //NSArray *tips = @[@"请填写正确的手机号码",@"请输入6位安全码",@"请输入邮箱",@"6-16个数字、字母或符号组成",@"请填写用户名",@"请选择城市"];
        NSArray *arr = @[@"手机号码",@"邮箱",@"登陆密码",@"用户名",@"所在城市"];
        NSArray *tips = @[@"请填写正确的手机号码",@"请输入邮箱",@"6-16个数字、字母或符号组成",@"请填写用户名",@"请选择城市"];
        
        for (int i = 0; i < arr.count; i++) {
            CGFloat col = i;
            CGFloat y = starY + (btnH + space) * col;//取Y值，X值都一样
            
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
                [self addSubview:_tellfield];
             
            
            }
            
//            //安全码
//            else if (i == 1){
//                CGFloat codeFieldX = CGRectGetMaxX(la.frame);
//                CGFloat codeFieldW = self.frame.size.width - codeFieldX;
//                _codeField = [[UITextField alloc]initWithFrame:(CGRect){codeFieldX,y,codeFieldW,btnH}];
//                
//                _codeField.keyboardType = UIKeyboardTypeNumberPad;//键盘格式为数字键盘
//                _codeField.placeholder = tips[i];
//                _codeField.secureTextEntry = YES;
//                [self addSubview:_codeField];
//                
//                //用于设置用户密码
//            }
            
            //邮箱，用于找回密码
            else if (i == 1){
                CGFloat mailFieldX = CGRectGetMaxX(la.frame);
                CGFloat mailFieldW = self.frame.size.width - mailFieldX;
                _mailField = [[UITextField alloc]initWithFrame:(CGRect){mailFieldX,y,mailFieldW,btnH}];
                
                _mailField.placeholder = tips[i];

                [self addSubview:_mailField];
                
            //用于设置用户密码
            }else if (i == 2){
                CGFloat passfieldX = CGRectGetMaxX(la.frame);
                CGFloat passfieldW = self.frame.size.width - passfieldX;
                _passfield = [[UITextField alloc]initWithFrame:(CGRect){passfieldX,y,passfieldW,btnH}];
                
                _passfield.placeholder = tips[i];
                //_passfield.delegate = self;
                _passfield.secureTextEntry = YES;//密码进行隐藏
                [self addSubview:_passfield];
                
            //用于设置用户名
            }else if(i == 3){
                CGFloat nameX = CGRectGetMaxX(la.frame);
                CGFloat nameW = self.frame.size.width - nameX;
                _name = [[UITextField alloc]initWithFrame:(CGRect){nameX,y,nameW,btnH}];
                _name.placeholder = tips[i];
                [self addSubview:_name];
                
            //选择用户所在城市
            }else if(i == 4){
                CGFloat cityX = CGRectGetMaxX(la.frame);
                CGFloat cityW = self.frame.size.width - cityX;
                
                _city = [[UIButton alloc]initWithFrame:(CGRect){cityX,y,cityW,btnH}];
                [_city setTitle:tips[i] forState:UIControlStateNormal];
                [_city setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                //点击时跳到选择城市界面
                [_city addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_city];
                
                UIImageView *imgview = [[UIImageView alloc]initWithFrame:(CGRect){self.frame.size.width - 40,y,btnH,btnH}];
                imgview.image = [UIImage imageNamed:@"向右箭头"];
                [self addSubview:imgview];
            }
        }
        
    }
    return self;
}

//用于跳到选择城市界面
-(void)selectCity{
    self.selectBlock();
}


@end
