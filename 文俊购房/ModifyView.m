//
//  ModifyView.m
//  文俊购房
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "ModifyView.h"

@implementation ModifyView{
    UILabel *la;
}

//画图一定要在UIVW类中画，才会有下面这个方法来画
-(void)drawRect:(CGRect)rect{
    [self drawLine];
}

//画线
-(void)drawLine{
    [[UIColor lightGrayColor]set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 70);
    CGContextAddLineToPoint(context, self.frame.size.width, 70);
    
    CGContextMoveToPoint(context, 0, 120);
    CGContextAddLineToPoint(context, self.frame.size.width, 120);
    
    CGContextMoveToPoint(context, 0, 170);
    CGContextAddLineToPoint(context, self.frame.size.width, 170);
    
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
        NSArray *arr = @[@"旧密码",@"新密码",@"确认密码"];
        NSArray *tips = @[@"请输入现在的登录密码",@"6-20个数字、字母或符号组成",@"请再次输入新密码"];
        for (int i = 0; i < arr.count; i++) {
            CGFloat col = i % 4;
            CGFloat y = starY + (btnH + space) * col;
            la = [[UILabel alloc]initWithFrame:(CGRect){starX,y,btnW,btnH}];
            la.text = arr[i];
            la.font = [UIFont systemFontOfSize:20];
            la.textAlignment = NSTextAlignmentCenter;
            la.textColor = [UIColor blackColor];
            [self addSubview:la];
            
            //旧密码
            if (i == 0) {
                CGFloat tellfieldX = CGRectGetMaxX(la.frame);
                CGFloat tellfieldW = self.frame.size.width - tellfieldX;
                _oldfield = [[UITextField alloc]initWithFrame:(CGRect){tellfieldX,y,tellfieldW,btnH}];
                _oldfield.placeholder = tips[i];
                _oldfield.delegate = self;
                _oldfield.secureTextEntry = YES;
                [self addSubview:_oldfield];
              
            //新密码
            }else if (i == 1){
                CGFloat passfieldX = CGRectGetMaxX(la.frame);
                CGFloat passfieldW = self.frame.size.width - passfieldX;
                _passfield = [[UITextField alloc]initWithFrame:(CGRect){passfieldX,y,passfieldW,btnH}];
                _passfield.placeholder = tips[i];
                _passfield.delegate = self;
                _passfield.secureTextEntry = YES;
                [self addSubview:_passfield];
             
            //再次输入新密码
            }else if(i == 2){
                CGFloat nameX = CGRectGetMaxX(la.frame);
                CGFloat nameW = self.frame.size.width - nameX;
                _againfield = [[UITextField alloc]initWithFrame:(CGRect){nameX,y,nameW,btnH}];
                _againfield.placeholder = tips[i];
                _againfield.delegate = self;
                _againfield.secureTextEntry = YES;
                [self addSubview:_againfield];
            }
        }
    }
    return self;
}

//限制textField的输入字符个数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _oldfield) {
        //输入11个后就不可继续，现在已为11个，大于10，变为NO
        if (_oldfield.text.length > 15)
            return NO;
    }else if (textField == _passfield){
        if (_passfield.text.length > 15) {
            return NO;
        }
    }else if (textField == _againfield){
        if (_againfield.text.length > 15) {
            return NO;
        }
    }
    return YES;
}

@end
